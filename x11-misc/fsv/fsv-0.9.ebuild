# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="nls"

DESCRIPTION="3-Dimensional File System Visualizer"
HOMEPAGE="http://fsv.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 ppc x86"

DEPEND="=x11-libs/gtk+-1.2*
	<x11-libs/gtkglarea-1.99"

src_compile() {
	local myconf

	use nls || myconf="${myconf} --disable-nls"

	econf ${myconf} || die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS NOTES TODO
}
