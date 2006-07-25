# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="A 3D OpenGL based chess game"
HOMEPAGE="http://glchess.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/opengl
	gnome-base/libglade
	gnome-base/libgnomeui
    >=x11-libs/gtk+-2.4*
    x11-libs/gtkglext"
RDEPEND="${DEPEND}
	|| (
		games-board/gnuchess
		games-board/crafty
	)"
DEPEND="${DEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack "${A}"

	sed -i \
		-e "/CFLAGS/s:-g:${CFLAGS}:" \
		-e "/^CC =/d" \
		"${S}"/src/Makefile \
		|| die "sed failed"
}

src_compile() {
	emake -C src \
		DATAPATH="${GAMES_DATADIR}/${PN}/" \
		|| die "emake failed"
}

src_install() {
	dogamesbin src/${PN} || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r ui || die "doins failed"
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
	prepgamesdirs
}
