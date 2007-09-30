# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils games

DESCRIPTION="Updated clone of Westood Studios' Dune"
HOMEPAGE="http://dunelegacy.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

DEPEND="
	dev-libs/zziplib
	>=media-libs/sdl-ttf-2.0
	>=media-libs/sdl-mixer-1.2
	>=media-libs/sdl-net-1.2
	>=media-libs/sdl-image-1.2
	>=media-libs/sdl-gfx-1.2
	dev-libs/boost
	dev-util/scons
"

src_compile() {
	scons || die
}

src_install() {
	dogamesbin dunelegacy

	ewarn	"You need a modified copy of the Dune 2 data to play this game.
If you own a copy of Dune 2 you can download the modified data from:

http://www.megaupload.com/?d=IBIVBXCD

You must uncompress this with text file auto-conversion (unzip -a).

You can then run ${PN} from the directory where you uncompressed the data"
}
