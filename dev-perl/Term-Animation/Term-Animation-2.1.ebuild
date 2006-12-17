# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

DESCRIPTION="Animated ASCII Art support for Perl"
HOMEPAGE="http://search.cpan.org/~kbaucom/Term-Animation/"
SRC_URI="http://search.cpan.org/CPAN/authors/id/K/KB/KBAUCOM/${P}.tar.gz"

LICENSE="Unknown"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ncurses"

RDEPEND="ncurses? (dev-perl/Curses)"
