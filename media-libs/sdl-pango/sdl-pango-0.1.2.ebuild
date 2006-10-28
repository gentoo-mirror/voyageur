# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit eutils

DESCRIPTION="connects pango to SDL"
HOMEPAGE="http://sdlpango.sourceforge.net/"
SRC_URI="mirror://sourceforge/sdlpango/SDL_Pango-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/pango
       media-libs/libsdl"
RDEPEND=""

S=${WORKDIR}/SDL_Pango-${PV}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/SDL_Pango-${PV}-API-adds.patch
}

src_compile() {
	econf
	emake
}

src_install() {
	make DESTDIR="${D}" install
	dodoc README
}
