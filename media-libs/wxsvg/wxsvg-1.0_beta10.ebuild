# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/wxsvg/wxsvg-1.0_beta7.ebuild,v 1.6 2007/06/17 11:22:45 armin76 Exp $

inherit autotools wxwidgets

MY_PV="${PV/_beta/b}"

DESCRIPTION="C++ library to create, manipulate and render SVG files."
HOMEPAGE="http://wxsvg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${MY_PV}.tar.gz"

LICENSE="wxWinLL-3"
KEYWORDS="~amd64 ~ppc x86"
SLOT="0"
IUSE=""

RDEPEND="=x11-libs/wxGTK-2.8*
	>=dev-libs/glib-2.12
	>=dev-libs/libxml2-2.6.26
	>=media-libs/fontconfig-2.4
	>=media-libs/freetype-2.2.0
	>=media-libs/libart_lgpl-2.3.17
	>=media-video/ffmpeg-0.4.9_p20080326
	>=x11-libs/pango-1.14.9"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-newer_ffmpeg.patch
	AT_M4DIR="${S}" eautoreconf 
}

src_compile() {
	export WX_GTK_VER="2.8"
	need-wxwidgets unicode
	myconf="${myconf} --with-wx-config=${WX_CONFIG}"

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"
	dodoc AUTHORS ChangeLog TODO
}
