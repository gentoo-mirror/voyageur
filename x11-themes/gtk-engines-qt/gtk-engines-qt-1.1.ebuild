# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit eutils qt4

MY_PN="gtk-qt-engine"
DESCRIPTION="GTK+2 Qt4 Theme Engine"
HOMEPAGE="http://gtk-qt.ecs.soton.ac.uk"
SRC_URI="http://gtk-qt.ecs.soton.ac.uk/files/${PV}/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=x11-libs/qt-4.3:4
	>=x11-libs/gtk+-2.2
	dev-util/cmake"
RDEPEND=""

SLOT="3"

S=${WORKDIR}/${MY_PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-stdlib.patch"
}

src_install() {
	make DESTDIR="${D}" install
}
