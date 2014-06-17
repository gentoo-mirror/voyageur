# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit games cmake-utils

DESCRIPTION="a volley-game with colorful blobs"
HOMEPAGE="http://blobby.sourceforge.net"
SRC_URI="mirror://sourceforge/blobby/${PN}-linux-${PV/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO build failures without debug
IUSE="+debug"

RDEPEND="dev-games/physfs
	dev-libs/boost
	media-libs/libsdl2
	virtual/opengl"
DEPEND="${RDEPEND}"

S="${WORKDIR}/blobby-${PV/_}"

src_prepare() {
	sed -i "s|data|/usr/share/blobby|g" src/main.cpp || die
	sed -i "s|file\(filename\)|file(\"/usr/share/blobby\" + filename|g" src/main.cpp || die
}

src_install() {
	cmake-utils_src_install

	insinto usr/share/blobby
	doins data/Icon.bmp

	prepgamesdirs
}

