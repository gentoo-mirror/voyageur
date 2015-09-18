# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit distutils-r1

DESCRIPTION="a deviantArt image downloader script written in Python."
HOMEPAGE="https://github.com/voyageur/dagr"
SRC_URI="https://github.com/voyageur/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/robobrowser[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
