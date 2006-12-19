# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="nxnode provides the components that are shared between the different editions of NoMachine's NX Server"
HOMEPAGE="http://www.nomachine.com/"
SRC_URI="http://64.34.161.181/download/2.1.0/Linux/nxnode-2.1.0-12.i386.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	!net-misc/nx-x11
	!net-misc/nx-x11-bin
	!net-misc/nxcomp
	!net-misc/nxproxy
	!<=net-misc/nxserver-personal-2.0.99
	!<=net-misc/nxserver-business-2.0.99
	!<=net-misc/nxserver-enterprise-2.0.99
	!net-misc/nxserver-freenx
"

RDEPEND="
	=net-misc/nxclient-2*
	dev-libs/openssl
	media-libs/jpeg
	media-libs/libpng
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libXmu
	x11-libs/libX11
	x11-libs/libXdmcp
	x11-libs/libSM
	x11-libs/libXt
	x11-libs/libXrender
	x11-libs/libXau
	x11-libs/libXaw
	x11-libs/libXpm
	x11-libs/libXext
"

S=${WORKDIR}/NX

src_unpack()
{
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/nxnode-2.1.0-setup.patch
}

src_install()
{
	cd ${S}

	# we install nxnode into /usr/NX, to make sure it doesn't clash
	# with libraries installed for FreeNX

	into /usr/NX
	for x in nxagent nxdesktop nxnode nxpasswd nxsensor nxspool nxuexec nxviewer ; do
		dobin bin/$x || die
	done

	dodir /usr/NX/etc
	cp etc/node-debian.cfg.sample ${D}/usr/NX/etc/node-gentoo.cfg.sample || die
	sed -e 's|COMMAND_FUSER = .*|COMMAND_FUSER = "/usr/bin/fuser"|;' -i ${D}/usr/NX/etc/node-gentoo.cfg.sample || die

	cp etc/node.lic.sample ${D}/usr/NX/etc/node.lic || die
	chmod 0400 ${D}/usr/NX/etc/node.lic
	chown nx:root ${D}/usr/NX/etc/node.lic

	dodir /usr/NX/lib
	cp -R lib ${D}/usr/NX || die

	dodir /usr/NX/scripts
	cp -R scripts ${D}/usr/NX || die

	dodir /usr/NX/share
	cp -R share ${D}/usr/NX || die

	dodir /usr/NX/var
	cp -R var ${D}/usr/NX || die

	dodir /etc/init.d || die
	exeinto /etc/init.d
	newexe ${FILESDIR}/nxnode-2.1.0-init nxsensor || die
}

pkg_postinst()
{
	einfo "Running NoMachine's setup script"
	${ROOT}/usr/NX/scripts/setup/nxnode --install

	elog "If you want server statistics, please add nxsensor to your default runlevel"
	elog
	elog "  rc-update add nxsensor default"
	elog
	elog "You will also need to change ENABLE_SENSOR to 1 in /usr/NX/etc/node.cfg"
}
