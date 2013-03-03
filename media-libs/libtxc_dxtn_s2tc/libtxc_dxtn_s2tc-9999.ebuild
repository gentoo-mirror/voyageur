# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libtxc_dxtn/libtxc_dxtn-1.0.1-r1.ebuild,v 1.3 2013/01/27 10:24:48 mgorny Exp $

EAPI=5

inherit git-2 autotools-multilib

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

S=${WORKDIR}

src_prepare() {
	eautoreconf
}
