# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games subversion

DESCRIPTION="The new Blobby Volley, a volley-game with colorful blobs"
HOMEPAGE="http://blobby.sourceforge.net"
ESVN_REPO_URI="https://blobby.svn.sourceforge.net/svnroot/blobby/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-util/cmake"
RDEPEND="virtual/opengl
	media-libs/libsdl
	dev-games/physfs"

src_compile() {
	cmake . \
		-DCMAKE_INSTALL_PREFIX:PATH=/usr \
		-DCMAKE_CXX_COMPILER:FILEPATH="$(tc-getCXX)" \
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
		-DCMAKE_C_COMPILER:FILEPATH="$(tc-getCC)" \
		-DCMAKE_C_FLAGS="${CFLAGS}" \
		|| die "cmake failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR=${D} install || die "installing failed"

	prepgamesdirs
}
