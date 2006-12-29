# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

BASE_URI="http://sycraft.org/content/audio"
DOOM1_SRC="Sycraft-D1-high-full.exe"
DOOM2_SRC="Sycraft-D2-high-full.exe"
HERETIC_SRC="hereticsoundtrackhq.zip"
HEXEN_SRC="hexensoundtrackhq.zip"
TNT_SRC="Sycraft-TNT-high-full.exe"

DESCRIPTION="Enhanced OGG music from Sycraft.org for Vavoom"
HOMEPAGE="http://www.sycraft.org"
# This is ugly
SRC_URI="doom1? ( ${BASE_URI}/doom/${DOOM1_SRC} )
	doom2? ( ${BASE_URI}/doom/${DOOM2_SRC} )
	heretic? ( ${BASE_URI}/heretic/${HERETIC_SRC} )
	hexen? ( ${BASE_URI}/hexen/${HEXEN_SRC} )
	tnt? ( ${BASE_URI}/doom/${TNT_SRC} )
	!doom1? ( !doom2? ( !heretic? ( !hexen? ( !tnt? (
		${BASE_URI}/doom/${DOOM1_SRC}
		${BASE_URI}/doom/${DOOM2_SRC}
		${BASE_URI}/heretic/${HERETIC_SRC}
		${BASE_URI}/hexen/${HEXEN_SRC}
		${BASE_URI}/doom/${TNT_SRC} ) ) ) ) )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doom1 doom2 heretic hexen tnt"

RDEPEND="games-fps/vavoom"
DEPEND="app-arch/p7zip
	app-arch/unzip"

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

src_unpack() {
	# Do a lot of work 'cause the files are packaged
	# in a not-so-very-friendly way :(

	local f newname pak_file src_file u

	for u in ${IUSE} ; do
		if use "${u}" || use_none ; then
			case "${u}" in
				doom1|doom2|tnt) # Packed in a NSIS self-extracting exe
					case ${u} in
						doom1)
							src_file=${DOOM1_SRC}
							pak_file="d1music.pk3"
							;;
						doom2)
							src_file=${DOOM2_SRC}
							pak_file="d2music.pk3"
							;;
						tnt)
							src_file=${TNT_SRC}
							pak_file="tntmusic.pk3"
							;;
					esac

				# Cannot use unpack - are not .zip files.
				# 7z creates the subdirectory.
				7z e -y -o${u} "${DISTDIR}/${src_file}" \
					|| die "7z ${src_file} failed"
				cd "${WORKDIR}/${u}" || die

				# Remove weird double quotes from filenames
				for f in $(find -name '*\"*' -print) ; do
					newname=$(echo "$f" | sed -e 's/\"//g')
					mv "${f}" "${newname}" || die "mv ${f} ${newname} failed"
				done

				# Cannot use unpack - are not .zip files
				unzip -qo "${pak_file}" \
					|| die "unzip ${pak_file} failed"
				mv Data/j*/Music/*.ogg . || die "mv *.ogg failed"
				cd "${WORKDIR}"
				;;

			heretic|hexen) # Packed in ZIP file
				case "${u}" in
					heretic)
						src_file=${HERETIC_SRC}
						;;
					hexen)
						src_file=${HEXEN_SRC}
						;;
				esac
				mkdir "${u}"
				cd "${WORKDIR}/${u}" || die
				unpack "${src_file}"
				unpack ./musichq.zip
				mv Data/j*/Music/*.ogg . || die "mv *.ogg failed"
				cd "${WORKDIR}"
				;;
			esac
		fi
	done

}

src_install() {
	local u

	for u in ${IUSE} ; do
		if use "${u}" || use_none ; then
			insinto "${GAMES_DATADIR}/vavoom/basev/${u}/music"
			doins "${u}"/*.ogg || die "doins *.ogg failed"

			docinto "${u}"
			dodoc "${u}"/*.txt || die

			case "${u}" in
				doom1)
					cd "${D}/${GAMES_DATADIR}/vavoom/basev/${u}/music" || die
					ln -sfn d_e1m8.ogg d_e3m4.ogg || die
					cd "${WORKDIR}"
					;;
				doom2)
					cd "${D}/${GAMES_DATADIR}/vavoom/basev/${u}/music" || die
					ln -sfn d_stalks.ogg d_stlks2.ogg || die
					ln -sfn d_the_da.ogg d_theda2.ogg || die
					ln -sfn d_doom.ogg d_doom2.ogg || die
					ln -sfn d_ddtblu.ogg d_ddtbl2.ogg || die
					ln -sfn d_dead.ogg d_dead2.ogg || die
					ln -sfn d_stalks.ogg d_stlks3.ogg || die
					ln -sfn d_shawn.ogg d_shawn2.ogg || die
					ln -sfn d_countd.ogg d_count2.ogg || die
					ln -sfn d_ddtblu.ogg d_ddtbl3.ogg || die
					ln -sfn d_the_da.ogg d_theda3.ogg || die
					ln -sfn d_messag.ogg d_messg2.ogg || die
					ln -sfn d_romero.ogg d_romer2.ogg || die
					ln -sfn d_shawn.ogg d_shawn3.ogg || die
					cd "${WORKDIR}"
					;;
			esac
		fi
	done

	prepgamesdirs
}
