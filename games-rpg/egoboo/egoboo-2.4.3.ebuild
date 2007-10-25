# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $

inherit eutils flag-o-matic toolchain-funcs rpm games

DESCRIPTION="A 3d dungeon crawling adventure in the spirit of NetHack"
HOMEPAGE="http://home.no.net/egoboo/"
SRC_URI="http://home.no.net/egoboo/egosrc243.rar
	http://fedora.kiewel-online.de/linux/updates/7/SRPMS/egoboo-data-${PV}-1.fc7.src.rpm"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="virtual/opengl
        virtual/glu
        media-libs/libsdl
        media-libs/sdl-mixer
        media-libs/sdl-ttf"

DEPEND="${RDEPEND}
	net-libs/enet
	app-arch/rpm2targz"



# Yes upstream put the wrong version in the base dir.
S=${WORKDIR}/egosrc234/

src_unpack() {
	rpm_src_unpack
	cd "${S}"
	cd game
	epatch \
                ${FILESDIR}/egoboo-${PV}-unix.patch || die "epatch failed"
	sed -i "s:/usr/share/egoboo:${GAMES_DATADIR}/${PN}:" egoboo.sh || die "dosed failed"
	sed -i "s:/usr/share/egoboo:${GAMES_DATADIR}/${PN}:" egoboo.sh || die "dosed failed"
	sed -i "s:/usr/libexec:${GAMES_PREFIX}/libexec:" egoboo.sh || die "dosed failed"
}

src_compile(){
	cd ${S}
	cd game
	emake CFLAGS="${CFLAGS} `sdl-config --cflags` -DENET11" \
	ENET_SRC="" ENET_OBJ="" INC="-I. ${SDLCONF_I}"\
	LDFLAGS="`sdl-config --libs` -lSDL_ttf -lSDL_mixer -lGL -lGLU -lenet" \
	|| die "make failed"
}


src_install () {
	cd ${S}
	cd game
	emake ENET_SRC="" ENET_OBJ="" PREFIX=${D}/${GAMES_PREFIX} install || die "install failed"
	cd ..
	cd ..
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r basicdat/ modules/ players/ controls.txt setup.txt\
		|| die "doins failed"
	
	dodoc Changelog.txt "Egoboo 2.4.3 Manual.pdf" Readme.txt
}
