# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

ESVN_REPO_URI="svn://svn.beryl-project.org/beryl/trunk/${PN}"

DESCRIPTION="BDock (svn)"
HOMEPAGE="http://beryl-project.org"
SRC_URI=""

LICENSE="X11"
SLOT="0"
KEYWORDS="-*"
IUSE="dbus"

DEPEND=">=x11-libs/gtk+-2
	x11-libs/libwnck"

S="${WORKDIR}/${PN}"

pkg_setup() {
	if ! built_with_use x11-libs/gtk+ tiff ; then
		echo
		eerror "In order for bdock to work properly,"
		eerror "x11-libs/gtk+ needs to be compiled with USE=\"tiff\""
		die "x11-libs/gtk+ was not built with tiff support"
	fi
}

src_compile() {
	eautoreconf || die "eautoreconf failed"

	econf || die "econf failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}

pkg_postinst() {
	einfo "Please report all bugs to http://bugs.gentoo-xeffects.org"
	einfo "Thank you on behalf of the Gentoo XEffects team"
}
