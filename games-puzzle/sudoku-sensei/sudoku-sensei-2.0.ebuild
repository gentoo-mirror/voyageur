# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt4 games eutils

DESCRIPTION="The Sudoku Explainer Game"
HOMEPAGE="http://sudoku-sensei.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-02-00.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="$(qt4_min_version 4.2)"

S=${WORKDIR}/SudokuSenseiSources

src_compile() {
	qmake -project SudokuSensei.pro || die "qmake project failed"
	qmake SudokuSensei.pro || die "qmake failed"
	emake \
		CXX=$(tc-getCXX) \
		LINK=$(tc-getCXX) \
		|| die "emake failed"
}

src_install() {
	games_make_wrapper SudokuSensei ./SudokuSensei "${GAMES_DATADIR}"/${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r license.txt doc images language saves system|| die "doins failed"
	exeinto "${GAMES_DATADIR}"/${PN}
	doexe SudokuSensei || die "doexe failed"
	prepgamesdirs
}
