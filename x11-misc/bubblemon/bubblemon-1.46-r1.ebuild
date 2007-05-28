# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A fun monitoring applet for your desktop, complete with swimming duck"
HOMEPAGE="http://www.ne.jp/asahi/linux/timecop"
SRC_URI="http://www.ne.jp/asahi/linux/timecop/software/${PN}-dockapp-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.0"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${PN}-dockapp-${PV}

src_unpack()
{
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-gtk2.patch
}

src_compile() {
	emake GENTOO_CFLAGS="${CFLAGS}" || die "Compilation failed"
}

src_install () {
	into /usr
	dobin bubblemon
	dodoc ChangeLog README doc/* misc/*
}
