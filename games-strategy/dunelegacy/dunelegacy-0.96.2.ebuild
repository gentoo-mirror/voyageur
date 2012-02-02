# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils games

DESCRIPTION="Updated clone of Westood Studios' Dune 2"
HOMEPAGE="http://dunelegacy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-libs/zziplib
	>=media-libs/sdl-ttf-2.0
	>=media-libs/sdl-mixer-1.2
	>=media-libs/sdl-net-1.2
	>=media-libs/sdl-image-1.2
	>=media-libs/sdl-gfx-1.2"
RDEPEND="${DEPEND}"


src_install() {
	dogamesbin src/${PN} || die "dogamesbin failed"


	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/* || die "doins failed"

	doicon dunelegacy.png
	make_desktop_entry ${PN} "Dune Legacy" dunelegacy "Game;StrategyGame;"

	prepgamesdirs
}

pkg_postinst() {
    elog "You will need to copy all Dune 2 PAK files to ${GAMES_DATADIR}/${PN} !"
    elog ""
    elog "At least the following files are needed:"
    elog " - ATRE.PAK"
    elog " - DUNE.PAK"
    elog " - ENGLISH.PAK"
    elog " - FINALE.PAK"
    elog " - HARK.PAK"
    elog " - INTRO.PAK"
    elog " - INTROVOC.PAK"
    elog " - MENTAT.PAK"
    elog " - MERC.PAK"
    elog " - ORDOS.PAK"
    elog " - SCENARIO.PAK"
    elog " - SOUND.PAK"
    elog " - VOC.PAK"
    elog ""
    elog "For playing in german or french you need additionally GERMAN.PAK"
    elog "or FRENCH.PAK."
}
