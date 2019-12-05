# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils

DESCRIPTION="3-Dimensional File System Browser"
HOMEPAGE="https://github.com/3dfsb-dev/3dfsb"
SRC_URI="https://github.com/3dfsb-dev/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/gstreamer:1.0
	media-libs/gst-plugins-bad:1.0
	media-libs/gst-plugins-base:1.0
	media-libs/sdl-image
	media-libs/freeglut
	sys-apps/file"
DEPEND="${RDEPEND}
	media-gfx/imagemagick
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-cmake_out_of_tree.patch
	"${FILESDIR}"/${P}-gstreamer_search.patch
	)

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	dobin "${BUILD_DIR}"/3dfsb
	dodoc CHANGELOG README.md
}
