# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

MY_PV=${PV/./}
DOOM_PV="${MY_PV}-1"
HERETIC_PV="${MY_PV}"
HEXEN_PV="${MY_PV}-1"
STRIFE_PV="${MY_PV}"

DESCRIPTION="3D models of Doom/Heretic/Hexen/Strife for Vavoom"
HOMEPAGE="http://www.vavoom-engine.com"
# This is ugly
SRC_URI="doom? ( mirror://sourceforge/vavoom/vmdl_doom_${DOOM_PV}.zip )
	heretic? ( mirror://sourceforge/vavoom/vmdl_heretic_${HERETIC_PV}.zip )
	hexen? ( mirror://sourceforge/vavoom/vmdl_hexen_${HEXEN_PV}.zip )
	strife? ( mirror://sourceforge/vavoom/vmdl_strife_${STRIFE_PV}.zip )
	!doom? ( !heretic? ( !hexen? ( !strife? (
		mirror://sourceforge/vavoom/vmdl_doom_${DOOM_PV}.zip
		mirror://sourceforge/vavoom/vmdl_heretic_${HERETIC_PV}.zip
		mirror://sourceforge/vavoom/vmdl_hexen_${HEXEN_PV}.zip
		mirror://sourceforge/vavoom/vmdl_strife_${STRIFE_PV}.zip ) ) ) )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doom heretic hexen strife"

RDEPEND="games-fps/vavoom"
DEPEND="app-arch/unzip"

S=${WORKDIR}

use_none() {
	# Returns true if no USE flags have been chosen
	local u
	for u in ${IUSE} ; do
		if use "${u}" ; then
			# A USE flag has been chosen
			return 1
		fi
	done
	return 0
}

src_install() {
	# Install models into vavoom base dir
	insinto "${GAMES_DATADIR}/vavoom"
	doins -r basev || die "doins basev failed"

	# Move documentation into proper location
	local u
	for u in ${IUSE} ; do
		if use "${u}" || use_none ; then
			docinto "${u}"
			dodoc "basev/${u}/models"/*.txt || die "dodoc ${u} failed"
			rm -f "${D}/${GAMES_DATADIR}/vavoom/basev/${u}/models"/*.txt
		fi
	done

	prepgamesdirs
}
