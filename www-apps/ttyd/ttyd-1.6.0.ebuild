# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

MY_PV="$(ver_rs 3 '-')"

DESCRIPTION="ttyd, a simple command-line tool for sharing terminal over the web"
HOMEPAGE="https://github.com/tsl0922/ttyd"
SRC_URI="https://github.com/tsl0922/${PN}/archive/${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/json-c
	net-libs/libwebsockets:="
RDEPEND="!net-misc/termpkg"
BDEPEND="dev-util/cmake"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	dobin ../${P}_build/${PN}
	doman man/*.1
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}
