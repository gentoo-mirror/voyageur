# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils webapp

# Grab from http://repository.rainloop.net/v2/core.stable.json
TAG="f6a947c1a9edf971d7e3ba80fb6723b7"

DESCRIPTION="Simple, modern and fast web-based email client"
HOMEPAGE="http://www.rainloop.net"
SRC_URI="http://repository.rainloop.net/v2/webmail/${PV%.*}/${P}-${TAG}.zip"
LICENSE="AGPL-3"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php[curl,iconv,json,ssl,xml]
	virtual/httpd-php"

S=${WORKDIR}

src_prepare() {
	epatch_user
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned -R "${MY_HTDOCSDIR}"/data

	webapp_src_install
}
