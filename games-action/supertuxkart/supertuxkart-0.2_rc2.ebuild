# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

MY_P="${P/_/}"
DESCRIPTION="A kart racing game starring Tux, the linux penguin (improved fork of TuxKart)"
HOMEPAGE="http://supertuxkart.berlios.de"
SRC_URI="http://download.berlios.de/${PN}/${MY_P}.tar.bz2"

S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=media-libs/plib-1.8.0
	virtual/opengl"
DEPEND="${RDEPEND}"

src_compile() {
	egamesconf --datadir="${GAMES_DATADIR_BASE}" || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS NEWS README

	prepgamesdirs
}

