# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/supertux/supertux-0.3.0.ebuild,v 1.8 2006/12/23 01:19:37 chainsaw Exp $

#GAMES_USE_SDL="nojoystick" #bug #100372
inherit eutils games

DESCRIPTION="A game similar to Super Mario Bros."
HOMEPAGE="http://super-tux.sourceforge.net"
SRC_URI=" http://download.berlios.de/supertux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=media-libs/libsdl-1.2.4
	>=media-libs/sdl-image-1.2.2
	sys-libs/zlib
	dev-util/jam
	>=dev-games/physfs-1.0.0
	media-libs/libvorbis
	media-libs/libogg
	media-libs/openal"
DEPEND="${RDEPEND}
	x11-libs/libXt"

pkg_setup() {
	games_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}"/${P}-jaminstall.patch
}

src_compile() {
	egamesconf \
		--disable-debug \
		|| die
	jam || die "jam failed"
}

src_install() {
	DESTDIR=${D} jam \
		install || die "jam install failed"

	# Doc
	gzip ${D}/usr/share/doc/${PF}/*
	
	prepgamesdirs
}
