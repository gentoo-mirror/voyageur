# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 mono
DESCRIPTION="QuickSilver-like launcher for the GNOME Desktop"
HOMEPAGE="http://do.davebsd.com/"
SRC_URI="http://do.davebsd.com/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-dotnet/dbus-glib-sharp"
RDEPEND="${DEPEND}
	app-misc/tomboy"
