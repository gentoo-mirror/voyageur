# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl-mixer/sdl-mixer-1.2.6-r1.ebuild,v 1.14 2006/08/28 00:37:20 kumba Exp $

inherit eutils

MY_P=${P/sdl-/SDL_}
DESCRIPTION="Simple Direct Media Layer Mixer Library"
HOMEPAGE="http://www.libsdl.org/projects/SDL_mixer/index.html"
SRC_URI="http://www.libsdl.org/projects/SDL_mixer/release/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
# Tuned for GP2X, not tested elsewhere!
KEYWORDS="-* ~arm"
IUSE="mp3 mikmod timidity vorbis"

DEPEND=">=media-libs/libsdl-1.2.5
	timidity? ( media-sound/timidity++ )
	mp3? ( media-libs/libmad )
	mikmod? ( >=media-libs/libmikmod-3.1.10 )"

	#TODO: add tremor ebuild!
	#vorbis? ( >=media-libs/libvorbis-1.0_beta4 media-libs/libogg )
S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/sdl-mixer-1.2.6-mikmod-music-init.patch
	epatch "${FILESDIR}"/SDL_mixer-126-libmad-tremor.patch
	sed -i \
		-e 's:/usr/local/lib/timidity:/usr/share/timidity:' \
		timidity/config.h \
		|| die "sed timidity/config.h failed"
}

src_compile() {
	# don't use the internal mikmod library, use the system one if USE=mikmod
	econf \
		--disable-music-mod \
		--disable-dependency-tracking \
		$(use_enable timidity timidity-midi) \
		$(use_enable mikmod music-libmikmod) \
		--disable-music-mp3 \
		$(use_enable mp3 music-mp3-mod) \
		$(use_enable vorbis music-ogg) \
		|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc CHANGES README
}
