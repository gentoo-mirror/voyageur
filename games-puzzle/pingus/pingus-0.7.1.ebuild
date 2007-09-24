# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="free Lemmings clone"
HOMEPAGE="http://pingus.seul.org/"
SRC_URI="http://pingus.seul.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/libpng
	dev-libs/boost
	dev-games/physfs"

DEPEND="${RDEPEND}
	>=dev-util/scons-0.97"

src_compile() {
	scons ${MAKEOPTS} CXXFLAGS="${CXXFLAGS}" PREFIX=/usr || die "scons failed"
}

src_install() {
	newgamesbin ${PN} ${PN}-bin|| die "dogamesbin failed"
	games_make_wrapper ${PN} "${PN}-bin --datadir ${GAMES_DATADIR}/${PN}/data"
	dodoc AUTHORS NEWS README TODO || die "dodoc failed"

	cd ${WORKDIR}/${P}/data

	insinto "${GAMES_DATADIR}"/${PN}/data/controller
	doins controller/*.scm
	insinto "${GAMES_DATADIR}"/${PN}/data/data
	doins data/*.res
	insinto "${GAMES_DATADIR}"/${PN}/data
	doins -r images/
	insinto "${GAMES_DATADIR}"/${PN}/data
	doins -r levels/
	insinto "${GAMES_DATADIR}"/${PN}/data/music
	doins music/*.{it,s3m}
	insinto "${GAMES_DATADIR}"/${PN}/data/po
	doins po/*.po
	insinto "${GAMES_DATADIR}"/${PN}/data/sounds
	doins sounds/*.wav
	insinto "${GAMES_DATADIR}"/${PN}/data/worldmaps
	doins worldmaps/*.worldmap

	# Better than nothing
	newicon ${WORKDIR}/${P}/data/images/pingus/player0/boarder.png ${PN}.png
	make_desktop_entry ${PN} Pingus /usr/share/pixmaps/${PN}.png
	prepgamesdirs
}