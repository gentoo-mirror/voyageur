# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit qt4 games

DESCRIPTION="A minesweeper and picross clone"
HOMEPAGE="http://github.com/schuay/picmi"
SRC_URI="http://github.com/downloads/schuay/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/libsfml-1.6
	x11-libs/qt-core:4
	x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_configure() {
	# TODO: need to use system Liberation fonts
	eqmake4 ${PN}.pro
	emake setpath || die "setpath failed"
}

src_install() {
	# TODO: respect Gentoo games paths
	emake INSTALL_ROOT="${D}" install || die "installation failed"
}
