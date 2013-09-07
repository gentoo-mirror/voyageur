# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/fgrun/fgrun-1.6.0.ebuild,v 1.1 2012/01/21 15:57:35 reavertm Exp $

EAPI=5
inherit eutils games cmake-utils

DESCRIPTION="A graphical frontend for the FlightGear Flight Simulator"
HOMEPAGE="http://sourceforge.net/projects/fgrun"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	>=dev-games/openscenegraph-3.0.1
	sys-libs/zlib
	x11-libs/fltk:1[opengl,threads]
"
DEPEND="${COMMON_DEPEND}
	~dev-games/simgear-2.10.0
	>=dev-libs/boost-1.34
"
RDEPEND="${COMMON_DEPEND}
	>=games-simulation/flightgear-2
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-simgear-version.patch
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}
		-DSIMGEAR_SHARED=ON
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodoc AUTHORS NEWS
	prepgamesdirs
}
