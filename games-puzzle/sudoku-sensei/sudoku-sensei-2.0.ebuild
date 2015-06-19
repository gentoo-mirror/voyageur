# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit qt4-r2 games eutils

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

src_configure() {
	eqmake4 SudokuSensei.pro
}

src_install() {
	games_make_wrapper SudokuSensei ./SudokuSensei "${GAMES_DATADIR}"/${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r license.txt doc images language saves system
	exeinto "${GAMES_DATADIR}"/${PN}
	doexe SudokuSensei
	prepgamesdirs
}

pkg_postinst() {
	#ugly... but games group needs write access on some files
	chmod -R g+w "${GAMES_DATADIR}"/${PN}/
}
