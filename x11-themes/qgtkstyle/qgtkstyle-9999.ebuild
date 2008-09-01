# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="1"

inherit subversion qt4

MY_PN="gtkstyle"

ESVN_REPO_URI="svn://labs.trolltech.com/svn/styles/${MY_PN}"
ESVN_PROJECT="${MY_PN}"

DESCRIPTION="make QT 4.x appplications look like native GTK+"
HOMEPAGE="http://labs.trolltech.com/page/Projects/Styles/GtkStyle"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.0
	x11-libs/qt-gui:4"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

S=${WORKDIR}/${MY_PN}

src_compile() {
	eqmake4 ${PN}.pro || die "qmake failed"
	emake || die "make failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "make install failed"
}
