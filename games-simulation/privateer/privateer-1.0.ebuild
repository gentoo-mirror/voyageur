# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils games

DESCRIPTION="Wing Commander Privateer Remake"
HOMEPAGE="http://priv.solsector.net/"
SRC_URI="mirror://sourceforge/wcuniverse/${PN}${PV}.bz2.run"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="virtual/opengl
	virtual/x11"
DEPEND="${RDEPEND}"

src_unpack() {
	cd ${WORKDIR}
	bash ${DISTDIR}/${PN}${PV}.bz2.run --noexec --keep --target ${P}
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	cp ${FILESDIR}/privscript ./
	sed "s%GAMESDIR=\"[^\"]*\"%GAMESDIR=\"${GAMES_DATADIR}\"%" -i privscript
	newgamesbin privscript privateer || die "couldn't install launcher"
	dodir "${GAMES_DATADIR}"
	cp -r ./ "${D}${GAMES_DATADIR}/${PN}/" || die "data copy failed"
	prepgamesdirs
}
