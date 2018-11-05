# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
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
	dev-python/pillow[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	dtach? ( app-misc/dtach )"

src_prepare() {
	# Install system files
	sed -i "s/if os.getuid() == 0/if True/" setup.py || die

	default
}

src_install() {
	distutils-r1_src_install
	# Override gateone path
	sed -i "/^GATEONE=/s/=.*/=${EPREFIX}\/usr\/bin\/gateone/" "${D}"/etc/init.d/gateone || die "sed failed"
}
