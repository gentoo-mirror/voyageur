# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="A lightweight web browser"
HOMEPAGE="http://software.twotoasts.de/?page=midori"
SRC_URI="http://software.twotoasts.de/media/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=net-libs/webkit-gtk-29723
	x11-libs/libsexy"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."

	# NEWS is empty, ChangeLog has TODO's body
	dodoc AUTHORS ChangeLog INSTALL TODO
}

