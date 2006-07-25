# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="An Open Source World War II german submarine simulation."
HOMEPAGE="http://dangerdeep.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sse"

DEPEND=">=sys-devel/gcc-3.4
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-net
	media-libs/sdl-ttf
	media-libs/sdl-mixer
	media-libs/sdl-sound
	>=sci-libs/fftw-3.0.0
	dev-util/scons"


src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-destdirs.patch" || die "epatch failed"
}

src_compile() {
	if use amd64
	then
		USEX86SSE=3
	else 
		if use sse
		then
			USEX86SSE=1
		else
			USEX86SSE=-1
		fi
	fi

	scons usex86sse=${USEX86SSE} || die "make failed"
}

src_install() {
	dogamesbin build/linux/${PN} || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data/* || die "doins failed"
	dodoc ARTWORK_LICENSE ChangeLog CREDITS INSTALL LICENSE \
	LICENSE_README README || die "dodoc failed"
	mv logo.xpm ${PN}.xpm
	doicon ${PN}.xpm || die "doicon failed"
	make_desktop_entry ${PN} "Danger from the Deep" ${PN}.xpm
	prepgamesdirs
}
