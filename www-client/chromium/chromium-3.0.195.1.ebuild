# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils toolchain-funcs

DESCRIPTION="Chromium Web Browser"
HOMEPAGE="http://chromium.org/"
SRC_URI="http://build.chromium.org/buildbot/archives/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/nss-3.12.2
	>=gnome-base/gconf-2.24.0
	media-fonts/corefonts
	>=media-libs/alsa-lib-1.0.19
	>=x11-libs/gtk+-2.14.7"
DEPEND="${RDEPEND}
	>=dev-util/gperf-3.0.3
	>=dev-util/pkgconfig-0.23
	>=dev-util/scons-1.2.0"

src_configure() {
	local myconf
	
	if use amd64; then
		myconf="${myconf} -Dtarget_arch=x64"
	fi
	if [[ "$(gcc-major-version)$(gcc-minor-version)" == "44" ]]; then
		myconf="${myconf} -Dno_strict_aliasing=1 -Dgcc_version=44"
	fi

	tools/gyp/gyp_chromium build/all.gyp ${myconf} --depth=. || die "gyp failed"
}

src_compile() {
	scons --site-dir="${S}/site_scons" -C build \
		--mode=Release chrome || die "scons failed"
}

src_install() {
	declare CHROMIUM_HOME=/opt/chromium
	# Chromium does not have "install" target in the build system.

	dodir ${CHROMIUM_HOME}

	exeinto ${CHROMIUM_HOME}
	doexe sconsbuild/Release/chrome
	doexe sconsbuild/Release/xdg-settings
	doexe "${FILESDIR}/chromium-launcher.sh"

	insinto ${CHROMIUM_HOME}
	doins sconsbuild/Release/chrome.pak

	doins -r sconsbuild/Release/locales
	doins -r sconsbuild/Release/resources
	doins -r sconsbuild/Release/themes

	# Chromium compiles patched versions of these media libraries.
	dodir ${CHROMIUM_HOME}/lib
	insinto ${CHROMIUM_HOME}/lib
	doins sconsbuild/Release/libavcodec.so.52
	doins sconsbuild/Release/libavformat.so.52
	doins sconsbuild/Release/libavutil.so.50

	newicon sconsbuild/Release/product_logo_48.png ${PN}.png
	dosym ${CHROMIUM_HOME}/chromium-launcher.sh /usr/bin/chromium
	make_desktop_entry chromium "Chromium" ${PN}.png "Network;WebBrowser"
}
