# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Helper tools are still python2 only
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

MY_P="PySolFC-${PV}"
DESCRIPTION="An exciting collection of more than 1000 solitaire card games"
HOMEPAGE="http://pysolfc.sourceforge.net"
SRC_URI="mirror://sourceforge/pysolfc/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+sound"

DEPEND=""
RDEPEND="${RDEPEND}
	dev-python/pillow[tk,${PYTHON_USEDEP}]
	sound? ( dev-python/pygame[${PYTHON_USEDEP}] )"

DOCS=( README.md AUTHORS docs/README docs/README.SOURCE )
HTML_DOCS=( docs/all_games.html )

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i \
		-e "/pysol.desktop/d" \
		-e "s:share/icons:share/pixmaps:" \
		setup.py || die

	distutils-r1_src_prepare
}

python_compile_all() {
	# Not called from distutils
	emake all_games_html mo rules
}

python_install_all() {
	make_desktop_entry pysol.py "PySol Fan Club Edition" pysol02

	doman docs/*.6

	distutils-r1_python_install_all
}
