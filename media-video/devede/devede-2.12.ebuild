# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="DVD Video Creator"
HOMEPAGE="http://www.rastersoft.com/programas/devede.html"
SRC_URI="http://www.rastersoft.com/descargas/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

LANGS="cs_CZ de_DE es fr gl it nb_NO pt_BR pt_PT"
IUSE="doc nls"
for i in ${LANGS}; do
	IUSE="${IUSE} linguas_${i}"
done

RDEPEND=">=x11-libs/gtk+-2.4
        >=dev-lang/python-2.4
        dev-python/pygtk
        media-video/mplayer
        media-video/dvdauthor
        media-video/vcdimager
        virtual/cdrtools"

DEPEND="${RDEPEND}"

src_install() {
    newbin devede.py devede
    doicon ${PN}.png
    domenu ${PN}.desktop

    insinto /usr/share/${PN}
    doins ${PN}.glade
    insinto /usr/share/${PN}
    doins pixmaps/*
    insinto /usr/lib/${PN}
    doins ${PN}_*.py
    insinto /usr/share/${PN}
    doins *.ttf

    if use doc; then
        insinto /usr/share/doc/${P}/html
        dohtml ${S}/docs/*
    fi

    if use nls; then	
	cd po/
	for n in *.mo; do
	    if use linguas_${n/.mo}; then
		insinto /usr/share/locale/${n/.mo}/LC_MESSAGES
		newins ${n} ${PN}.mo
	    fi
	done
    fi
} 

pkg_postinst() {
	elog "You may change settings in ~/.devede, created after first run."
}
