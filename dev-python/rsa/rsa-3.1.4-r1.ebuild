# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/rsa/rsa-3.1.4.ebuild,v 1.1 2014/05/09 05:55:20 patrick Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )
inherit distutils-r1

DESCRIPTION="Pure-Python RSA implementation"
HOMEPAGE="http://stuvel.eu/rsa http://pypi.python.org/pypi/rsa"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

RDEPEND=">=dev-python/pyasn1-0.0.13
	>=dev-python/setuptools-0.6.10
	test? ( dev-python/nose 
	  dev-python/unittest2 )"
DEPEND="${RDEPEND}"

python_test() {
   nosetests || die "Tests fail with ${EPYTHON}"
}
