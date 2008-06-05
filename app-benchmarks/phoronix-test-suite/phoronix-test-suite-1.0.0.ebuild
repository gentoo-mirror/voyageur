# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils depend.php

DESCRIPTION="Comprehensive testing and benchmarking platform"
HOMEPAGE="http://phoronix-test-suite.com"
SRC_URI="http://www.phoronix-test-suite.com/releases/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-process/time"
need_php_cli

S="${WORKDIR}/${PN}"

pkg_setup() {
	has_php
	require_php_with_use cli gd
}


src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s,export PTS_DIR=\`pwd\`,export PTS_DIR=\"/usr/share/${PN}\"," ${PN}
}

src_install() {
	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	exeinto /usr/bin
	doins -r ${S}/pts{,-core} || die "Install failed!"
	fperms 755 /usr/share/${PN}/pts-core/scripts/launch-browser.sh
	doexe phoronix-test-suite || die "Installing the executable failed!"
	dodoc CHANGE-LOG
}
