# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Galago feed plugin for Gaim."
HOMEPAGE="http://www.galago-project.org"
SRC_URI="http://www.galago-project.org/files/releases/source/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=dev-libs/glib-2.2.2
	>=dev-libs/libgalago-0.3.2
	>=sys-apps/galago-daemon-0.3.2
	>=net-im/gaim-1*"

src_compile() {
	econf $(use_enable nls) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS
}
