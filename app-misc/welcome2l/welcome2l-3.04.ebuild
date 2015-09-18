# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic

MY_PN=Welcome2L
MY_P=${MY_PN}-${PV}
DESCRIPTION="Welcome to Linux, ANSI login logo for Linux"
HOMEPAGE="http://www.littleigloo.org/"
SRC_URI="http://www.chez.com/littleigloo/files/${MY_P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo-r1.patch
	sed -i -e "s:gcc:$(tc-getCC):g" Makefile || die
}

src_compile() {
	# Does not seem to like optimizations
	filter-flags -O?

	emake
}

src_install() {
	dobin ${MY_PN}
	doman ${MY_PN}.1
	dodoc AUTHORS README INSTALL ChangeLog BUGS TODO
	newinitd "${FILESDIR}"/${PN}.initscript ${MY_PN}
}

pkg_postinst() {
	elog "NOTE: To start Welcome2L on boot, please type:"
	elog "rc-update add Welcome2L default"
}
