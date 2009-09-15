# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils multilib toolchain-funcs

DESCRIPTION="Chromium Web Browser"
HOMEPAGE="http://chromium.org/"
SRC_URI="http://build.chromium.org/buildbot/archives/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-arch/bzip2
	dev-libs/libxml2
	dev-libs/libxslt
	>=dev-libs/nss-3.12.2
	>=gnome-base/gconf-2.24.0
	media-fonts/corefonts
	>=media-libs/alsa-lib-1.0.19
	media-libs/jpeg
	media-libs/libpng
	>=media-video/ffmpeg-0.5_p19787
	sys-libs/zlib
	>=x11-libs/gtk+-2.14.7"
#	dev-db/sqlite:3
DEPEND="${RDEPEND}
	>=dev-util/gperf-3.0.3
	>=dev-util/pkgconfig-0.23"

export CHROMIUM_HOME=/usr/$(get_libdir)/chromium-browser

src_prepare() {
	# Workaround for "Argument list too long" bug, see below
	for i in app webkit third_party/ffmpeg build/util base chrome v8/tools/gyp
	do
		ln -s ${S}/out ${i}/out
	done

	# TODO: change gyp version, >=r614 needed to make --as-needed work
}

src_configure() {
	# CFLAGS/LDFLAGS
	mkdir -p "${S}"/.gyp
	cat << EOF > "${S}"/.gyp/include.gypi
{
 'target_defaults': {
  'cflags': [ '${CFLAGS// /','}' ],
  'ldflags': [ '${LDFLAGS// /','}' ],
 },
}
EOF
	export HOME="${S}"

	# Configuration options (system libraries)
	local myconf="-Duse_system_bzip2=1 -Duse_system_zlib=1 -Duse_system_libjpeg=1 -Duse_system_libpng=1 -Duse_system_libxml=1 -Duse_system_libxslt=1 -Duse_system_ffmpeg=1 -Dlinux_use_tcmalloc=1"
	# -Duse_system_sqlite=1 : chromium added initUnixFile() and fillInUnixFile() functions
	# Others still bundled: icu (not possible?), hunspell, libevent

	# Sandbox paths
	myconf="${myconf} -Dlinux_sandbox_path=${CHROMIUM_HOME}/chrome_sandbox -Dlinux_sandbox_chrome_path=${CHROMIUM_HOME}/chrome"

	if use amd64; then
		myconf="${myconf} -Dtarget_arch=x64"
	fi
	if [[ "$(gcc-major-version)$(gcc-minor-version)" == "44" ]]; then
		myconf="${myconf} -Dno_strict_aliasing=1 -Dgcc_version=44"
	fi

	tools/gyp/gyp_chromium -f make build/all.gyp ${myconf} --depth=. || die "gyp failed"
}

src_compile() {
	# Broken for "Argument list too long", waiting for these
	# http://code.google.com/p/chromium/issues/detail?id=19854
	# http://code.google.com/p/gyp/issues/detail?id=71
	# When this is fixed, remove the src_prepare workaround
	# and add back "rootdir=${S}"
	emake -r V=1 chrome chrome_sandbox BUILDTYPE=Release \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		AR=$(tc-getAR) \
		RANLIB=$(tc-getRANLIB) \
		|| die "compilation failed"
}

src_install() {
	# Chromium does not have "install" target in the build system.

	dodir ${CHROMIUM_HOME}

	exeinto ${CHROMIUM_HOME}
	doexe out/Release/chrome
	doexe out/Release/chrome_sandbox
	fperms 4755 ${CHROMIUM_HOME}/chrome_sandbox
	doexe out/Release/xdg-settings
	doexe "${FILESDIR}"/chromium-launcher.sh

	insinto ${CHROMIUM_HOME}
	doins out/Release/chrome.pak

	doins -r out/Release/locales
	doins -r out/Release/resources
	doins -r out/Release/themes

	# Chromium looks for these in its folder
	dosym /usr/$(get_libdir)/libavcodec.so.52 ${CHROMIUM_HOME}
	dosym /usr/$(get_libdir)/libavformat.so.52 ${CHROMIUM_HOME}
	dosym /usr/$(get_libdir)/libavutil.so.50 ${CHROMIUM_HOME}

	# Plugins symlink
	dosym /usr/$(get_libdir)/nsbrowser/plugins ${CHROMIUM_HOME}/plugins

	newicon out/Release/product_logo_48.png ${PN}-browser.png
	dosym ${CHROMIUM_HOME}/chromium-launcher.sh /usr/bin/chromium
	make_desktop_entry chromium "Chromium" ${PN}-browser.png "Network;WebBrowser"
}
