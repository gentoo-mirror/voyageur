# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=(python{2_7,3_2,3_3,3_4})
inherit distutils-r1 git-r3

DESCRIPTION="an HTML5-powered terminal emulator and SSH client"
HOMEPAGE="https://github.com/liftoff/GateOne"
SRC_URI=""
EGIT_REPO_URI="git://github.com/liftoff/GateOne.git"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="dtach"

DEPEND=">=www-servers/tornado-4.0"
RDEPEND="${DEPEND}
	>=dev-python/html5lib-0.999[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]
	dtach? ( app-misc/dtach )"

src_prepare() {
	# Install system files
	sed -i "s/if os.getuid() == 0/if True/" setup.py || die "sed failed"
}

src_install() {
	distutils-r1_src_install
	# Override gateone path
	sed -i "/^GATEONE=/s/=.*/=${EPREFIX}\/usr\/bin\/gateone/" "${D}"/etc/init.d/gateone || die "sed failed"
}
