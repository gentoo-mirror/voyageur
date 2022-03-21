# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Google Translate token validation"
HOMEPAGE="https://github.com/Boudewijn26/gTTS-token"
SRC_URI="https://github.com/Boudewijn26/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"
