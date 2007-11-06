# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="A VNC Client for the GNOME Desktop"
HOMEPAGE="http://www.gnome.org/projects/vinagre/index.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/gtk-vnc"
RDEPEND="${DEPEND}"

