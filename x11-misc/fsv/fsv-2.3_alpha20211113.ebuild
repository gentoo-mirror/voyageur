# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson

# Commit hash for this snapshot
HASH=09a10f96664b4c95d14479f0175f62c7a7a3a077
DESCRIPTION="3-Dimensional File System Visualizer"
HOMEPAGE="https://github.com/jabl/fsv
	http://fsv.sourceforge.net/"
SRC_URI="https://github.com/jabl/${PN}/archive/${HASH}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+ MIT ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/cglm
	media-libs/libepoxy
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3"
RDEPEND="${DEPEND}"

S=${WORKDIR}/fsv-${HASH}

src_prepare() {
	default

	sed -e "/^rpm/d" -i meson.build || die
}

src_configure() {
	local emesonargs=(-Dcglm:install=False)

	meson_src_configure
}

src_install() {
	default

	dobin "${BUILD_DIR}"/src/fsv
}
