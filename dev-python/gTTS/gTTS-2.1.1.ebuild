# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="interface with Google Translate's text-to-speech API"
HOMEPAGE="https://github.com/pndurette/gTTS"
SRC_URI="https://github.com/pndurette/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	>=dev-python/gTTS-token-1.1.3[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
# No 3.9 yet
#DEPEND="
#	test? (
#		dev-python/testfixtures[${PYTHON_USEDEP}]
#	)
#"

distutils_enable_tests pytest

src_prepare() {
	default
	sed -e "/twine/d" -i setup.cfg || die
}
