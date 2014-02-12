# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_PN="SynologyAssistant"
MY_PV="${PV/[0-9.]*\_p}"

DESCRIPTION="Synology Assistant to setup DiskStations"
HOMEPAGE="http://www.synology.com/"
SRC_URI="http://global.download.synology.com/download/Tools/${MY_PN}/${MY_PV}/Linux/${MY_PN}-${PV/_p/-}.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror strip"
IUSE=""

DEPEND=""
RDEPEND="amd64? ( app-emulation/emul-linux-x86-qtlibs )
	x86? (
		dev-libs/glib
		dev-qt/qtcore
		dev-qt/qtgui
	)"

S=${WORKDIR}/linux

src_unpack() {
	unpack ${A}
	cd "${S}" || die "unpack cd failed"
	unpack ./${MY_PN}-${PV/_p/-}.tar.gz
}

src_install() {
	dodir /opt
	cp -r ${MY_PN} ${D}/opt || die "copy failed"
	dosym /opt/${MY_PN}/${MY_PN} /opt/bin/${MY_PN}
}
