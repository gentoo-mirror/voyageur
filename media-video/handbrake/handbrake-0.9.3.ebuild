# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils

MY_P="HandBrake-${PV}"
DESCRIPTION="Open-source DVD to MPEG-4 converter."
HOMEPAGE="http://handbrake.fr/"
SRC_URI="http://handbrake.fr/rotation.php?file=${MY_P}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+gtk"

RDEPEND="gtk? (	>=x11-libs/gtk+-2.8
			>=gnome-extra/gtkhtml-3.14 )"
DEPEND="sys-libs/zlib
	dev-util/ftjam
	$RDEPEND"

S="${WORKDIR}/${MY_P}"

src_compile() {
	einfo "Building HandBrakeCLI."
	emake || die "make HandBrakeCLI failed"

	if use gtk ; then
		cd ${S}/gtk
		einfo "Building ghb."
		./autogen.sh || die "gtk autogen.sh failed"
		econf || die "configuration failed"
		emake || die "make ghb failed"
	fi
}

src_install() {
	into /usr
	dobin HandBrakeCLI
	dodoc AUTHORS BUILD CREDITS NEWS THANKS TRANSLATIONS
	if use gtk ; then
		cd ${S}/gtk
		emake DESTDIR=${D} install || die "installation failed"
	fi
}
