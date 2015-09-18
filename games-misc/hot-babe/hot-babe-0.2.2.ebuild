# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit base

DESCRIPTION="Displays the system activity in a very special way ;-)"
HOMEPAGE="http://sourceforge.net/projects/hotbabe"
SRC_URI="mirror://sourceforge/${PN/-}/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_install() {
	emake DESTDIR="${D}" install

	newman ${PN}.1 ${PN}.6
}
