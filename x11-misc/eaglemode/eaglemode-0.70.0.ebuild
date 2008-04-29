# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Visit almost everything in your PC simply by zooming in"
HOMEPAGE="http://eaglemode.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# TODO make some of these conditionals, and add others from
# http://eaglemode.sourceforge.net/SystemRequirements.html
DEPEND="dev-lang/perl
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXxf86vm
	virtual/ghostscript"
RDEPEND="${DEPEND}"

src_compile() {
	# TODO honor CC/CFLAGS/...
	perl make.pl build || die "Compilation failed"
}

src_install() {
	perl make.pl install dir=${D}/usr/share/${PN} || die "Installation failed"
	dosym /usr/share/{PN}/${PN}.sh /usr/bin/${PN}
}
