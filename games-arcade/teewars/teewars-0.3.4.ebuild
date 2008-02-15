# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils games

DESCRIPTION="Crossover between Quake and Worms."
HOMEPAGE="http://www.teewars.com"
SRC_URI="http://www.${PN}.com/files/${P}-src.tar.gz
	http://www.teewars.com/files/bam.zip
	racemod? ( http://lan-corps.no-ip.org/${PN}/packs/race_mod.rar
		http://oerngott.ugms.se/${PN}/race_mod.rar )"

# see license.txt
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug dedicated +racemod server"

RDEPEND="!dedicated? (
		media-libs/alsa-lib
		media-libs/mesa
		x11-libs/libX11
		)
	!games-action/teewars-bin"
DEPEND="${RDEPEND}
	app-arch/zip"

SB=${WORKDIR}/bam
S=${WORKDIR}/${P}-src

dir=${GAMES_DATADIR}/${PN}

pkg_setup() {
	games_pkg_setup

	if use server && use dedicated; then
		einfo "Can't build with \"server\" and \"dedicated\" USE flags."
		einfo "Disable one of them and restart the merge"
		die "\"server\" and \"dedicated\" USE flags enabled."
	fi
}

src_unpack() {
	unpack ${A}

	# fix bam default optimisation
	cd "${SB}"
	sed -i \
		-e "s|0 then f = f .. \"-O2 \"|0 then f = f .. \" \"|" \
		src/base.bam || die "sed base.bam failed"

	cd "${S}"
	sed -i \
		-e "s:data/:${dir}/data/:g" \
		datasrc/teewars.ds \
		src/engine/client/ec_gfx.c \
		src/editor/editor.cpp \
		src/game/client/gc_skin.cpp \
		src/engine/e_map.c \
		src/engine/server/es_server.c \
		src/engine/client/ec_client.c || die "sed-ing default datadir location failed"

	if use racemod; then
		mv ../"guide to moving.txt" ${S}/guide_to_moving.txt || die "mv guide to moving.txt failed"
		mv ../"race mod.txt" ${S}/race_mod.txt || die "mv race mod.txt failed"
		mv ../*.map ${S}/data/maps/ || die "mv racemod maps failed"
	fi
}

src_compile() {
	cd ${SB}
	./make_unix.sh || die "make_unix.sh failed"

	cd ${S}

	# set optimisation
	sed -i \
		-e "s|flags = \"-Wall\"|flags = \"${CXXFLAGS}\"|" \
		-e "s|linker.flags = \"\"|linker.flags = \"${LDFLAGS}\"|" \
		default.bam || die "sed failed"

	if use debug && use server; then
		../bam/src/bam -v debug || die "bam failed"
	elif use debug && use dedicated; then
		../bam/src/bam -v server_debug || die "bam failed"
	elif use !debug && use dedicated; then
		../bam/src/bam -v server_release || die "bam failed"
	else
		../bam/src/bam -v release || die "bam failed"
	fi
}

src_install() {
	if use dedicated; then
		insinto "${dir}"/data/maps
		doins data/maps/* || die "doins failed"
	else
		insinto "${dir}"
		doins -r data || die "doins failed"
	fi

	if use debug && use server; then
		dogamesbin ${PN}_srv_d || die "dogamesbin failed"
		dogamesbin ${PN}_d || die "dogamesbin failed"
		make_desktop_entry ${PN} "Teewars"
	elif use !debug && use server; then
		dogamesbin ${PN}_srv || die "dogamesbin failed"
		dogamesbin ${PN} || die "dogamesbin failed"
		make_desktop_entry ${PN} "Teewars"
	elif use debug && use dedicated; then
		dogamesbin ${PN}_srv_d || die "dogamesbin failed"
	elif use !debug && use dedicated; then
		dogamesbin ${PN}_srv || die "dogamesbin failed"
	else
		dogamesbin ${PN} || die "dogamesbin failed"
		make_desktop_entry ${PN} "Teewars"
	fi

	dodoc *.txt

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if use server || use dedicated; then
		einfo "For more information about server setup read:"
		einfo "http://www.teewars.com/?page=docs"
	fi

	if use racemod && use server; then
		einfo "Read about server setup for racemod in race_mod.txt"
	fi
}
