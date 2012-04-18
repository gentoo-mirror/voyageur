# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit cmake-utils

DESCRIPTION="synchronizes your folders with another computer"
HOMEPAGE="https://owncloud.com/download"
SRC_URI="http://download.owncloud.com/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=net-misc/csync-0.50.4
	>=x11-libs/qt-gui-4.7"
RDEPEND="${DEPEND}"
