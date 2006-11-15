# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/yelp/yelp-2.16.1.ebuild,v 1.2 2006/10/14 21:33:34 vapier Exp $

inherit gnome2

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~sh ~sparc ~x86"
IUSE="beagle firefox seamonkey xulrunner"

RDEPEND=">=gnome-base/gconf-2
	>=app-text/gnome-doc-utils-0.3.1
	>=x11-libs/gtk+-2.10
	>=gnome-base/gnome-vfs-2
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2.14
	>=gnome-base/libgnomeui-2.14
	>=dev-libs/libxml2-2.6.5
	>=dev-libs/libxslt-1.1.4
	>=x11-libs/startup-notification-0.8
	>=dev-libs/glib-2
	sys-apps/dbus
	beagle? ( >=app-misc/beagle-0.2.4 )
	xulrunner? ( net-libs/xulrunner )
	!xulrunner? ( firefox? ( www-client/mozilla-firefox ) )
	!xulrunner? ( !firefox? ( seamonkey? ( www-client/seamonkey ) ) )
	sys-libs/zlib
	app-arch/bzip2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	# we prefer xulrunner over firefox over seamonkey
	if use xulrunner ; then
		G2CONF="${G2CONF} --enable-gecko=xulrunner"
	elif use firefox ; then
		G2CONF="${G2CONF} --enable-gecko=firefox"
	elif use seamonkey ; then
		G2CONF="${G2CONF} --enable-gecko=seamonkey"
	else
		eerror " You must set one of the firefox/seamonkey/xulrunner USE flags"
		die
	fi

	G2CONF="${G2CONF} --enable-man --enable-info"
}
