# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

OPENRAZER=openrazer-${PV}
DESCRIPTION="OpenRazer Python library"
HOMEPAGE="https://openrazer.github.io/"
SRC_URI="https://github.com/openrazer/openrazer/archive/refs/tags/v${PV}.tar.gz -> ${OPENRAZER}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-python/numpy[$PYTHON_USEDEP]"
RDEPEND="${DEPEND}
	app-misc/openrazer-daemon"

S=${WORKDIR}/${OPENRAZER}/pylib

python_test() {
	for test in tests/integration_tests/test_*.py
	do
		"${EPYTHON}" -dv ${test} || die
	done
}
