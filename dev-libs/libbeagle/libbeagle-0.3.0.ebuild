# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit gnome.org autotools

DESCRIPTION="C and Python bindings for Beagle"
HOMEPAGE="http://beagle-project.org"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/libbeagle/0.3/${P}.tar.bz2"

LICENSE="MIT Apache-1.1"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="debug doc +python"

RDEPEND="python? ( >=dev-lang/python-2.3
	>=dev-python/pygtk-2.6 )"
DEPEND="${RDEPEND}
	>=dev-libs/glib-2.6
	>=dev-libs/libxml2-2.6.19
	doc? ( dev-util/gtk-doc )"

src_compile() {
	econf \
		$(use_enable python) \
		$(use_enable doc gtk-doc) \
		$(use_enable debug xml-dump)

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed!"
}

