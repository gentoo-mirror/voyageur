# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools-multilib

DESCRIPTION="S2TC texture compression and conversion tools"
HOMEPAGE="https://github.com/divVerent/s2tc/wiki"
SRC_URI="https://github.com/divVerent/s2tc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/mesa"
RDEPEND="${RDEPEND}
	!media-libs/libtxc_dxtn"

S=${WORKDIR}/s2tc-${PV}

src_prepare() {
	eautoreconf
}
