# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )

inherit desktop git-r3 python-single-r1 xdg wrapper

DESCRIPTION="A side scrolling shooter game starring a steamboat on the sea"
HOMEPAGE="https://github.com/voyageur/funnyboat"
EGIT_REPO_URI="https://github.com/voyageur/funnyboat"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS=""
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		>=dev-python/pygame-1.6.2[${PYTHON_USEDEP}]
	')"

src_install() {
	python_moduleinto funnyboat
	python_domodule data *.py
	python_newscript main.py funnyboat

	dodoc *.txt

	make_wrapper ${PN} "${EPYTHON} $(python_get_sitedir)/${PN}/main.py $@"

	newicon -s 32 data/kuvake.png ${PN}.png
	make_desktop_entry ${PN} "Trip on the Funny Boat"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
