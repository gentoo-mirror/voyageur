# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOMAKE=1.6

inherit eutils wxwidgets

DESCRIPTION="C++ library to create, manipulate and render SVG files"
HOMEPAGE="http://wxsvg.sourceforge.net/"

MY_PN=`echo ${PN} | tr A-Z a-z`
MY_PV="${PV/_beta/b}"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_PN}-${MY_PV}.tar.gz"
LICENSE="wxWinLL-3" # NOTE - it is actually licensed under version 3.1
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND=">=x11-libs/wxGTK-2.6"

S=${WORKDIR}/${MY_PN}-${MY_PV}

src_compile() {
	cd "${S}"
	libtoolize --copy --force
	./autogen.sh
	export WX_GTK_VER="2.6"
	need-wxwidgets gtk2
	myconf="${myconf} --with-wx-config=${WX_CONFIG}"
	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "failed to install"
}
