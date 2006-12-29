# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils flag-o-matic games

DESCRIPTION="Advanced source port for Doom/Heretic/Hexen/Strife"
HOMEPAGE="http://www.vavoom-engine.com"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="allegro debug dedicated external-glbsp flac mad mikmod models \
music openal opengl sdl textures tools vorbis"

QA_EXECSTACK="${GAMES_BINDIR:1}/${PN}"

# From econf:  "Vavoom requires Allegro or SDL to compile"
# sdl is a *software* renderer in this game.
# So default to sdl, with opengl.
# opengl is the normally-desired hardware renderer, selected on command-line.
SDLDEPEND="media-libs/libsdl
	media-libs/sdl-mixer"
OPENGLDEPEND="virtual/opengl
	sdl? ( ${SDLDEPEND} )
	allegro? ( media-libs/allegrogl )
	!sdl? ( !allegro? ( ${SDLDEPEND} ) )"
RDEPEND="media-libs/libpng
	allegro? ( media-libs/allegro )
	flac? ( media-libs/flac )
	mad? ( media-libs/libmad )
	mikmod? ( media-libs/libmikmod )
	media-sound/timidity++
	opengl? ( ${OPENGLDEPEND} )
	sdl? ( ${SDLDEPEND} )
	!sdl? ( !allegro? ( !dedicated? ( ${OPENGLDEPEND} ) ) )
	openal? ( media-libs/openal )
	external-glbsp? ( games-util/glbsp )
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}
	x11-proto/xf86dgaproto"
PDEPEND="models? ( games-fps/vavoom-models )
	music? ( games-fps/vavoom-music )
	textures? ( games-fps/vavoom-textures )"

dir=${GAMES_DATADIR}/${PN}

pkg_setup() {
	games_pkg_setup

	if ! use opengl ; then
		ewarn "The 'opengl' USE flag is recommended, for best graphics."
	fi
}

build_client() {
	if use allegro || use opengl || use sdl || ! use dedicated ; then
		# Build default client
		return 0
	fi
	return 1
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Set shared directory
	sed -i \
		-e "s:fl_basedir = \".\":fl_basedir = \"${dir}\":" \
		source/files.cpp || die "sed files.cpp failed"

	eautoreconf

	# Set executable filenames
	local m
	for m in $(find . -type f -name Makefile.in) ; do
		sed -i \
			-e "s:MAIN_EXE = @MAIN_EXE@:MAIN_EXE=${PN}:" \
			-e "s:SERVER_EXE = @SERVER_EXE@:SERVER_EXE=${PN}-ded:" \
			"${m}" || die "sed ${m} failed"
	done
}

src_compile() {
	local \
		client="--disable-client"
		sdl="--without-sdl"
		opengl="--without-opengl"
	if build_client ; then
		client="--enable-client"
		if use sdl || ! use allegro ; then
			# Build sdl
			sdl="--with-sdl"
			if ! use sdl && ! use opengl ; then
				# Default to including opengl also
				opengl="--with-opengl"
			fi
		fi
		if use opengl ; then
			# Build opengl
			opengl="--with-opengl"
		fi
	fi

	if use debug ; then
		append-flags -g2
	fi

	egamesconf \
		${client} \
		${sdl} \
		${opengl} \
		$(use_with allegro) \
		$(use_with openal) \
		$(use_with external-glbsp) \
		$(use_with vorbis) \
		$(use_with mad libmad) \
		$(use_with mikmod) \
		$(use_with flac) \
		$(use_enable dedicated server) \
		$(use_enable debug) \
		$(use_enable debug zone-debug) \
		--with-iwaddir="${GAMES_DATADIR}/${PN}" \
		|| die "egamesconf failed"

	# Parallel compiling seems to be broken
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -f "${D}/${GAMES_BINDIR}"/*

	# Remove unneeded icon
	rm -f "${D}/${GAMES_DATADIR}/${PN}/${PN}.png"

	doicon source/${PN}.png || die "doicon failed"

	if build_client ; then
		dogamesbin ${PN} || die "dogamesbin ${PN} failed"
		make_desktop_entry ${PN} "Vavoom"
	fi

	if use dedicated ; then
		dogamesbin ${PN}-ded || die "dogamesbin ${PN}-ded failed"
	fi

	dodoc docs/${PN}.txt || die

	if use tools; then
		# The tools are always built
		dobin utils/bin/{acc,fixmd2,vcc,vlumpy} || die "dobin utils failed"
		dodoc utils/vcc/vcc.txt || die
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "Copy or link wad files into ${GAMES_DATADIR}/${PN}"
	elog "(the files must be readable by the 'games' group)."
	elog
	elog "Example setup:"
	elog "ln -sn ${GAMES_DATADIR}/doom-data/doom.wad ${GAMES_DATADIR}/${PN}/"
	elog
	elog "Example command-line:"
	elog "   vavoom -doom -opengl"
	elog
	elog "See documentation for further details."

	if use tools; then
		echo
		elog "You have also installed some Vavoom-related utilities"
		elog "(useful for mod developing):"
		elog
		elog " - acc (ACS Script Compiler)"
		elog " - fixmd2 (MD2 models utility)"
		elog " - vcc (Vavoom C Compiler)"
		elog " - vlumpy (Vavoom Lump utility)"
		elog
		elog "See the Vavoom Wiki at http://vavoom-engine.com/wiki/ or"
		elog "Vavoom Forum at http://www.vavoom-engine.com/forums/"
		elog "for further help."
	fi
}
