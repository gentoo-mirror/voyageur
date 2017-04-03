# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit git-r3 autotools-multilib

DESCRIPTION="S2TC texture compression and conversion tools"
HOMEPAGE="https://github.com/divVerent/s2tc/wiki"
EGIT_REPO_URI="git://github.com/divVerent/s2tc.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/mesa"
RDEPEND="${RDEPEND}
	!media-libs/libtxc_dxtn"

src_prepare() {
	eautoreconf
}
