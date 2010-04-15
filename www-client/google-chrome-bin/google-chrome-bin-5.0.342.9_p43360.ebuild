# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs versionator

# wget -qO- http://dl.google.com/linux/deb/dists/stable/main/binary-amd64/Packages|grep Filename

MY_PN="${PN%-bin}-beta"
#MY_PN="${PN%-bin}-unstable"
MY_P="${MY_PN}_${PV/_p/-r}"
SRC_BASE="http://dl.google.com/linux/deb/pool/main/${MY_PN:0:1}/${MY_PN}/"

DESCRIPTION="Google Chrome web browser (binary)"
HOMEPAGE="http://www.google.com/chrome"
SRC_URI="amd64? ( ${SRC_BASE}${MY_P}_amd64.deb )
	x86? ( ${SRC_BASE}${MY_P}_i386.deb )"

LICENSE="google-chrome"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="mirror strip"
IUSE="+plugins-symlink"

DEPEND="|| ( app-arch/xz-utils app-arch/lzma-utils )
	!~app-arch/deb2targz-1"
RDEPEND="app-arch/bzip2
	>=dev-libs/nss-3.12.3
	>=gnome-base/gconf-2.24.0
	>=media-libs/alsa-lib-1.0.19
	media-libs/jpeg:0
	=media-libs/libpng-1.2*
	>=sys-devel/gcc-4.2
	sys-libs/zlib
	>=x11-libs/gtk+-2.14.7
	x11-libs/libXScrnSaver
	|| (
		x11-themes/gnome-icon-theme
		x11-themes/tango-icon-theme
		x11-themes/xfce4-icon-theme
	)
	x11-misc/xdg-utils
	virtual/ttf-fonts"

# Incompatible system plugins:
# www-plugins/gecko-mediaplayer, bug #309231.
RDEPEND+="
	plugins-symlink? (
		!www-plugins/gecko-mediaplayer[gnome]
	)"

S=${WORKDIR}

QA_EXECSTACK="opt/google/chrome/chrome"

# Ogg/Theora/Vorbis-only FFmpeg binary
QA_TEXTRELS="opt/google/chrome/libffmpegsumo.so"
QA_PRESTRIPPED="opt/google/chrome/libffmpegsumo.so
	opt/google/chrome/chrome
	opt/google/chrome/chrome-sandbox
	opt/google/chrome/libgcflashplayer.so"

pkg_setup() {
	if [[ "${ROOT}" == "/" ]]; then
		# Built with SSE2 enabled, so will fail on older processors
		if ! grep -q sse2 /proc/cpuinfo; then
			die "This binary requires SSE2 support, it will not work on older processors"
		fi

		# Prevent user problems like bug 299777.
		if ! grep -q /dev/shm <<< $(get_mounts); then
			eerror "You don't have tmpfs mounted at /dev/shm."
			eerror "${PN} isn't going to work in that configuration."
			eerror "Please uncomment the /dev/shm entry in /etc/fstab,"
			eerror "run 'mount /dev/shm' and try again."
			die "/dev/shm is not mounted"
		fi
		if [ `stat -c %a /dev/shm` -ne 1777 ]; then
			eerror "/dev/shm does not have correct permissions."
			eerror "${PN} isn't going to work in that configuration."
			eerror "Please run chmod 1777 /dev/shm and try again."
			die "/dev/shm has incorrect permissions"
		fi
	fi
}

src_unpack() {
	unpack ${A}
	lzma -dc data.tar.lzma | tar xof - || die "failure unpackaing data.tar.lzma"
}

src_install() {
	declare CHROME_HOME="opt/google/chrome"

	dodir ${CHROME_HOME}
	cp -R ${CHROME_HOME}/ "${D}"/opt/google \
		|| die "Unable to install chrome folder"

	# chrome refuses to start if sandbox permissions are incorrect
	chmod 4755 "${D}"/${CHROME_HOME}/chrome-sandbox

	# Man page
	doman usr/share/man/man1/google-chrome.1

	# Plugins symlink, optional wrt bug #301911
	if use plugins-symlink; then
		dosym /usr/$(get_libdir)/nsbrowser/plugins ${CHROME_HOME}/plugins
	fi

	# Create symlinks for needed libraries
	dodir ${CHROME_HOME}/nss-nspr
	if has_version ">=dev-libs/nss-3.12.5-r1"; then
		NSS_DIR=/usr/$(get_libdir)
	else
		NSS_DIR=/usr/$(get_libdir)/nss
	fi
	if has_version ">=dev-libs/nspr-4.8.3-r2"; then
		NSPR_DIR=/usr/$(get_libdir)
	else
		NSPR_DIR=/usr/$(get_libdir)/nspr
	fi

	dosym ${NSPR_DIR}/libnspr4.so ${CHROME_HOME}/nss-nspr/libnspr4.so.0d
	dosym ${NSPR_DIR}/libplc4.so ${CHROME_HOME}/nss-nspr/libplc4.so.0d
	dosym ${NSPR_DIR}/libplds4.so ${CHROME_HOME}/nss-nspr/libplds4.so.0d
	dosym ${NSS_DIR}/libnss3.so ${CHROME_HOME}/nss-nspr/libnss3.so.1d
	dosym ${NSS_DIR}/libnssutil3.so ${CHROME_HOME}/nss-nspr/libnssutil3.so.1d
	dosym ${NSS_DIR}/libsmime3.so ${CHROME_HOME}/nss-nspr/libsmime3.so.1d
	dosym ${NSS_DIR}/libssl3.so ${CHROME_HOME}/nss-nspr/libssl3.so.1d

	# Create chrome wrapper
	make_wrapper google-chrome ./chrome /${CHROME_HOME} /${CHROME_HOME}/nss-nspr:${CHROME_HOME}

	# Icon and desktop entry
	newicon ${CHROME_HOME}/product_logo_48.png google-chrome.png
	sed -e "s:Exec=/.*/:Exec=:" -i ${CHROME_HOME}/google-chrome.desktop \
		|| die "desktop sed failed"
	insinto /usr/share/applications
	doins ${CHROME_HOME}/google-chrome.desktop

	# Gnome default application entry
	dodir /usr/share/gnome-control-center/default-apps
	insinto /usr/share/gnome-control-center/default-apps
	doins usr/share/gnome-control-center/default-apps/google-chrome.xml
}

pkg_postinst() {
	ewarn "This binary requires the C++ runtime from >=sys-devel/gcc-4.2"
	ewarn "If you get the \"version \`GLIBCXX_3.4.9' not found\" error message,"
	ewarn "switch your active gcc to a version >=4.2 with gcc-config"
	if [[ ${ROOT} != "/" ]]; then
		ewarn "This package will not work on processors without SSE2 instruction"
		ewarn "set support (Intel Pentium III/AMD Athlon or older)."
	fi
}
