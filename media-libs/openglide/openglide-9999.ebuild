# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools git-r3

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

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
 		$(use_enable sdl) \
 		$(use_enable static-libs static)
}

#src_install() {
#	emake DESTDIR="${D}" install
#}
