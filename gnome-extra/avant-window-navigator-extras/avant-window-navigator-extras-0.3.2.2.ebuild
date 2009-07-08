# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/avant-window-navigator-extras/avant-window-navigator-extras-0.3.2.1.ebuild,v 1.2 2009/03/15 00:18:02 eva Exp $

EAPI="2"

inherit eutils gnome2 python

MY_P="awn-extras-applets-${PV}"
DESCRIPTION="Applets for Avant Window Navigator"
HOMEPAGE="https://launchpad.net/awn-extras"
SRC_URI="https://launchpad.net/awn-extras/0.2/${PV}/+download/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome gstreamer webkit"

COMMON_DEPEND="
	>=dev-libs/dbus-glib-0.70
	>=dev-python/pygobject-2
	>=dev-python/pygtk-2
	>=gnome-extra/avant-window-navigator-0.3.1[gnome=]
	x11-libs/libnotify
	x11-libs/libsexy
	x11-libs/libXcomposite
	x11-libs/libXrender
	>=x11-libs/libwnck-2.22
	x11-libs/vte
	gnome? (
		gnome-base/gnome-menus
		>=gnome-base/gconf-2
		>=gnome-base/gnome-vfs-2
		>=gnome-base/libgtop-2
		gnome-base/librsvg
	)
	gstreamer? (
		dev-python/gst-python
		>=media-libs/gstreamer-0.10.15
	)
	webkit? ( net-libs/webkit-gtk )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.17
"
RDEPEND="${COMMON_DEPEND}
	dev-python/feedparser
	dev-python/notify-python
	dev-python/pyalsaaudio
	gnome? (
		dev-python/gconf-python
		dev-python/gnome-applets-python
		dev-python/gnome-desktop-python
		dev-python/gnome-keyring-python
		dev-python/gnome-media-python
		dev-python/gnome-vfs-python
		dev-python/gtkmozembed-python
		dev-python/libgnomecanvas-python
		dev-python/libgnomeprint-python
		dev-python/libgnome-python
		dev-python/librsvg-python
		dev-python/libwnck-python
		gnome-base/gnome-menus[python]
	)
"

DOCS="AUTHORS ChangeLog NEWS README"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use gstreamer; then
		G2CONF="${G2CONF} --enable-sound=gstreamer"
	else
		G2CONF="${G2CONF} --enable-sound=no"
	fi

	G2CONF="${G2CONF}
		--disable-static
		--disable-pymod-checks
		$(use_with gnome gconf)
		$(use_with gnome)
		$(use_with webkit)"
}

src_prepare() {
	# Disable pyc compiling.
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

src_install() {
	gnome2_src_install

	if use gnome ; then
		# Give the gconf schemas non-conflicting names.
		mv "${D}/etc/gconf/schemas/notification-daemon.schemas" \
			"${D}/etc/gconf/schemas/awn-notification-daemon.schemas"
		mv "${D}/etc/gconf/schemas/awnsystemmonitor.schemas" \
			"${D}/etc/gconf/schemas/awn-system-monitor.schemas"
		mv "${D}/etc/gconf/schemas/filebrowser.schemas" \
			"${D}/etc/gconf/schemas/awn-filebrowser.schemas"
		mv "${D}/etc/gconf/schemas/switcher.schemas" \
			"${D}/etc/gconf/schemas/awn-switcher.schemas"
		mv "${D}/etc/gconf/schemas/trash.schemas" \
			"${D}/etc/gconf/schemas/awn-trash.schemas"
		mv "${D}/etc/gconf/schemas/shinyswitcher.schemas" \
			"${D}/etc/gconf/schemas/awn-shinyswitcher.schemas"
		mv "${D}/etc/gconf/schemas/places.schemas" \
			"${D}/etc/gconf/schemas/awn-places.schemas"
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/awn/extras
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_version
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/awn/extras
}
