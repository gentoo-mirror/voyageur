# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KBAUCOM
inherit perl-module

DESCRIPTION="Animated ASCII Art support for Perl"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ncurses"

RDEPEND="ncurses? ( dev-perl/Curses )"
DEPEND="${RDEPEND}"
