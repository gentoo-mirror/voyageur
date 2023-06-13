# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake xdg

DESCRIPTION="a volley-game with colorful blobs"
HOMEPAGE="http://blobby.sourceforge.net"
SRC_URI="mirror://sourceforge/blobby/${PN}-linux-${PV/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=dev-games/physfs-2[zip]
	dev-libs/boost
	dev-libs/tinyxml2
	media-libs/libsdl2[sound,joystick,opengl,video]
	virtual/opengl"
DEPEND="${RDEPEND}"

S="${WORKDIR}/blobby-${PV/_}"
