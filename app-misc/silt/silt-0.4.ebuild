# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Silly translation library for l33t-speech, kenny, rot13, ..."
HOMEPAGE="http://libsilt.sourceforge.net"
SRC_URI="mirror://sourceforge/libsilt/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

#S="${WORKDIR}/${P/lib}"

src_install () {
	emake DESTDIR=${D} install || die "install failed"
	# Install documentation.
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README TODO DESCRIPTION
}
