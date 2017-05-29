# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="the sysadmin's rolling upgrade tool"
HOMEPAGE="https://github.com/voyageur/checkrestart/"
SRC_URI="https://github.com/voyageur/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~x86"
IUSE=""

RDEPEND="
	${PYTHON_DEPS}
	sys-apps/lsb-release
	app-portage/portage-utils
	sys-process/lsof
"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

src_prepare() {
	default
	python_fix_shebang ${PN}
}

src_install() {
	dosbin ${PN}
}
