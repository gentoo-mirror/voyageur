# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dvdstyler/dvdstyler-1.4.ebuild,v 1.3 2005/12/15 04:31:14 spyderous Exp $

inherit eutils wxwidgets

MY_P=DVDStyler-${PV/_beta/b}

DESCRIPTION="DVD filesystem Builder"
HOMEPAGE="http://dvdstyler.sourceforge.net"
SRC_URI="mirror://sourceforge/dvdstyler/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

RDEPEND="app-cdr/dvd+rw-tools
	dev-libs/expat
	dev-libs/glib
	media-libs/tiff
	media-libs/libpng
	media-libs/jpeg
	media-libs/netpbm
	>=media-video/dvdauthor-0.6.10
	media-video/mpgtx
	>=media-video/mjpegtools-1.6.2
	sys-libs/zlib
	x11-libs/gtk+
	=x11-libs/wxGTK-2.6*
	>=media-libs/wxSVG-1.0_beta7
	virtual/cdrtools
	virtual/libc
	gnome? ( >=gnome-base/libgnomeui-2.0 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_compile() {
	export WX_GTK_VER="2.6"
	need-wxwidgets gtk2
	myconf="${myconf} --with-wx-config=${WX_CONFIG}"
	econf ${myconf} || die "econf failed!"
	emake || die "emake failed!"
}

src_install() {
	make DESTDIR=${D} install || die "failed to install"
	rm ${D}usr/share/doc/${PN}/COPYING ${D}usr/share/doc/${PN}/INSTALL
	mv ${D}usr/share/doc/${PN} ${D}usr/share/doc/${PF}

	make_desktop_entry dvdstyler DVDStyler dvdstyler.png Application
}
