# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6} )
inherit distutils-r1

DESCRIPTION="a deviantArt image downloader script written in Python."
HOMEPAGE="https://github.com/voyageur/dagr"
SRC_URI="https://github.com/voyageur/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/MechanicalSoup[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
