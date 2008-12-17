# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit qt4 games eutils

DESCRIPTION="The Sudoku Explainer Game"
HOMEPAGE="http://sudoku-sensei.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-02-00.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( ( x11-libs/qt-core:4 x11-libs/qt-gui:4 )
		>=x11-libs/qt-4.3:4 )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/SudokuSenseiSources

src_compile() {
	eqmake4 SudokuSensei.pro || die "qmake failed"
	emake || die "emake failed"
}

src_install() {
	games_make_wrapper SudokuSensei ./SudokuSensei "${GAMES_DATADIR}"/${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r license.txt doc images language saves system|| die "doins failed"
	exeinto "${GAMES_DATADIR}"/${PN}
	doexe SudokuSensei || die "doexe failed"
	prepgamesdirs
}

pkg_postinst() {
	#ugly... but games group needs write access on some files
	chmod -R g+w "${GAMES_DATADIR}"/${PN}/
}
