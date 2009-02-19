# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="versatile and extensible composite manager which uses cairo for rendering"
HOMEPAGE="http://cairo-compmgr.tuxfamily.org/"
SRC_URI="http://download.tuxfamily.org/ccm/cairo-compmgr/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="glitz"

DEPEND="x11-libs/cairo[glitz?]"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable glitz glitz-tfp)
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed"
}
