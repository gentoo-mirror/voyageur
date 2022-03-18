# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson

# Commit hash for this snapshot
HASH=09a10f9
# And bundled cglm
CGLM=0.8.4
DESCRIPTION="3-Dimensional File System Visualizer"
HOMEPAGE="https://github.com/jabl/fsv
	http://fsv.sourceforge.net/"
SRC_URI="https://github.com/jabl/${PN}/archive/${HASH}.tar.gz -> ${P}.tar.gz
	https://github.com/recp/cglm/archive/refs/tags/v${CGLM}.tar.gz -> cglm-${CGLM}.tar.gz"

LICENSE="LGPL-2.1+ MIT ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="media-libs/libepoxy
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3"
RDEPEND="${DEPEND}"

S=${WORKDIR}/jabl-fsv-${HASH}

src_prepare() {
	mkdir -p subprojects || die
	mv "${WORKDIR}"/cglm-${CGLM} subprojects/cglm

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
