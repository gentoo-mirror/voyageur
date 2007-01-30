# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib eutils

MY_PN="freenx"
DESCRIPTION="An X11/RDP/VNC proxy server especially well suited to low bandwidth links such as wireless, WANS, and worse"
HOMEPAGE="http://freenx.berlios.de/"
SRC_URI="http://download.berlios.de/${MY_PN}/${MY_PN}-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
RESTRICT="strip"
IUSE="arts cups esd nxclient"
DEPEND="virtual/ssh
	dev-tcltk/expect
	sys-apps/gawk
	net-analyzer/gnu-netcat
	x86? ( nxclient? ( net-misc/nxclient )
	      !nxclient? ( !net-misc/nxclient ) )
	!x86? ( !net-misc/nxclient )
	net-misc/nx
	arts? ( kde-base/arts )
	cups? ( net-print/cups )
	esd? ( media-sound/esound )
	!net-misc/nxserver-freeedition
	!net-misc/nxserver-personal
	!net-misc/nxserver-business
	!net-misc/nxserver-enterprise"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${PV}

export NX_HOME_DIR=/var/lib/nxserver/home

pkg_setup () {
	enewuser nx -1 -1 ${NX_HOME_DIR}
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# fix fullscreen support; see bug 150200
	epatch ${FILESDIR}/${P}-fullscreen.patch

	mv node.conf.sample node.conf || die

	epatch ${FILESDIR}/${P}-nxloadconfig.patch
	# Change the defaults in nxloadconfig to meet the users needs.
	if use arts ; then
		einfo "Enabling arts support."
		sed -i '/ENABLE_ARTSD_PRELOAD=/s/"0"/"1"/' nxloadconfig || die
		sed -i '/ENABLE_ARTSD_PRELOAD=/s/"0"/"1"/' node.conf || die
	fi
	if use esd ; then
		einfo "Enabling esd support."
		sed -i '/ENABLE_ESD_PRELOAD=/s/"0"/"1"/' nxloadconfig || die
		sed -i '/ENABLE_ESD_PRELOAD=/s/"0"/"1"/' node.conf || die
	fi
	if use cups ; then
		einfo "Enabling cups support."
		sed -i '/ENABLE_KDE_CUPS=/s/"0"/"1"/' nxloadconfig || die
		sed -i '/ENABLE_KDE_CUPS=/s/"0"/"1"/' node.conf || die
	fi
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	NX_ETC_DIR=/etc/nxserver
	NX_SESS_DIR=/var/lib/nxserver/db

	dobin nxserver
	dobin nxnode
	dobin nxnode-login
	dobin nxkeygen
	dobin nxloadconfig
	dobin nxsetup
	( use x86 && use nxclient ) || dobin nxprint
	( use x86 && use nxclient ) || dobin nxclient

	dodir ${NX_ETC_DIR}
	for x in passwords passwords.orig ; do
		touch ${D}${NX_ETC_DIR}/$x
		chmod 600 ${D}${NX_ETC_DIR}/$x
	done

	insinto ${NX_ETC_DIR}
	doins node.conf

	dodir ${NX_HOME_DIR}

	for x in closed running failed ; do
		keepdir ${NX_SESS_DIR}/$x
		fperms 0700 ${NX_SESS_DIR}/$x
	done
}

pkg_postinst () {
	usermod -s /usr/bin/nxserver nx || die "Unable to set login shell of nx user!!"
	usermod -d ${NX_HOME_DIR} nx || die "Unable to set home directory of nx user!!"

	elog "To complete the installation, run:"
	elog " nxsetup --install --setup-nomachine-key --clean --purge"
	elog "This will use the default Nomachine SSH key"
}
