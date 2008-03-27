# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="Crossover between Quake and Worms."
HOMEPAGE="http://www.teeworlds.com"
SRC_URI="http://www.${PN}.com/files/${P}-src.tar.gz
	http://www.${PN}.com/files/bam.zip"

# see license.txt
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug dedicated server"
#IUSE="alsa oss"

RDEPEND="!dedicated? (
		media-libs/alsa-lib
		media-libs/mesa
		x11-libs/libX11
		)"
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
#	sed -i \
#		-e "s|-O2|${CXXFLAGS}|" \
#		-e "s|s.linker.flags = \"\"|s.linker.flags = \"${LDFLAGS}\"|" \
#		src/base.bam || die "sed base.bam failed"

	cd "${S}"
	# the data-dir needs to be patched in some files
	to_patch=$(grep -Rl '"data\/' *)
	sed -i \
		-e "s:data/:${dir}/data/:g" \
		$to_patch \
		|| die "sed-ing default datadir location failed"

#	if use alsa; then
#		sed -i \
#			-e "s|oss|alsa|" \
#			default.bam || die "sed failed"
#	elif use oss; then
#		sed -i \
#			-e "s|alsa|oss|" \
#			default.bam || die "sed failed"
#	fi
}

src_compile() {
	cd ${SB}
	./make_unix.sh \
		${LDFLAGS} \
		-Wp,${CXXFLAGS} \
		|| die "make_unix.sh failed"

	cd ${S}

	# set optimisation
	sed -i \
		-e "s|cc.flags = \"-Wall -pedantic-errors\"|cc.flags = \"${CXXFLAGS}\"|" \
		-e "s|linker.flags = \"\"|linker.flags = \"${LDFLAGS}\"|" \
		-e "s|-Wall -fstack-protector -fstack-protector-all -fno-exceptions|${CXXFLAGS}|" \
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
		make_desktop_entry ${PN} "Teeworlds"
	elif use !debug && use server; then
		dogamesbin ${PN}_srv || die "dogamesbin failed"
		dogamesbin ${PN} || die "dogamesbin failed"
		make_desktop_entry ${PN} "Teeworlds"
	elif use debug && use dedicated; then
		dogamesbin ${PN}_srv_d || die "dogamesbin failed"
	elif use !debug && use dedicated; then
		dogamesbin ${PN}_srv || die "dogamesbin failed"
	else
		dogamesbin ${PN} || die "dogamesbin failed"
		make_desktop_entry ${PN} "Teeworlds"
	fi

	dodoc *.txt

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if use server || use dedicated; then
		einfo "For more information about server setup read:"
		einfo "http://www.teeworlds.com/?page=docs"
	fi
}
