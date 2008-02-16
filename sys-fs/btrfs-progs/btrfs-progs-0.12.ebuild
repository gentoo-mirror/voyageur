# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils

DESCRIPTION="A Checksumming Copy on Write Filesystem - Tools Package"
HOMEPAGE="http://oss.oracle.com/projects/btrfs/"
SRC_URI="http://oss.oracle.com/projects/btrfs/dist/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-fs/e2fsprogs"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-0.10-gcc.patch
}

src_compile() {
	emake depend &&	touch depend
	emake prefix=/ bindir=/sbin CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	emake -j1 install prefix=/ bindir=/sbin DESTDIR="${D}" || die "emake install failed"

	dodoc INSTALL
}
