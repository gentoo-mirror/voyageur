# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils multilib

DESCRIPTION="Samsung binary unified driver"
HOMEPAGE="http://www.samsung.com"
SRC_URI="http://org.downloadcenter.samsung.com/downloadfile/ContentsFile.aspx?VPath=DR/200908/20090831171020531/smartpanel-2.00.33.tar.gz"

LICENSE="samsung"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip"

DEPEND=""
RDEPEND="net-print/samsung-unifieddriver
	sys-libs/libstdc++-v3
	x11-libs/qt:3"

S=${WORKDIR}/cdroot/Linux/smartpanel

src_unpack() {
	# Trailing garbage error, do not die
	tar xozf ${DISTDIR}/${A}
}

src_prepare() {
	# Fix permissions
	find . -type d -exec chmod 755 '{}' \;
	find . -type f -exec chmod 644 '{}' \;
	find . -type f -name \*.sh -exec chmod 755 '{}' \;
	chmod 755 ./bin*/smartpanel
}

src_install() {
	SOPT="/opt/Samsung/SmartPanel"
	if [ "${ABI}" == "amd64" ]; then
		SBINDIR="bin64"
	else
		SBINDIR="bin"
	fi

	insinto ${SOPT}/share
	doins -r share/en share/icons
	insinto ${SOPT}/bin
	doins ${SBINDIR}/*xml
	exeinto ${SOPT}/bin
	doexe ${SBINDIR}/smartpanel
}
