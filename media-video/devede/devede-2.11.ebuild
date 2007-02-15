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
IUSE="nls doc"

RDEPEND=">=x11-libs/gtk+-2.4
		>=dev-lang/python-2.4
		dev-python/pygtk
		media-video/mplayer
		media-video/dvdauthor
		media-video/vcdimager
		|| ( app-cdr/cdrtools app-cdr/cdrkit )"

DEPEND="${RDEPEND}"

src_install() {
	newbin ${S}/devede.py devede
	if use nls; then
		insinto /usr/share/locale/es/LC_MESSAGES
		newins ${S}/po/es.mo devede.mo
		insinto /usr/share/locale/gl/LC_MESSAGES
		newins ${S}/po/gl.mo devede.mo
		insinto /usr/share/locale/cs_CZ/LC_MESSAGES
		newins ${S}/po/cs_CZ.mo devede.mo
		insinto /usr/share/locale/de_DE/LC_MESSAGES
		newins ${S}/po/de_DE.mo devede.mo
		insinto /usr/share/locale/it/LC_MESSAGES
		newins ${S}/po/it.mo devede.mo
		insinto /usr/share/locale/nb_NO/LC_MESSAGES
		newins ${S}/po/nb_NO.mo devede.mo
		insinto /usr/share/locale/pt_BR/LC_MESSAGES
		newins ${S}/po/pt_BR.mo devede.mo
	fi
	insinto /usr/share/applications
	doins ${S}/${PN}.desktop
	insinto /usr/share/pixmaps
	doins ${S}/${PN}.png
	insinto /usr/share/${PN}
	doins ${S}/${PN}.glade
	insinto /usr/share/${PN}
	doins ${S}/pixmaps/*
	insinto /usr/lib/${PN}
	doins ${S}/${PN}_*.py
	insinto /usr/share/${PN}
	doins ${S}/*.ttf
	if use doc; then
		insinto /usr/share/doc/${P}/html
		dohtml ${S}/docs/*
	fi
}

pkg_postinst() {
	elog "You may change settings in ~/.devede, created after first run."
}

