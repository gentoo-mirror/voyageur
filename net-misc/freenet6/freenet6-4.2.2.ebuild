# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Client to configure an IPv6 tunnel to freenet6"
HOMEPAGE="http://www.freenet6.net/"
SRC_URI="http://simionato.org/gw6c4_2_2src.tar.gz"

LICENSE="VPL-1.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DEPEND=""
DEPEND="${DEPEND}"
S="${WORKDIR}/tspc-advanced"

src_compile() {
	emake all target=linux || die "Build Failed"
}

src_install() {
	dosbin bin/gw6c

	insopts -m 600
	insinto /etc/freenet6
	doins ${FILESDIR}/gw6c.conf
	exeinto /etc/freenet6/template
	doexe template/{linux,checktunnel}.sh

	doman man/{man5/gw6c.conf.5,man8/gw6c.8}

	exeinto /etc/init.d
	newexe ${FILESDIR}/gw6c.rc gw6c
}

pkg_postinst() {
	if has_version '=net-misc/freenet6-1*' ; then
		ewarn "Warning: you are upgrading from an older version"
		ewarn "The configuration file has been renamed to gw6c.conf"
	fi
	einfo "The freenet6 ebuild installs an init script named 'gw6c'"
	einfo "to coincide with the name of the client binary installed"
	einfo "To add support for a freenet6 connection at startup, do"
	einfo ""
	einfo "# rc-update add gw6c default"
}
