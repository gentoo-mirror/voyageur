# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games qt4

MY_PN="PokerTH"

DESCRIPTION="Texas Hold'em poker game."
HOMEPAGE="http://www.pokerth.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="$(qt4_min_version 4.2)
dev-libs/boost
dev-libs/openssl"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! built_with_use x11-libs/qt qt3support ; then
		eerror "In order to compile pokerth, you will need to recompile"
		eerror "x11-libs/qt with qt3support use flag enabled."
		die "need x11-libs/qt with qt3support use flag."
	fi
	if ! built_with_use dev-libs/boost threads ; then
		eerror "In order to compile pokerth, you will need to recompile"
		eerror "dev-libs/boost with threads use flag enabled."
		die "need dev-libs/boost with threads use flag."
	fi

	games_pkg_setup
}

src_compile() {
	qmake || die "Couldn't create Makefiles."
	emake || die "make failed."
}

src_install() {
	dogamesbin bin/pokerth
	newicon pokerth.png ${PN}.png
	make_desktop_entry ${PN} "PokerTH" ${PN}.png

	prepgamesdirs
}

