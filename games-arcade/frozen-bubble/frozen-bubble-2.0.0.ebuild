# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/frozen-bubble/frozen-bubble-1.0.0-r6.ebuild,v 1.6 2006/09/27 03:26:01 vapier Exp $

inherit autotools eutils perl-module games

DESCRIPTION="A Puzzle Bubble clone written in perl (now with network support)"
HOMEPAGE="http://www.frozen-bubble.org/ http://chl.tuxfamily.org/frozen-bubble/"
SRC_URI="http://www.frozen-bubble.org/data/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=dev-lang/perl-5.6.1
	>=media-libs/sdl-mixer-1.2.3
	>=media-libs/sdl-pango-0.1.2
	dev-perl/sdl-perl"
DEPEND="${RDEPEND}
	sys-devel/autoconf"

pkg_setup() {
	if ! built_with_use -a media-libs/sdl-image gif png ; then
		ewarn "Frozen-bubble uses GIF and PNG image files."
		ewarn "You must emerge media-libs/sdl-image with GIF and PNG support."
		ewarn "Please USE=\"gif png\" emerge media-libs/sdl-image"
		die "Cannot emerge without gif and png USE flags on sdl-image"
	fi
	if ! built_with_use media-libs/sdl-mixer mikmod ; then
		ewarn "You must emerge media-libs/sdl-mixer with mikmod support."
		ewarn "    USE=mikmod emerge media-libs/sdl-mixer"
		die "missing mikmod USE flag for sdl-mixer"
	fi
	games_pkg_setup
}

src_compile() {
	emake \
		OPTIMIZE="${CFLAGS}" \
		PREFIX=/usr \
		BINDIR="${GAMES_BINDIR}" \
		DATADIR="${GAMES_DATADIR}" \
		CFLAGS="${CFLAGS} $(pkg-config glib-2.0 --cflags)" \
		LIBS="$(pkg-config glib-2.0 --libs)" \
		MANDIR=/usr/share/man \
		|| die "emake failed"
}

src_install() {
	make \
		DESTDIR="${D}" \
		PREFIX="/usr" \
		BINDIR="${GAMES_BINDIR}" \
		DATADIR="${GAMES_DATADIR}" \
		MANDIR="/usr/share/man" \
		install \
		|| die "make install failed"
	dosed /usr/games/bin/frozen-bubble
	dodoc AUTHORS README TIPS
	newicon icons/frozen-bubble-icon-48x48.png ${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN}.png

	fixlocalpod
	prepgamesdirs
}
