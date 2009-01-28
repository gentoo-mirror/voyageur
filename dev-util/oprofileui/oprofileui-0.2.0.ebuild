# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A user interface to the stochastic system profiler OProfile"
HOMEPAGE="http://projects.o-hand.com/oprofileui/"
SRC_URI="http://projects.o-hand.com/sources/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE="server-only"
RDEPEND="=dev-libs/glib-2*
	!server-only? ( gnome-base/gnome-vfs )
	>=dev-util/oprofile-0.9.3-r1"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_compile() {
	econf \
		$(use_enable !server-only client) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog NEWS README || die "installing docs failed"
}
