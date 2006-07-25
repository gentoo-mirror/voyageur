# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/doomsday/doomsday-1.8.6.ebuild,v 1.1 2005/01/25 02:45:01 vapier Exp $

inherit eutils flag-o-matic games

DESCRIPTION="A modern gaming engine for Doom, Heretic, and Hexen"
HOMEPAGE="http://www.doomsdayhq.com/"
SRC_URI="mirror://sourceforge/deng/deng-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86 ~amd64"
IUSE="openal"

DEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-net
	openal? ( media-libs/openal )
	amd64? (
		app-emulation/emul-linux-x86-xlibs
		app-emulation/emul-linux-x86-soundlibs
		app-emulation/emul-linux-x86-sdl)"

S=${WORKDIR}/deng-${PV}

pkg_setup() {
	if use amd64 ; then
		if ! has_m32; then
			eerror "Your compiler seems to be unable to compile 32bit code."
			eerror "Make sure you compile gcc with:"
			echo
			eerror "	USE=multilib FEATURES=-sandbox"
			die "Cannot produce 32bit code"
		else
			export ABI=x86
		fi
	fi
}

src_compile() {
	egamesconf
	if use amd64 ; then
		cd ${S}
		sed -i 's/lib64/lib32/g' Makefile */Makefile Src/*/Makefile  \
								 libtool libltdl/libtool
	fi

}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	rmdir "${D}/${GAMES_PREFIX}/include"
	mv "${D}/${GAMES_DATADIR}/"{deng/Data/jDoom,doom-data}
	dosym "${GAMES_DATADIR}"/doom-data "${GAMES_DATADIR}"/deng/Data/jDoom

	local game
	for game in jdoom jheretic jhexen ; do
		newgamesbin "${FILESDIR}/wrapper" ${game}
		sed -i \
			-e "s:GAME:${game}:" "${D}"/${GAMES_BINDIR}/${game} \
			|| die "sed ${GAMES_BINDIR}/${game} failed"
	done

	dodoc Doc/*.txt Doc/*/*.txt README
	prepgamesdirs
}
