# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit git-r3 toolchain-funcs

DESCRIPTION="Welcome to Linux, ANSI login logo for Linux"
HOMEPAGE="https://github.com/voyageur/welcome2l"
EGIT_REPO_URI="https://github.com/voyageur/welcome2l.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

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
