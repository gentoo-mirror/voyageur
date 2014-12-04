# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_3,3_4} )
inherit distutils-r1

DESCRIPTION="A python library for browsing the web without a standalone web browser"
HOMEPAGE="https://github.com/jmcarp/robobrowser"
SRC_URI="https://github.com/jmcarp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/pip[${PYTHON_USEDEP}]"

src_prepare() {
	sed -e "s/find_packages(/\0exclude=('tests',)/" \
		-i setup.py || die sed failed
}
