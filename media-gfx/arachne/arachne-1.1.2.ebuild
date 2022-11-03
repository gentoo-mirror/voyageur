# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Seam carving resizing library and realtime demonstration program"
HOMEPAGE="http://seam-carver.sourceforge.net/"
SRC_URI="mirror://sourceforge/seam-carver/${PN/a/A}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/tiff:=
	media-libs/libjpeg-turbo:=
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}"
