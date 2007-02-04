# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $

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
	einfo "The freenet6 ebuild installs an init script named 'gw6c'"
	einfo "to coincide with the name of the client binary installed"
	einfo "To add support for a freenet6 connection at startup, do"
	einfo ""
	einfo "# rc-update add gw6c default"
	einfo ""
	einfo "Also the /etc/freenet6/gw6c.conf file is configured to use"
	einfo "anonymous login, if you had a username/password edit this"
	einfo "and set your username, password and change"
	einfo "server=anon.freenet6.net"
	einfo "to"
	einfo "server=broker.freenet6.net"
	einfo ""
	einfo "if you are upgrading from 1.0.0 please take a carefull"
	einfo "look at tspc.conf, there are major changes, you probally"
	einfo "will only want to safe username/password"
}
