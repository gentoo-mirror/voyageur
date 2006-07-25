# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

DESCRIPTION="biniou is a command-line oriented binary newsreader"
HOMEPAGE="http://binaryniouzrideur.free.fr"
SRC_URI="${HOMEPAGE}/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-lang/python-2.4"
RDEPEND="${DEPEND}
	>=net-news/yydecode-0.2.10
	>=app-arch/par2cmdline-0.4"


src_install() {
	distutils_src_install

	exeinto /usr/bin
	newexe biniou

	dodoc README AUTHORS COPYING CREDITS ChangeLog doc/*
}
