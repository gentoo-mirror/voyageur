# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/armagetronad/armagetronad_build/gentoo/client.ebuild,v 1.24 2006/05/05 13:55:13 luke-jr Exp $

inherit flag-o-matic eutils games subversion

DESCRIPTION="3D light cycles like in the movie TRON"
HOMEPAGE="http://armagetronad.net/"

MY_PN="armagetronad"
OPT_CLIENTSRC="
		http://beta.armagetronad.net/fetch.php/PreResource/moviesounds_fq.zip
		linguas_es? ( !linguas_en? (
			http://beta.armagetronad.net/fetch.php/PreResource/spanishvoices.zip
		) )
		http://beta.armagetronad.net/fetch.php/PreResource/moviepack.zip
"
ESVN_REPO_URI="https://${MY_PN}.svn.sourceforge.net/svnroot/${MY_PN}/${MY_PN}/trunk/${MY_PN}"
SRC_URI="
	opengl? ( ${OPT_CLIENTSRC} )
	!dedicated? ( ${OPT_CLIENTSRC} )
"

LICENSE="GPL-2"
SLOT="experimental-live"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="debug dedicated linguas_es linguas_en opengl ruby"

GLDEPS="
	|| (
		x11-libs/libX11
		virtual/x11
	)
	virtual/glu
	virtual/opengl
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/jpeg
	media-libs/libpng
	media-libs/ftgl
"
RDEPEND="
	>=dev-libs/libxml2-2.6.11
	sys-libs/zlib
	opengl? ( ${GLDEPS} )
	!dedicated? ( ${GLDEPS} )
	ruby? ( virtual/ruby >=dev-lang/swig-1.3.29 )
	>=dev-libs/boost-1.33.1
"
OPT_CLIENTDEPS="
	app-arch/unzip
"
DEPEND="${RDEPEND}
	opengl? ( ${OPT_CLIENTDEPS} )
	!dedicated? ( ${OPT_CLIENTDEPS} )
"

S="${WORKDIR}/${MY_PN}"

pkg_setup() {
	if use ruby && ! built_with_use dev-lang/swig ruby ; then
		eerror "You are trying to compile ${CATEGORY}/${PF} with the \"ruby\" USE flag enabled."
		eerror "However, $(best_version dev-lang/swig) was compiled with the ruby flag disabled."
		eerror
		eerror "You must either disable this use flag, or recompile"
		eerror "$(best_version dev-lang/swig) with this ruby use flag enabled."
		die 'swig missing ruby'
	fi
	if use debug; then
		ewarn
		ewarn 'The "debug" USE flag will enable debugging code. This will cause AI'
		ewarn ' players to chat debugging information, debugging lines to be drawn'
		ewarn ' on the grid and at wall angles, and probably most relevant to your'
		ewarn ' decision to keep the USE flag:'
		ewarn '         FULL SCREEN MODE WILL BE DISABLED'
		ewarn
		ewarn "If you don't like this, add this line to /etc/portage/package.use:"
		ewarn '    games-action/armagetronad -debug'
		ewarn
		ewarn 'If you ignore this warning and complain about any of the above'
		ewarn ' effects, the Armagetron Advanced team will either ignore you or'
		ewarn ' delete your complaint.'
		ewarn
		ebeep 5
	fi
	ewarn 'Please note that this is an EXPERIMENTAL RELEASE of Armagetron Advanced.'
	ewarn 'It has known bugs, and is not meant to be well-tested or stable.'
	ewarn '                    PLAY AT YOUR OWN RISK'
}

src_unpack() {
	for f in ${A}; do
		unpack "$f"
	done
	subversion_src_unpack
	rsync -rlpgo "${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/}/.svn" "${S}" || ewarn ".svn directory couldn't be copied; your version number will use the current date instead of revision"
}

aabuild() {
	MyBUILDDIR="${WORKDIR}/build-$1"
	mkdir -p "${MyBUILDDIR}" || die "error creating build directory($1)"	# -p to allow EEXIST scenario
	cd "${MyBUILDDIR}"
	use debug && DEBUGLEVEL=3 || DEBUGLEVEL=0
	export DEBUGLEVEL CODELEVEL=0
	[ "$SLOT" == "0" ] && myconf="--disable-multiver" || myconf="--enable-multiver=${SLOT}"
	[ "$1" == "server" ] && ded='-dedicated' || ded=''
	GameDir="${MY_PN}${ded}${GameSLOT}"
	ECONF_SOURCE="${S}" \
	egamesconf ${myconf} \
		--disable-binreloc \
		--docdir "/usr/share/doc/${PF}/${DOCDESTTREE}" \
		--disable-master \
		--enable-main \
		--disable-krawall \
		--enable-sysinstall \
		--disable-useradd \
		--enable-etc \
		--disable-restoreold \
		--disable-games \
		--enable-uninstall="emerge --clean =${CATEGORY}/${PF}" \
		$(use_enable ruby) \
		"${@:2}" || die "egamesconf($1) failed"
	emake armabindir="${GAMES_BINDIR}" || die "emake($1) failed"
}

src_compile() {
	[ "${PN/-live/}" != "${PN}" ] && WANT_AUTOMAKE=1.9 ./bootstrap.sh
	
	# Assume client if they don't want a server
	use opengl || ! use dedicated && build_client=true || build_client=false
	use dedicated && build_server=true || build_server=false

	[ "$SLOT" == "0" ] && GameSLOT="" || GameSLOT="-${SLOT}"
	filter-flags -fno-exceptions
	if ${build_client}; then
		einfo "Building game client"
		aabuild client  --enable-glout --disable-initscripts  --enable-desktop
	fi
	if ${build_server}; then
		einfo "Building dedicated server"
		aabuild server --disable-glout  --enable-initscripts --disable-desktop
	fi
}

src_install() {
	if ${build_client} && ${build_server}; then
		# Setup symlink so both client and server share their common data
		dodir "${GAMES_DATADIR}"
		dosym "${MY_PN}${GameSLOT}" "${GAMES_DATADIR}/${MY_PN}-dedicated${GameSLOT}"
		dodir "${GAMES_SYSCONFDIR}"
		dosym "${MY_PN}${GameSLOT}" "${GAMES_SYSCONFDIR}/${MY_PN}-dedicated${GameSLOT}"
	fi
	if ${build_client}; then
		einfo "Installing game client"
		cd "${WORKDIR}/build-client"
		make DESTDIR="${D}" armabindir="${GAMES_BINDIR}" install || die "make(client) install failed"
		# copy moviepacks/sounds
		cd "${WORKDIR}"
		insinto "${GAMES_DATADIR}/${MY_PN}${GameSLOT}"
		einfo 'Installing moviepack'
		doins -r moviepack || die "copying moviepack"
		einfo 'Installing moviesounds'
		doins -r moviesounds || die "copying moviesounds"
		if use linguas_es && ! use linguas_en; then
			einfo 'Installing Spanish moviesounds'
			doins -r ArmageTRON/moviesounds || die "copying spanish moviesounds"
		fi
		cd "${WORKDIR}/build-client"
	fi
	if ${build_server}; then
		einfo "Installing dedicated server"
		cd "${WORKDIR}/build-server"
		make DESTDIR="${D}" armabindir="${GAMES_BINDIR}" install || die "make(server) install failed"
		einfo 'Adjusting dedicated server configuration'
		dosed "s,^\(user=\).*$,\1${GAMES_USER_DED},; s,^#\(VARDIR=/.*\)$,\\1," "${GAMES_SYSCONFDIR}/${MY_PN}-dedicated${GameSLOT}/rc.config" || ewarn 'adjustments for rc.config FAILED; the defaults may not be suited for your system!'
	fi
	# Ok, so we screwed up on doc installation... so for now, the ebuild does this manually
	dohtml -r "${D}${GAMES_PREFIX}/share/doc/${GameDir}/html/"*
	dodoc "${D}${GAMES_PREFIX}/share/doc/${GameDir}/html/"*.txt
	rm -r "${D}${GAMES_PREFIX}/share/doc"
	rmdir "${D}${GAMES_PREFIX}/share" || true	# Supress potential error
	prepgamesdirs
}
