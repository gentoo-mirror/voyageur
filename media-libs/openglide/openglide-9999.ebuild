# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools git-r3 multilib-minimal

DESCRIPTION="Glide to OpenGL wrapper"
HOMEPAGE="http://openglide.sourceforge.net"
SRC_URI=""

EGIT_REPO_URI="https://github.com/voyageur/openglide.git"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+sdl static-libs"

RDEPEND="
	virtual/opengl
	x11-libs/libXxf86vm
	x11-libs/libX11
	sdl? ( media-libs/libsdl )"
DEPEND="${RDEPEND}"

MULTILIB_WRAPPED_HEADERS+=( /usr/include/openglide/sdk2_unix.h )

src_prepare() {
	default
	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	econf \
 		$(use_enable sdl) \
 		$(use_enable static-libs static)
}

multilib_src_compile() {
	if ! multilib_is_native_abi ; then
		sed -i -e 's/install-data-hook:/disabled_\0/' Makefile || die
	fi
	default
}
