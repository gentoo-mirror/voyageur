# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Displays the system activity in a very special way ;-)"
HOMEPAGE="http://sourceforge.net/projects/hotbabe"
SRC_URI="mirror://sourceforge/${PN/-}/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="nomirror"

DEPEND="=x11-libs/gtk+-2*"

src_compile() {
	emake PREFIX="/usr"
}

src_install() {
	emake PREFIX="${D}"/usr install
	mv "${D}"/usr/share/doc/{${PN},${PF}}
	newman "${D}"/usr/share/man/man1/${PN}.1 ${PN}.6
	rm -r "${D}"/usr/share/man/man1
}
