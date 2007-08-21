# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="monitors the forking activity of the kernel and most active processes"
HOMEPAGE="http://hules.free.fr/wmforkplop"
SRC_URI="http://hules.free.fr/wmforkplop/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="gnome-base/libgtop
	media-libs/imlib2"
RDEPEND="${DEPEND}"

#src_compile() {
#	make linux
#}

src_install() {
	emake DESTDIR=${D} install
}
#src_install() {
#
#	dodir /usr/bin /usr/man/man1
#	make PREFIX=${D}/usr install || die "make install failed"
#
#}
