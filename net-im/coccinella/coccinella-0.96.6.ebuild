# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NAME=Coccinella
DESCRIPTION="Jabber Client With a Built-in Whiteboard and VoIP (jingle)"
HOMEPAGE="http://www.thecoccinella.org/"
SRC_URI="mirror://sourceforge/coccinella/${NAME}-${PV}Src.tar.gz"

inherit eutils

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/tk-8.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${NAME}-${PV}Src"

src_compile() {
	einfo "Nothing to compile for ${P}."
}

src_install () {
	dodir /opt/coccinella
	cp -R "${S}"/* ${D}/opt/coccinella/
	fperms 0755 /opt/coccinella/Coccinella.tcl
	dosym /opt/coccinella/Coccinella.tcl /opt/bin/coccinella
	dodoc CHANGES README.txt READMEs/*
	
	dosym /opt/coccinella/images/coccinella64.png /usr/share/icons/hicolor/64x64/apps/coccinella.png
	make_desktop_entry "coccinella" "Coccinella IM Client"
}

pkg_postinst() {
	elog "To run coccinella just type \"coccinella\""
}
