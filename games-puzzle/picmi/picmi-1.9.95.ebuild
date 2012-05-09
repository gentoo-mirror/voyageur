# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils

DESCRIPTION="A minesweeper and picross clone"
HOMEPAGE="http://github.com/schuay/picmi-rewrite"
SRC_URI="http://github.com/downloads/schuay/${PN}-rewrite/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="kde-base/kdelibs:4
	kde-base/libkdegames:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}
