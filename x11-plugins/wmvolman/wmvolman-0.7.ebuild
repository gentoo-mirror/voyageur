# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="A volume manager dockapp for windowmaker"
HOMEPAGE="http://people.altlinux.ru/~raorn/wmvolman.html"
SRC_URI="http://people.altlinux.ru/~raorn/${P}.tar.bz2"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"

DEPEND=">=sys-apps/hal-0.5.0
        dev-libs/dbus-glib
        >=x11-libs/libdockapp-0.6.0
        dev-util/pkgconfig
        sys-apps/pmount"

IUSE=""

src_compile() {
	econf || die "Configuration failed"
	emake || die "Compilation failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README
}

pkg_postinst() {
	echo
	einfo "Properties are set from 30-wmvolman.fdi file which is installed"
	einfo "by default to /etc/hal/fdi/policy/ and used by HAL."
	einfo "You can add you own rules that adds or removes 'wmvolman.*'"
	einfo "properties.  Refer to HAL documentation for more info."
	echo
	einfo "You must start DBUS and HAL to use this dockapp." 
}
