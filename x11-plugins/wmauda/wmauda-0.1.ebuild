# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Dockable applet for WindowMaker that controls Audacious."
SRC_URI="http://www.netswarm.net/misc/${P}.tar.gz"
HOMEPAGE="http://www.netswarm.net/"

DEPEND="=x11-libs/gtk+-1.2*
	media-sound/audacious"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 sparc"

src_compile() {
	emake || die
}

src_install () {
	make DESTDIR="${D}" PREFIX="/usr" install || die "make install failed"
	dodoc README	
}
