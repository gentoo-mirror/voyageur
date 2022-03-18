# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3 multilib-minimal

DESCRIPTION="Glide to OpenGL wrapper"
HOMEPAGE="http://openglide.sourceforge.net"
SRC_URI=""

EGIT_REPO_URI="https://github.com/voyageur/openglide.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="+sdl static-libs"

RDEPEND="virtual/glu[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	sdl? (
		media-libs/libsdl[${MULTILIB_USEDEP}]
	)
	!sdl? (
		x11-libs/libICE[${MULTILIB_USEDEP}]
		x11-libs/libSM[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
	)"

DEPEND="${RDEPEND}"

MULTILIB_WRAPPED_HEADERS+=( /usr/include/openglide/sdk2_unix.h )

src_prepare() {
	default
	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		--enable-shared \
		--disable-sdltest \
		$(use_enable sdl) \
		$(use_enable static-libs static)
}
