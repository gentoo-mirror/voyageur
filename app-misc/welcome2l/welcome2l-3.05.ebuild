# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit toolchain-funcs

DESCRIPTION="Welcome to Linux, ANSI login logo for Linux"
HOMEPAGE="https://github.com/voyageur/welcome2l"
SRC_URI="https://github.com/voyageur/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DOCS=( AUTHORS README INSTALL ChangeLog BUGS TODO )

src_prepare() {
	sed -i -e "s:gcc:$(tc-getCC):g" Makefile || die

	default
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	local MY_PN=Welcome2L
	dobin ${MY_PN}

	doman ${MY_PN}.1
	einstalldocs

	newinitd "${FILESDIR}"/${PN}-r1.initscript ${MY_PN}
}

pkg_postinst() {
	elog "NOTE: To start Welcome2L on boot, please type:"
	elog "rc-update add Welcome2L default"
}
