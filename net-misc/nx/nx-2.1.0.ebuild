# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

DESCRIPTION="NX compression technology core libraries"
HOMEPAGE="http://www.nomachine.com/developers.php"

URI_BASE="http://web04.nomachine.com/download/${PV}/sources"
SRC_NX_X11="nx-X11-$PV-2.tar.gz"
SRC_NXAGENT="nxagent-$PV-17.tar.gz"
SRC_NXAUTH="nxauth-$PV-1.tar.gz"
SRC_NXCOMP="nxcomp-$PV-6.tar.gz"
SRC_NXCOMPEXT="nxcompext-$PV-4.tar.gz"
SRC_NXDESKTOP="nxdesktop-$PV-8.tar.gz"
SRC_NXVIEWER="nxviewer-$PV-11.tar.gz"
SRC_NXPROXY="nxproxy-$PV-2.tar.gz"

SRC_URI="$URI_BASE/$SRC_NX_X11 $URI_BASE/$SRC_NXAGENT $URI_BASE/$SRC_NXPROXY
	$URI_BASE/$SRC_NXAUTH $URI_BASE/$SRC_NXCOMPEXT $URI_BASE/$SRC_NXCOMP
	rdesktop? ( $URI_BASE/$SRC_NXDESKTOP )
	vnc? ( $URI_BASE/$SRC_NXVIEWER )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="rdesktop vnc"

RDEPEND="x86? ( || ( ( x11-libs/libXau
		   			 x11-libs/libXdmcp
				     x11-libs/libXpm
			       )
			       virtual/x11
				)
				>=media-libs/jpeg-6b-r4
				>=media-libs/libpng-1.2.8
				>=sys-libs/zlib-1.2.3 )
		 amd64? (app-emulation/emul-linux-x86-xlibs)"

DEPEND="${RDEPEND}
		|| ( ( x11-proto/xproto
				x11-proto/xf86vidmodeproto
				x11-proto/glproto
				x11-proto/videoproto
				x11-proto/xextproto
				x11-proto/fontsproto

				x11-misc/gccmakedep
				x11-misc/imake

				app-text/rman
			)
			virtual/x11
		)
		app-text/rman
		!net-misc/nx-x11
		!net-misc/nx-x11-bin
		!net-misc/nxcomp
		!net-misc/nxproxy
		!net-misc/nxssh
		"
S=${WORKDIR}/${PN}-X11

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/1.5.0/nx-x11-1.5.0-tmp-exec.patch
	epatch ${FILESDIR}/1.5.0/nx-x11-1.5.0-amd64.patch

	cd ${WORKDIR}/nxcomp
	epatch ${FILESDIR}/1.5.0/nxcomp-1.5.0-pic.patch
}

src_compile() {
	# nx-X11 will only compile in 32-bit
	use amd64 && multilib_toolchain_setup x86

	cd ${WORKDIR}/nxcomp || die
	econf || die
	emake || die

	cd ${WORKDIR}/nxproxy || die
	econf || die
	emake || die

	cd ${WORKDIR}/nx-X11 || die
	emake World || die

	cd ${WORKDIR}/nxcompext || die
	econf || die
	emake || die

	if use vnc ; then
		cd ${WORKDIR}/nxviewer || die
		xmkmf -a || die
		emake World || die
	fi

	if use rdesktop ; then
		cd ${WORKDIR}/nxdesktop || die
		econf || die
		emake || die
	fi
}

src_install() {
	for x in nxagent nxauth nxproxy; do
		make_wrapper $x ./$x /usr/lib/NX/bin /usr/lib/NX/$(get_libdir) ||die
	done
	if use vnc ; then
		make_wrapper nxviewer ./nxviewer /usr/lib/NX/bin /usr/lib/NX/$(get_libdir) ||die
		make_wrapper nxpasswd ./nxpasswd /usr/lib/NX/bin /usr/lib/NX/$(get_libdir) ||die
	fi
	if use rdesktop ; then
		make_wrapper nxdesktop ./nxdesktop /usr/lib/NX/bin /usr/lib/NX/$(get_libdir) ||die
	fi

	into /usr/lib/NX
	dobin ${WORKDIR}/nx-X11/programs/Xserver/nxagent || die
	dobin ${WORKDIR}/nx-X11/programs/nxauth/nxauth || die
	dobin ${WORKDIR}/nxproxy/nxproxy || die

	if use vnc ; then
		dobin ${WORKDIR}/nxviewer/nxviewer/nxviewer || die
		dobin ${WORKDIR}/nxviewer/nxpasswd/nxpasswd || die
	fi

	if use rdesktop ; then
		dobin ${WORKDIR}/nxdesktop/nxdesktop || die
	fi

	dolib.so ${WORKDIR}/nx-X11/lib/X11/libX11.so* || die
	dolib.so ${WORKDIR}/nx-X11/lib/Xext/libXext.so* || die
	dolib.so ${WORKDIR}/nx-X11/lib/Xrender/libXrender.so* || die
	dolib.so ${WORKDIR}/nxcomp/libXcomp.so* || die
	dolib.so ${WORKDIR}/nxcompext/libXcompext.so* || die
}
