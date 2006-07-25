# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dchroot/dchroot-0.10.ebuild,v 1.1 2005/02/12 02:17:16 vapier Exp $

inherit eutils

DESCRIPTION="Utility for managing chroots for non-root users"
HOMEPAGE="http://packages.debian.org/unstable/admin/dchroot"
SRC_URI="mirror://debian/pool/main/d/dchroot/dchroot_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/help2man"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fix broken behaviour when using shadow 'su' rather than gnu 'su'
	epatch ${FILESDIR}/${PN}-${PV}-no_gnu_su.patch
	# add -- option to stop dchroot grabbing shell options.
	epatch ${FILESDIR}/${PN}-${PV}-option_fix.patch

	sed -i \
		-e '/^all:/s:$: docs:' \
		-e '/^CFLAGS/s:-O2:@CFLAGS@:' \
		Makefile.in || die "sed failed"
}

src_install() {
	einstall || die
	dodoc README TODO
}
