# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit eutils

DESCRIPTION="A lightweight web browser"
HOMEPAGE="http://www.twotoasts.de/index.php?/pages/midori_summary.html"
SRC_URI="http://goodies.xfce.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls +soup sqlite"

DEPEND="x11-libs/gtk+
	net-libs/webkit-gtk
	nls? ( sys-devel/gettext )
	soup? ( net-libs/libsoup )
	sqlite? ( dev-db/sqlite )"
RDEPEND="${DEPEND}"

pkg_setup() {
	ewarn "Note: this software is not yet in a too mature status so expect some minor things to break"
}

src_compile() {
	./waf --prefix="/usr/" configure || die "waf configure failed."
	./waf build || die "waf build failed."
}

src_install() {
	DESTDIR=${D} ./waf install || die "waf install failed."
	dodoc AUTHORS ChangeLog INSTALL TODO
}
