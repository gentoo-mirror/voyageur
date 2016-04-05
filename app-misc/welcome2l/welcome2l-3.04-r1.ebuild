# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic

MY_P=${P}-gentoo
DESCRIPTION="Welcome to Linux, ANSI login logo for Linux"
HOMEPAGE="http://www.littleigloo.org/ https://github.com/voyageur/welcome2l"
SRC_URI="https://github.com/voyageur/${PN}/archive/v${PV}-gentoo.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS README INSTALL ChangeLog BUGS TODO )

src_prepare() {
	sed -i -e "s:gcc:$(tc-getCC):g" Makefile || die

	default
}

src_compile() {
	# Does not seem to like optimizations
	filter-flags -O?

	emake
}

src_install() {
	local MY_PN=Welcome2L
	dobin ${MY_PN}

	doman ${MY_PN}.1
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initscript ${MY_PN}
}

pkg_postinst() {
	elog "NOTE: To start Welcome2L on boot, please type:"
	elog "rc-update add Welcome2L default"
}
