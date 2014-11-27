# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )
inherit distutils-r1

DESCRIPTION="A low-level interface to a growing number of Amazon Web Services"
HOMEPAGE="https://github.com/boto/botocore"
SRC_URI="https://github.com/boto/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/jmespath[${PYTHON_USEDEP}]
	dev-python/python-dateutil:0[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}] )"

src_prepare() {
	# unbundle requests https://github.com/boto/botocore/issues/266
	rm -Rf botocore/vendored || die "rm failed"
	grep -rl 'botocore.vendored' | xargs \
		sed -i -e "/import requests/s/from botocore.vendored //" \
		-e "/^from/s/botocore.vendored.//" \
		-e "s/'botocore.vendored./'/" \
		|| die "sed failed"
}

python_test() {
	# Only run unit tests
	nosetests tests/unit || die "Tests fail with ${EPYTHON}"
}
