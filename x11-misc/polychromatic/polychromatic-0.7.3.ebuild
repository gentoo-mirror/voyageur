# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit python-r1 meson xdg

DESCRIPTION="RGB lighting management software"
HOMEPAGE="https://polychromatic.app"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Skipping dev-libs/libappindicator:3 and dev-python/colour
DEPEND="${PYTHON_DEPS}
	>=dev-python/colorama-0.4.4[${PYTHON_USEDEP}]
	dev-python/PyQt5[svg,${PYTHON_USEDEP}]
	dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/python-openrazer[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	dev-qt/qtsvg"
RDEPEND="${DEPEND}"

BDEPEND="dev-lang/sassc
	dev-util/intltool"

src_prepare() {
	default

	# Old library only used for custom effects
	sed -e "/import colour/s/^/#/" -i pylib/fx.py || die
}
