# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

MY_P="letsencrypt-${PV}"

DESCRIPTION="An implementation of the ACME protocol"
HOMEPAGE="https://github.com/letsencrypt/letsencrypt https://letsencrypt.org/"
SRC_URI="https://github.com/letsencrypt/letsencrypt/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

RDEPEND=">=dev-python/cryptography-0.8[${PYTHON_USEDEP}]
	>=dev-python/ndg-httpsclient-0.4[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.15[${PYTHON_USEDEP}]
	dev-python/pyrfc3339[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}/${PN}"

src_prepare() {
	sed -e "s/install_requires.append('mock')/pass/" -i setup.py || die
}

python_test() {
	nosetests -w ${PN} || die
}
