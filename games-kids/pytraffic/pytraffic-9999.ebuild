# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit desktop distutils-r1 git-r3 xdg

DESCRIPTION="Python version of the board game Rush Hour"
HOMEPAGE="https://github.com/voyageur/pytraffic"
EGIT_REPO_URI="https://github.com/voyageur/pytraffic.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/libsdl:0[sound]
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}
	dev-python/pygtk"

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed \
		-e "s#@GAMES_DATADIR@#/usr/share/${PN}#" \
		"${FILESDIR}"/${PN} > "${T}"/${PN} || die
}

python_install() {
	# install modules manually, build system broken
	python_moduleinto ${PN}
	python_domodule "${BUILD_DIR}"/lib/.

	# allow to import the stuff as module
	touch "${D}$(python_get_sitedir)"/${PN}/__init__.py || die

	# install python wrapper script to handle multiple ABI properly
	python_scriptinto /usr/bin
	python_doscript "${T}"/${PN}
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/${PN}
	doins -r doc config.db extra_themes icons libglade music sound_test themes ttraffic.levels

	doicon -s 64 icons/64x64/${PN}.png
	make_desktop_entry ${PN} PyTraffic
}
