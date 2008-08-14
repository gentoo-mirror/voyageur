# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

MY_P="msn-pecan-${PV}"

DESCRIPTION="Alternative MSN protocol plugin for libpurple"
HOMEPAGE="http://code.google.com/p/msn-pecan/"

SRC_URI="http://msn-pecan.googlecode.com/files/${MY_P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="net-im/pidgin"
DEPEND="dev-util/pkgconfig
	${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e 's/^LDFLAGS:=/LDFLAGS+=/1' Makefile \
		|| die "Patching Makefile to honor LDFLAGS failed"
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc COPYRIGHT ChangeLog README TODO || die "dodoc failed"
}
