# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qmake-utils games

DESCRIPTION="The Sudoku Explainer Game"
HOMEPAGE="http://sudoku-sensei.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-02-00.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/SudokuSenseiSources

src_prepare() {
	sed -e '/license.txt/d' -i main.cpp || die
}

src_configure() {
	eqmake4 SudokuSensei.pro
}

src_install() {
	games_make_wrapper SudokuSensei ./SudokuSensei "${GAMES_DATADIR}"/${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r doc images language saves system
	exeinto "${GAMES_DATADIR}"/${PN}
	doexe SudokuSensei
	prepgamesdirs
}

pkg_postinst() {
	#ugly... but games group needs write access on some files
	chmod -R g+w "${GAMES_DATADIR}"/${PN}/{saves,system}
}
