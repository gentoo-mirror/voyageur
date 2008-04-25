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

RDEPEND="sys-process/time"
need_php_cli

S=${WORKDIR}/${PN}

pkg_setup() {
	has_php
	require_php_with_use bcmath cli posix
}

src_install() {
	insinto /usr/share
	doins -r "${S}" || die "Install data failed!"
	fperms 755 /usr/share/${PN}/${PN}
	fperms 755 /usr/share/${PN}/pts/launch-browser.sh

	make_wrapper ${PN} ./${PN} /usr/share/${PN} || die
}
