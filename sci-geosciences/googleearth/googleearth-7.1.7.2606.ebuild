# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit pax-utils eutils unpacker fdo-mime gnome2-utils

DESCRIPTION="A 3D interface to the planet"
HOMEPAGE="https://earth.google.com/"
# no upstream versioning, version determined from help/about
# incorrect digest means upstream bumped and thus needs version bump
SRC_URI="x86? ( https://dl.google.com/dl/earth/client/current/google-earth-stable_current_i386.deb
			-> GoogleEarthLinux-${PV}_i386.deb )
	amd64? ( https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb
			-> GoogleEarthLinux-${PV}_amd64.deb )"
LICENSE="googleearth GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror splitdebug"
IUSE=""

QA_PREBUILT="*"

RDEPEND="
	dev-libs/glib:2
	dev-libs/nspr
	media-libs/fontconfig
	media-libs/freetype
	net-misc/curl
	sys-devel/gcc[cxx]
	sys-libs/zlib
	virtual/glu
	virtual/opengl
	virtual/ttf-fonts
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXau
	x11-libs/libXdmcp"

DEPEND="dev-util/patchelf"

S=${WORKDIR}/opt/google/earth/free

pkg_nofetch() {
	einfo "Wrong checksum or file size means that Google silently replaced the distfile with a newer version."
	einfo "By redigesting the file yourself, you will install a different version than the ebuild says, untested!"
}

src_prepare() {

	# we have no ld-lsb.so.3 symlink
	# thanks to Nathan Phillip Brink <ohnobinki@ohnopublishing.net> for suggesting patchelf
	einfo "running patchelf"
	patchelf --set-interpreter /lib/ld-linux$(usex amd64 "-x86-64" "").so.2 ${PN}-bin || die "patchelf failed"

	# Set RPATH for preserve-libs handling (bug #265372).
	local x
	for x in * ; do
		# Use \x7fELF header to separate ELF executables and libraries
		[[ -f ${x} && $(od -t x1 -N 4 "${x}") == *"7f 45 4c 46"* ]] || continue
		fperms u+w "${x}"
		patchelf --set-rpath '$ORIGIN' "${x}" ||
			die "patchelf failed on ${x}"
	done
	# prepare file permissions so that >patchelf-0.8 can work on the files
	fperms u+w plugins/*.so plugins/imageformats/*.so
	for x in plugins/*.so ; do
		[[ -f ${x} ]] || continue
		patchelf --set-rpath '$ORIGIN/..' "${x}" ||
			die "patchelf failed on ${x}"
	done
	for x in plugins/imageformats/*.so ; do
		[[ -f ${x} ]] || continue
		patchelf --set-rpath '$ORIGIN/../..' "${x}" ||
			die "patchelf failed on ${x}"
	done

	epatch "${FILESDIR}"/${PN}-${PV%%.*}-desktopfile.patch
}

src_install() {
	make_wrapper ${PN} ./${PN} /opt/${PN} .

	insinto /usr/share/mime/packages
	doins "${FILESDIR}/${PN}-mimetypes.xml" || die

	domenu google-earth.desktop

	for size in 16 22 24 32 48 64 128 256 ; do
		newicon -s ${size} product_logo_${size}.png google-earth.png
	done

	rm -rf xdg-mime xdg-settings google-earth google-earth.desktop product_logo_*

	insinto /opt/${PN}
	doins -r *

	fperms +x /opt/${PN}/${PN}{,-bin}
	cd "${ED}" || die
	find . -type f -name "*.so.*" -exec fperms +x '{}' +

	pax-mark -m "${ED%/}"/opt/${PN}/${PN}-bin
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
