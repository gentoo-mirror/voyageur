# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="A GNOME applet that uses XMLTV to monitor current and upcoming TV programs."
HOMEPAGE="http://johan.svedberg.com/projects/coding/${PN}"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/${PN}/2.0/${P}.tar.gz
	 http://johan.svedberg.com/projects/coding/${PN}/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.8
	 >=gnome-base/gnome-panel-2.12
	 >=dev-lang/python-2.4
	 >=dev-python/pygtk-2.8
	 >=media-tv/xmltv-0.5
	 >=dev-python/gnome-python-2.12
	 >=dev-python/gnome-python-extras-2.12
	 >=sys-apps/dbus-0.60
	 >=x11-libs/libnotify-0.3.2
	 dev-python/pyorbit
	 dev-python/celementtree"
	
src_unpack() {
	unpack ${A}
	gnome2_omf_fix
}

src_install() {
	gnome2_src_install
}
