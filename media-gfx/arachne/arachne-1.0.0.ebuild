# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="Seam carving resizing library and realtime demonstration program"
HOMEPAGE="http://seam-carver.sourceforge.net/"
SRC_URI="mirror://sourceforge/seam-carver/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/gtk+"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-gdkconf.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}
