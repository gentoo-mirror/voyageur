# Copyright 2005 Michael Pyne <michael.pyne@kdemail.net>
# Distribute however you'd like.

MY_P=${P/-/_}
DESCRIPTION="ASCII Aquarium - Swimming fishes! :-)"
HOMEPAGE="http://www.robobunny.com/projects/asciiquarium/"
SRC_URI="http://www.robobunny.com/projects/asciiquarium/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# This may work with earlier Perl versions, but I don't know.  If you'd like
# to try, be my guest, just go ahead and decrement the version below.
# Most of the depends are based from the kdelibs-3.4 ebuild, the ones
# needing USE flags weren't included.
RDEPEND=">=dev-lang/perl-5.6
         dev-perl/Curses
		 dev-perl/Term-Animation"

RESTRICT="nostrip"

S="${WORKDIR}/${MY_P}"

src_install()
{
	dodoc README CHANGES MANIFEST gpl.txt
	into /usr
	dobin asciiquarium
}
