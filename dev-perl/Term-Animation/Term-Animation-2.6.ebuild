# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit perl-module

DESCRIPTION="Animated ASCII Art support for Perl"
HOMEPAGE="http://search.cpan.org/~kbaucom/Term-Animation/"
SRC_URI="mirror://cpan/authors/id/K/KB/KBAUCOM/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ncurses"

RDEPEND="ncurses? ( dev-perl/Curses )"
DEPEND="${RDEPEND}"
