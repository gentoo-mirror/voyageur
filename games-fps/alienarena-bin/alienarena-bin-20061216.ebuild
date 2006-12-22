# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

MY_PN="alienarena"
DATE=${PV:4:2}${PV:6:2}${PV:0:4}

DESCRIPTION="The ultimate freeware deathmatch fragfest!"
HOMEPAGE="http://red.planetarena.org/"
SRC_URI="http://cor.planetquake.gamespy.com/codered/files/alienarena2007-linux${DATE}-x86.zip"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug opengl sdl"

QA_EXECSTACK="${GAMES_PREFIX_OPT:1}/${PN}/crx
	${GAMES_PREFIX_OPT:1}/${PN}/crx.sdl"

UIRDEPEND="media-libs/jpeg
	virtual/glu
	virtual/opengl
	sdl? ( >=media-libs/libsdl-1.2.8-r1 )
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXxf86dga
	x11-libs/libXxf86vm
	amd64? ( app-emulation/emul-linux-x86-sdl )"
RDEPEND="opengl? ( ${UIRDEPEND} )
	sdl? ( ${UIRDEPEND} )
	!games-fps/alienarena"
DEPEND="${RDEPEND}
	app-arch/unzip"

basedir=${WORKDIR}/${MY_PN}2007
S=${basedir}/source/linux
dir=${GAMES_PREFIX_OPT}/${MY_PN}

QA_EXECSTACK="${dir:1}/crded
	${dir:1}/crx
	${dir:1}/crx.sdl"

src_unpack() {
	unpack ${A}

	cd "${basedir}"

	# Startup scripts
	sed -i \
		-e "s:/usr/local/games/${MY_PN}2007:.:" \
		AlienArena || die "sed AlienArena failed"

	cp -f AlienArena{,.sdl}
	sed -i \
		-e "s:crx:crx.sdl:" \
		AlienArena.sdl || die "sed AlienArena.sdl failed"
}

src_compile() { :; }

src_install() {
	local icon=${MY_PN}.xpm
	doicon "${basedir}/${icon}" || die "doicon failed"

	# Always install the dedicated executable
	exeinto "${dir}"
	doexe "${basedir}"/AlienArenaDedicated \
		|| die "doexe AlienArenaDedicated failed"
	games_make_wrapper ${MY_PN}-ded ./AlienArenaDedicated "${dir}"

	if use opengl || use sdl ; then
		# SDL implies OpenGL
		games_make_wrapper ${MY_PN} ./AlienArena "${dir}" "${dir}"
		if use sdl ; then
			games_make_wrapper ${MY_PN}-sdl ./AlienArena.sdl "${dir}" "${dir}"
			# Distinguish between OpenGL and SDL versions
			make_desktop_entry ${MY_PN} "Alien Arena (OpenGL)" "${icon}"
			make_desktop_entry ${MY_PN}-sdl "Alien Arena (SDL)" "${icon}"
		else
			make_desktop_entry ${MY_PN} "Alien Arena" "${icon}"
		fi
	fi

	insinto "${dir}"
	doins -r "${basedir}"/{arena,botinfo,data1} || die "doins -r failed"

	exeinto "${dir}"
	doexe "${basedir}"/{AlienArena*,crded,crx,crx.sdl} || die "doexe failed"

	if $(diff -q "${D}/${dir}"/{arena,data1}/gamei386.so) ; then
		# Replace duplicate file with symlink
		dosym "${dir}"/{arena,data1}/gamei386.so || die "dosym failed"
	fi

	dodoc "${basedir}"/README.txt || die

	prepgamesdirs
}
