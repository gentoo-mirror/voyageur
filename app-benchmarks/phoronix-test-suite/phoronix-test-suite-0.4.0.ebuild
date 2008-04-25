# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils depend.php

DESCRIPTION="Comprehensive testing and benchmarking platform"
HOMEPAGE="http://phoronix-test-suite.com"
SRC_URI="http://www.phoronix-test-suite.com/releases/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

S=${WORKDIR}/${PN}

need_php_cli

pkg_setup() {
	has_php
	require_php_with_use cli posix
}

src_compile() {
	einfo "Nothing to compile."
}

src_install() {
	insinto /usr/share
	doins -r "${S}" || die "Install data failed!"
	exeinto /usr/share/${PN}
	doexe ${PN} || die "Install of main script failed"

	make_wrapper ${PN} ./${PN} /usr/share/${PN} || die
}
