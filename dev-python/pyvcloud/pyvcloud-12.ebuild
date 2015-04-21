# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_2,3_3,3_4} )
inherit distutils-r1 eutils

DESCRIPTION="Python SDK for VMware vCloud"
HOMEPAGE="https://github.com/vmware/pyvcloud"
SRC_URI="https://github.com/vmware/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/iptools-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.4.1[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.13[${PYTHON_USEDEP}]
	>=dev-python/requests-2.4.3[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

# Tests require an active connection and vmware account

src_prepare() {
	epatch "${FILESDIR}"/${P}-requirements.patch
}
