# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/murrine-themes/murrine-themes-0.90.0.ebuild,v 1.1 2009/05/21 20:09:00 nirbheek Exp $

EAPI="2"

DESCRIPTION="Themes for the Murrine GTK+2 Cairo Engine"
HOMEPAGE="http://www.cimitan.com/murrine/"

URI_PREFIX="http://www.cimitan.com/murrine/files"
SRC_URI="${URI_PREFIX}/MurrineThemePack.tar.bz2
		 ${URI_PREFIX}/MurrinaBlu-0.32.tar.gz
		 ${URI_PREFIX}/MurrinaGilouche.tar.bz2
		 ${URI_PREFIX}/MurrinaCream.tar.gz
		 ${URI_PREFIX}/MurrinaVerdeOlivo.tar.bz2
		 ${URI_PREFIX}/MurrinaCandido.tar.gz
		 ${URI_PREFIX}/MurrinaAquaIsh.tar.bz2
		 ${URI_PREFIX}/MurrinaChrome.tar.gz
		 ${URI_PREFIX}/MurrinaFancyCandy.tar.bz2
		 ${URI_PREFIX}/MurrinaLoveGray.tar.bz2
		 ${URI_PREFIX}/MurrineRounded.tar.bz2
		 ${URI_PREFIX}/MurrinaTango.tar.bz2
		 ${URI_PREFIX}/MurrinaBlue.tar.bz2
		 ${URI_PREFIX}/Murrine-Light.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
# Blocker is due to package getting split out
DEPEND="!!<x11-themes/gtk-engines-murrine-0.90.3-r1"

src_install() {
	dodir /usr/share/themes
	insinto /usr/share/themes
	doins -r "${WORKDIR}"/Murrin* || die "Installing themes failed!"
}
