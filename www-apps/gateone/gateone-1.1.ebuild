# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit distutils

DESCRIPTION="an HTML5-powered terminal emulator and SSH client"
HOMEPAGE="https://github.com/liftoff/GateOne"
SRC_URI="https://github.com/downloads/liftoff/GateOne/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dtach kerberos pam"

DEPEND=">=www-servers/tornado-2.2"
RDEPEND="${DEPEND}
	virtual/python-imaging
	dtach? ( app-misc/dtach )
	kerberos? ( dev-python/pykerberos )
	pam? ( dev-python/python-pam )"

S="${WORKDIR}/GateOne"
