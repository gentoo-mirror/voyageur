# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Seam carving resizing library and realtime demonstration program"
HOMEPAGE="http://seam-carver.sourceforge.net/"
SRC_URI="mirror://sourceforge/seam-carver/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/tiff
	virtual/jpeg
	x11-libs/gtk+"
RDEPEND="${DEPEND}"
