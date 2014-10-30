# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/dangerdeep/dangerdeep-0.3.0.ebuild,v 1.12 2013/02/07 22:15:30 ulm Exp $

EAPI=5
inherit eutils scons-utils games subversion toolchain-funcs

DESCRIPTION="a World War II German submarine simulation"
HOMEPAGE="http://dangerdeep.sourceforge.net/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
#	mirror://sourceforge/${PN}/${PN}-data-${PV}.zip"
ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk/${PN}"

LICENSE="GPL-2 CC-BY-NC-ND-2.0"
SLOT="0"
KEYWORDS=""
IUSE="sse debug"

RDEPEND="virtual/opengl
	virtual/glu
	sci-libs/fftw:3.0
	media-libs/libsdl[joystick,opengl,video]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-net"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build.patch
	sed -i -e "/console_log.txt/ s:fopen.*:stderr;:" src/system.cpp || die
}

src_configure() {
	local sse=-1

	if use sse ; then
		use amd64 && sse=3 || sse=1
	fi

	myesconsargs=(
		CXX="$(tc-getCXX)"
		usex86sse=${sse}
		datadir="${GAMES_DATADIR}"/${PN}
		$(use_scons debug)
	)
}

src_compile() {
	escons
}

src_install() {
	dogamesbin build/linux/${PN}

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/*

	newicon dftd_icon.png ${PN}.png
	make_desktop_entry ${PN} "Danger from the Deep"

	dodoc ChangeLog CREDITS README

	prepgamesdirs
}
