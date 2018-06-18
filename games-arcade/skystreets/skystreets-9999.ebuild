# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools desktop git-r3

DESCRIPTION="A remake of the old DOS game Skyroads"
HOMEPAGE="https://github.com/voyageur/skystreets"
EGIT_REPO_URI="https://github.com/voyageur/skystreets.git"

LICENSE="OSL-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl[opengl,video]
	media-libs/sdl-image"
RDEPEND=${DEPEND}

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	newicon gfx/sunscene.png ${PN}.png
	make_desktop_entry ${PN} SkyStreets
}
