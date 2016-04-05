# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
PYTHON_REQ_USE="tk"

inherit git-r3 distutils-r1

MY_PN="PySolFC"
DESCRIPTION="An exciting collection of more than 1000 solitaire card games"
HOMEPAGE="https://github.com/shlomif/PySolFC"
EGIT_REPO_URI="https://github.com/voyageur/PySolFC.git"
EGIT_BRANCH="2to3"
SRC_URI=""

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
