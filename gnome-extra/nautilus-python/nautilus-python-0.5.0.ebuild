# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="Python bindings for Nautilus extensions"
HOMEPAGE="http://svn.gnome.org/viewcvs/nautilus-python/"
SRC_URI="http://ftp.gnome.org/pub/gnome/sources/${PN}/0.5/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.3
	>=gnome-base/nautilus-2.6
	>=gnome-base/eel-2.6
	>=dev-python/pygtk-2.8
	>=dev-python/gnome-python-2.12"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}

