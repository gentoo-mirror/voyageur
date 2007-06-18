# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils

MY_P="fortunes-fr-${PV}"
DESCRIPTION="set of fortunes in french"
DESCRIPTION_FR="Des fortunes (citations) en francais"

HOMEPAGE="http://www.fortunes-fr.org/"
SRC_URI="http://zugaina.free.fr/distfiles/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~mips amd64"
S="${WORKDIR}/${MY_P}"

DEPEND="games-misc/fortune-mod"

src_unpack() {
	unpack ${A}
}

src_compile() {
	econf --with-fortunesdir=/usr/share/fortune/fr/ || die "Configure failed"
	emake || die "Compile failed"
}

src_install() {
    make DESTDIR=${D} install || die "Install failed"
}

pkg_postinst() {
    ewarn
    ewarn "If you want to add a fortune when you run bash : "
    ewarn "add \"fortune /usr/share/fortune/fr/\" "
    ewarn "to the end of ~.bashrc"
    ewarn
    sleep 8
}
