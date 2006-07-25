# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a small modification of the official freenet6 ebuild

inherit toolchain-funcs

DESCRIPTION="Client to configure an IPv6 tunnel to freenet6"
DESCRIPTION_FR="Un client pour configurer un tunnel IPv6 avec freenet6/Hexago"
HOMEPAGE="http://www.freenet6.net/"
SRC_URI="http://www.hexago.com/files/tspc-${PV}-src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/tspc2

src_unpack() {
	unpack ${A}

	cd ${S}
	sed -i -e "s#tspc.log#/var/log/tspc.log#" platform/linux/tsp_local.c

}

src_compile() {
	emake all target=linux || die "Build Failed"
}

src_install() {
	dosbin bin/tspc || die

	insopts -m 600
	insinto /etc/freenet6
	doins ${FILESDIR}/tspc.conf
	exeinto /etc/freenet6/template
	doexe template/{linux,checktunnel}.sh

	doman man/{man5/tspc.conf.5,man8/tspc.8}

	exeinto /etc/init.d
	newexe ${FILESDIR}/tspc.rc tspc
}

pkg_postinst() {
	einfo "The freenet6 ebuild installs an init script named 'tspc'"
	einfo "to coincide with the name of the client binary installed"
	einfo "To add support for a freenet6 connection at startup, do"
	einfo ""
	einfo "# rc-update add tspc default"
}
