# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils multilib toolchain-funcs

MY_PN="SFML"
DESCRIPTION="Simple and fast multimedia library"
HOMEPAGE="http://sfml.sourceforge.net/"
SRC_URI="mirror://sourceforge/sfml/${MY_PN}-${PV}-sdk-linux-32.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="media-libs/freetype:2
	media-libs/libsndfile
	media-libs/openal
	virtual/jpeg
	media-libs/libpng
	media-libs/glew
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-destdir.patch
	epatch "${FILESDIR}"/${P}-deps-and-cflags.patch
}

src_compile() {
	emake CPP=$(tc-getCXX) CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" prefix=/usr libdir=$(get_libdir) install || die "emake install failed"
}
