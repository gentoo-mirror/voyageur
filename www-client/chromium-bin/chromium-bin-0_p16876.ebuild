# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils multilib

# Latest revision id can be found at
# http://build.chromium.org/buildbot/snapshots/chromium-rel-linux/LATEST
MY_PV="${PV/0\_p}"

DESCRIPTION="Chromium is the open-source project behind Google Chrome"
HOMEPAGE="http://code.google.com/chromium/"
SRC_URI="http://build.chromium.org/buildbot/snapshots/chromium-rel-linux/${MY_PV}/chrome-linux.zip -> ${PN}-${MY_PV}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4
	>=dev-libs/nspr-4.7
	>=dev-libs/nss-3.12
	x11-libs/gtk+:2
	media-fonts/corefonts"
RDEPEND="${DEPEND}"

S="${WORKDIR}/chromium"

src_install() {
	declare CHROMIUM_HOME=/opt/chromium

	dodir ${CHROMIUM_HOME}
	mv ${WORKDIR}/chrome-linux/ "${D}"${CHROMIUM_HOME}
	
	# Create symbol links for necessary libraries
	dodir ${CHROMIUM_HOME}/lib
	if use x86; then
		NSS_DIR=/usr/$(get_libdir)/nss
		NSPR_DIR=/usr/$(get_libdir)/nspr
	fi
	# amd64: firefox-bin, xulrunner-bin, adobe-flash[32bit] could
	# provide these, but we miss libgconf-2.so.4 

	dosym ${NSPR_DIR}/libnspr4.so ${CHROMIUM_HOME}/lib/libnspr4.so.0d
	dosym ${NSPR_DIR}/libplc4.so ${CHROMIUM_HOME}/lib/libplc4.so.0d
	dosym ${NSPR_DIR}/libplds4.so ${CHROMIUM_HOME}/lib/libplds4.so.0d
	dosym ${NSS_DIR}/libnss3.so ${CHROMIUM_HOME}/lib/libnss3.so.1d
	dosym ${NSS_DIR}/libnssutil3.so ${CHROMIUM_HOME}/lib/libnssutil3.so.1d
	dosym ${NSS_DIR}/libsmime3.so ${CHROMIUM_HOME}/lib/libsmime3.so.1d
	dosym ${NSS_DIR}/libssl3.so ${CHROMIUM_HOME}/lib/libssl3.so.1d

	# Create chromium-bin wrapper
	make_wrapper chromium-bin ./chrome ${CHROMIUM_HOME}/chrome-linux ${CHROMIUM_HOME}/lib
	newicon ${FILESDIR}/chromium.png ${PN}.png
	make_desktop_entry chromium-bin "Chromium" ${PN}.png "Network;WebBrowser"
}

