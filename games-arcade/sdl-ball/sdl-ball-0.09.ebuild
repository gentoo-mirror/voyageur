# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="Arkanoid/Breakout clone with pretty graphics."
HOMEPAGE="https://sourceforge.net/projects/sdl-ball"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/sdl-ttf
	media-libs/sdl-image"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

dir=${GAMES_DATADIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	to_patch=$(grep -Rl '"data\/' *)
	sed -i \
		-e "s!data/!${dir}/data/!" \
		$to_patch || die "sed failed"

	sed -i \
		-e "s!-c -Wall!${CFLAGS} -c -Wall!" \
		-e "s!-lSDL_ttf!-lSDL_ttf ${LDFLAGS}!" \
		Makefile || die "sed Makefile failed"
}

src_install() {
	dobin ${PN}
	insinto ${dir}
	doins -r data
}
