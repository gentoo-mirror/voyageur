# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson xdg

DESCRIPTION="GTK+ based Audio CD Player/Ripper"
HOMEPAGE="https://sourceforge.net/projects/grip/"
SRC_URI="mirror://sourceforge/grip/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+lame vorbis"

REQUIRED_USE="|| ( lame vorbis )"

RDEPEND="dev-libs/glib:2
	>=media-libs/id3lib-3.8.3
	media-sound/cdparanoia
	net-misc/curl
	>=x11-libs/gtk+-2.14:2
	x11-libs/libX11
	x11-libs/pango
	lame? (	media-sound/lame )
	vorbis? ( media-sound/vorbis-tools )"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext
	virtual/pkgconfig"
