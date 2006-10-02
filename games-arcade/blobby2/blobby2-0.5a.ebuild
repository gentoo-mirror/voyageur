# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

MY_PN="${PN}-linux"
DESCRIPTION="The new Blobby Volley, a volley-game with colorful blobs"
HOMEPAGE="http://blobby.sourceforge.net"
SRC_URI="mirror://sourceforge/blobby/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/opengl
	media-libs/libsdl
	dev-games/physfs"

# Hardcoded to version...
S="${WORKDIR}/blobby-alpha-5"

src_install() {
	make DESTDIR=${D} install
	dodoc AUTHORS ChangeLog README doc/* || die "installing docs failed"

	prepgamesdirs
}

