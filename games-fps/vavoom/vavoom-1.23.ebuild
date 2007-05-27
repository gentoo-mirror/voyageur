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
# SDL,like Allegro are *software* renderers in this game.
# So, if not selected through proper USEs, the default is SDL,
# without opengl (vavoom can run in software-mode only).
# To enable it, enable proper USE.
# OpenGL is the normally-desired hardware renderer, selected on command-line
# (through "-opengl" switch). This switch is also added to the desktop entry,
# if "opengl" USE flag is enabled

SDLDEPEND=">=media-libs/libsdl-1.2
	media-libs/sdl-mixer"
ALLEGDEPEND=">=media-libs/allegro-4.0"
OPENGLDEPEND="opengl? ( virtual/opengl )
	sdl? ( ${SDLDEPEND} )
	allegro? ( media-libs/allegrogl )
	!sdl? ( !allegro? ( ${SDLDEPEND} ) )"
DEPEND="media-libs/libpng
	media-libs/jpeg
	sdl? ( ${SDLDEPEND} )
	!sdl? ( allegro? ( ${ALLEGDEPEND} ) )
	!sdl? ( !allegro? ( !dedicated? ( ${OPENGLDEPEND} ) ) )
	opengl? ( ${OPENGLDEPEND} )
	vorbis? ( media-libs/libvorbis )
	flac? ( media-libs/flac )
	mad? ( media-libs/libmad )
	mikmod? ( media-libs/libmikmod )
	openal? ( media-libs/openal )
	external-glbsp? ( games-util/glbsp )"
RDEPEND="${DEPEND}
	allegro? ( media-sound/timidity++ )"
PDEPEND="models? ( >=games-fps/vavoom-models-1.4 )
	music? ( games-fps/vavoom-music )
	textures? ( games-fps/vavoom-textures )"

dir=${GAMES_DATADIR}/${PN}

graphic_ok() {
	! use sdl && use allegro && built_with_use media-libs/allegro X && return 0
	built_with_use media-libs/libsdl X && return 0
	return 1
}

sound_ok() {
	! use sdl && use allegro && built_with_use media-libs/allegro alsa && return 0
	built_with_use media-libs/libsdl alsa && return 0
	return 1
}

music_ok() {
	use allegro && return 0
	built_with_use media-libs/sdl-mixer timidity && return 0
	return 1
}

opengl_ok() {
	built_with_use media-libs/libsdl opengl && return 0
	return 1
}

pkg_setup() {

	local \
		graphic="(SDL)"
		sound="(SDL + ALSA)"
		music="(SDL-mixer + Timidity)"
		opengl="(SDL + sys. OpenGL impl.)"

	! use sdl && use allegro && graphic="(Allegro)"
	! use sdl && use allegro && sound="(Allegro + ALSA)"
	! use sdl && use allegro && music="(Allegro + Timidity)"
	! use sdl && use allegro && opengl="(AllegroGL)"

	games_pkg_setup

	# Do some important check ...

	if use sdl && use allegro ; then
		echo
		ewarn "Both 'allegro' and 'sdl' USE flags enabled"
		ewarn "Set default to SDL"
	fi

	if ! use sdl && ! use allegro ; then
		ewarn "Both 'sdl' and 'allegro' USE flags disabled"
		ewarn "Set default to SDL"
	fi

	# Base graphic/sound/music support is enabled?

	echo
	einfo "Doing some sanity check..."

	if graphic_ok ; then
		einfo "Graphic support is OK...${graphic}"
	else
		echo
		eerror "Graphic support is not configured properly!"
		if use allegro ; then
			eerror "Please rebuild allegro with 'X' USE flag enabled"
		else
			eerror "Please rebuild libsdl with 'X' USE flag enabled"
		fi
		die "graphic support error"
	fi

	if sound_ok ; then
		einfo "Sound support is OK...${sound}"
	else
		echo
		eerror "Sound support is not configured properly!"
		if use allegro ; then
			eerror "Please rebuild allegro with 'alsa' USE flag enabled"
		else
			eerror "Please rebuild libsdl with 'alsa' USE flag enabled"
		fi
		die "sound support error"
	fi

	if music_ok ; then
		einfo "Music support is OK...${music}"
	else
		echo
		eerror "Music support is not configured properly!"
		eerror "Please rebuild sdl-mixer with USE 'timidity' enabled!"
		die "music support error"
	fi

	# OpenGL support is ok? (  check only against SDL, Allegro is always OK
	# because pull in AllegroGL

	if use opengl ; then
		if ( ! use sdl && use allegro ) || opengl_ok ; then
			einfo "OpenGL support is OK...${opengl}"
		else
		echo
			eerror "OpenGL support is not configured properly!"
			eerror "Please rebuild libsdl with 'opengl' USE flag enabled"
			die "opengl support error"
		fi
	else
		ewarn "'opengl' USE flag disabled. OpenGL is recommended, for best graphics."
	fi

	# Does user want external music? Vorbis support is needed
	if use music && ! use vorbis ; then
		echo
		eerror "Ogg/Vorbis support is required for external music playing"
		eerror "Please enable 'vorbis' USE flag for this package"
		die "external music support error"
	fi

	einfo "Ok, let's build!"
	echo
}

build_client() {
	if use allegro || use opengl || use sdl || ! use dedicated ; then
		# Build default client
		return 0
	fi
	return 1
}

src_unpack() {
	unpack ${A} || die "unpack failed"
	cd "${S}"

	# Fix small issue with gcc-4.1.2
	epatch ${FILESDIR}/${P}_gcc-4.1.2_fix.diff
	
	# Small fix for AMD64 platform, taken from upstream SVN
	if use amd64; then
		epatch ${FILESDIR}/${P}_amd64_fix.diff || die "epatch failed"
	fi

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
		allegro="--without-allegro"
		sdl="--without-sdl"
		opengl="--without-opengl"
	if build_client ; then
		client="--enable-client"
		use sdl && sdl="--with-sdl"
		! use sdl && use allegro && allegro="--with-allegro"
		use opengl && opengl="--with-opengl"
	fi

	use debug && append-flags -g2

	egamesconf \
		${client} \
		${sdl} \
		${allegro} \
		${opengl} \
		$(use_with openal) \
		$(use_with external-glbsp) \
		$(use_with vorbis) \
		$(use_with mad libmad) \
		$(use_with mikmod) \
		$(use_with flac) \
		$(use_enable dedicated server) \
		$(use_enable debug) \
		$(use_enable debug zone-debug) \
		--with-iwaddir="${dir}" \
		--disable-dependency-tracking \
		|| die "egamesconf failed"

	# Parallel compiling doesn't work for now :(
	emake -j1 || die "emake failed"
}

src_install() {
	local de_cmd="${PN}"

	emake DESTDIR="${D}" install || die "emake install failed"
	rm -f "${D}/${GAMES_BINDIR}"/*

	# Remove unneeded icon
	rm -f "${D}/${dir}/${PN}.png"

	doicon source/${PN}.png || die "doicon failed"

	if build_client ; then
		# Enable OpenGL in desktop entry, if relevant USE flag is enabled
		use opengl && de_cmd="${PN} -opengl"
		dogamesbin ${PN} || die "dogamesbin ${PN} failed"
		make_desktop_entry "${de_cmd}" "Vavoom"
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

	elog "Copy or link wad files into ${dir}"
	elog "(the files must be readable by the 'games' group)."
	elog
	elog "Example setup:"
	elog "ln -sn ${GAMES_DATADIR}/doom-data/doom.wad ${dir}/"
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
