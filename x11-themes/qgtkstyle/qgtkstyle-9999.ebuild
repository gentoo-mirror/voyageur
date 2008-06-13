# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion qt4

DESCRIPTION="make QT 4.x appplications look like native GTK+"
HOMEPAGE="http://labs.trolltech.com/page/Projects/Styles/GtkStyle"
ESVN_REPO_URI="svn://labs.trolltech.com/svn/styles/gtkstyle"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.0
		>=x11-libs/qt-4.0"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

src_compile() {
	eqmake4 qgtkstyle.pro || die "qmake failed"
	emake || die "make failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "make install failed"
}
