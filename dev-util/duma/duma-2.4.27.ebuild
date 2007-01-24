# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator multilib toolchain-funcs

MY_P="${PN}_$(replace_all_version_separators '_')"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="DUMA (Detect Unintended Memory Access) is a memory debugging library."
HOMEPAGE="http://duma.sourceforge.net/"

SRC_URI="mirror://sourceforge/duma/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack(){
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gentoo.patch"
}

src_compile(){
	# filter parallel make, because it generate header and that header needed
	# for next part of compile
	emake -j1 CC=$(tc-getCC) || die "emake failed"
}

src_install(){
	make prefix="${D}"/usr LIB_INSTALL_DIR="${D}/usr/$(get_libdir)" install ||
	die "make install failed"
	insinto /usr/include
	doins duma.h duma_config.h duma_hlp.h dumapp.h noduma.h paging.h print.h \
	sem_inc.h || die " failed install headers"
	dodoc CHANGELOG README 
}
