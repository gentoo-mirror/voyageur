# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="X-Moto is a challenging 2D motocross platform game"
HOMEPAGE="http://xmoto.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/jpeg
	media-libs/libpng
	sys-libs/zlib
	media-libs/libsdl
	media-libs/sdl-mixer
	net-misc/curl
	dev-lang/lua
	dev-games/ode
	virtual/opengl"
DEPEND="${DEPEND}"

src_compile() {
	epatch "${FILESDIR}/xmoto-as-needed.patch"
	egamesconf || die "egamesconf failed"
	emake || die "emake failed"
}

src_install() {
	egamesinstall || die "install failed"
	dodoc ChangeLog README TODO
	prepgamesdirs
	make_desktop_entry xmoto Xmoto xmoto
}
