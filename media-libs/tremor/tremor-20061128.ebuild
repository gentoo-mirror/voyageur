# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="Fixed-point version of the Ogg Vorbis decoder"
HOMEPAGE="http://xiph.org/vorbis"
SRC_URI="http://cafarelli.fr/gp2x/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

src_compile() {
	eautoreconf
	econf --enable-low-accuracy || die "Configure failed!"

	emake || die "Make failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README CHANGELOG
}
