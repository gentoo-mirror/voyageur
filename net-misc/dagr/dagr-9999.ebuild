# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6} )
inherit git-r3 distutils-r1

DESCRIPTION="a deviantArt image downloader script written in Python."
HOMEPAGE="https://github.com/voyageur/dagr"
EGIT_REPO_URI="https://github.com/voyageur/dagr.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-python/MechanicalSoup[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
