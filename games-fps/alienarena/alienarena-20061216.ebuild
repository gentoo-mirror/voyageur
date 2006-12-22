# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs games

DATE=${PV:4:2}${PV:6:2}${PV:0:4}

DESCRIPTION="The ultimate freeware deathmatch fragfest!"
HOMEPAGE="http://red.planetarena.org/"
SRC_URI="http://cor.planetquake.gamespy.com/codered/files/alienarena2007-linux${DATE}-x86.zip"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug opengl sdl"

QA_EXECSTACK="${GAMES_DATADIR:1}/${PN}/crx
	${GAMES_DATADIR:1}/${PN}/crx.sdl"

UIRDEPEND="media-libs/jpeg
	virtual/glu
	virtual/opengl
	sdl? ( >=media-libs/libsdl-1.2.8-r1 )
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXxf86dga
	x11-libs/libXxf86vm"
RDEPEND="opengl? ( ${UIRDEPEND} )
	sdl? ( ${UIRDEPEND} )
	!games-fps/alienarena-bin"
DEPEND="${RDEPEND}
	x11-proto/xf86dgaproto
	x11-proto/xf86vidmodeproto
	x11-proto/xproto
	app-arch/unzip"

basedir=${WORKDIR}/${PN}2007
S=${basedir}/source/linux
dir=${GAMES_DATADIR}/${PN}
libdir=${GAMES_LIBDIR}/${PN}

src_unpack() {
	unpack ${A}

	cd "${basedir}"

	# Startup scripts
	sed -i \
		-e "s:/usr/local/games/${PN}2007:.:" \
		AlienArena || die "sed AlienArena failed"

	cp -f AlienArena{,.sdl}
	sed -i \
		-e "s:crx:crx.sdl:" \
		AlienArena.sdl || die "sed AlienArena.sdl failed"

	cd "${S}"

	# Directory for library file
	sed -i \
		-e "s:FS_AddHomeAsGameDirectory(BASEDIRNAME):FS_AddHomeAsGameDirectory(BASEDIRNAME);\tFS_AddGameDirectory (\"${libdir}\"):" \
		../qcommon/files.c || die "sed files.c failed"

	# Directory for executables
	sed -i \
		-e "s:debug\$(ARCH):release:" \
		-e "s:release\$(ARCH):release:" \
		Makefile{,.org} || die "sed Makefile release failed"

	local sdlsound=0
	use sdl && sdlsound=1
	# Explicitly set sdl
	sed -i \
		-e "s:\$(strip \$(SDLSOUND)):${sdlsound}:" \
		Makefile{,.org} || die "sed Makefile sdl failed"
}

src_compile() {
	local target="release"
	use debug && target="debug"

	emake \
		CC="$(tc-getCC)" \
		build_${target} \
		|| die "emake failed"
}

src_install() {
	local icon=${PN}.xpm
	doicon "${basedir}/${icon}" || die "doicon failed"

	local arch_ext="i386"
	use amd64 && arch_ext="x86_64"
	exeinto "${libdir}"
	doexe "release/game${arch_ext}.so" || die "doexe game${arch_ext}.so failed"

	exeinto "${dir}"
	doexe release/crded || die "doexe crded failed"
	doexe release/crx || die "doexe crx failed"
	if use sdl ; then
		doexe release/crx.sdl || die "doexe crx.sdl failed"
	fi

	# Always install the dedicated executable
	exeinto "${dir}"
	doexe "${basedir}"/AlienArenaDedicated \
		|| die "doexe AlienArenaDedicated failed"
	games_make_wrapper ${PN}-ded ./AlienArenaDedicated "${dir}"

	if use opengl || use sdl ; then
		# SDL implies OpenGL
		exeinto "${dir}"
		doexe "${basedir}"/AlienArena \
			|| die "doexe AlienArena failed"
		if use sdl ; then
			doexe "${basedir}"/AlienArena.sdl \
				|| die "doexe AlienArena.sdl failed"
			games_make_wrapper ${PN}-sdl ./AlienArena.sdl "${dir}"
			# Distinguish between OpenGL and SDL versions
			make_desktop_entry ${PN} "Alien Arena (OpenGL)" "${icon}"
			make_desktop_entry ${PN}-sdl "Alien Arena (SDL)" "${icon}"
		else
			make_desktop_entry ${PN} "Alien Arena" "${icon}"
		fi
		games_make_wrapper ${PN} ./AlienArena "${dir}"
	fi

	# Install
	insinto "${dir}"
	exeinto "${dir}"
	doins -r "${basedir}"/{arena,botinfo,data1} || die "doins -r failed"

	dodoc "${basedir}"/README.txt || die

	prepgamesdirs
}
