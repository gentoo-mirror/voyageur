# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#GAMES_USE_SDL="nojoystick" #bug #100372
inherit eutils games

DESCRIPTION="A game similar to Super Mario Bros."
HOMEPAGE="http://super-tux.sourceforge.net"
SRC_URI="http://download2.berlios.de/${PN}/${P}d.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=media-libs/libsdl-1.2.4
	>=media-libs/sdl-image-1.2.2
	sys-libs/zlib
	>=dev-games/physfs-1.0.0
	media-libs/libvorbis
	media-libs/libogg
	media-libs/openal"
DEPEND="${RDEPEND}
	dev-util/ftjam
	x11-libs/libXt"

pkg_setup() {
	games_pkg_setup
}

src_compile() {
	egamesconf \
		--disable-debug \
		|| die
	jam || die "jam failed"
}

src_install() {
	jam -sDESTDIR=${D} -sappdocdir=/usr/share/doc/${PF} \
		-sapplicationsdir=/usr/share/applications \
		-spixmapsdir=/usr/share/pixmaps install \
		|| die "jam install failed"

	# Documentation gzip
	gzip ${D}/usr/share/doc/${PF}/*
	
	prepgamesdirs
}
