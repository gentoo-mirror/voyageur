# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib

DESCRIPTION="Download and decrypt adobe encrypted (acsm) pdf and epub files"
HOMEPAGE="https://forge.soutade.fr/soutade/libgourou/"
UPDFPARSER="6060d123441a06df699eb275ae5ffdd50409b8f3"
SRC_URI="https://forge.soutade.fr/soutade/libgourou/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://forge.soutade.fr/soutade/uPDFParser/archive/${UPDFPARSER}.tar.gz -> uPDFParser-${UPDFPARSER}.tar.gz"
S=${WORKDIR}/lib${PN}

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/openssl:=
	dev-libs/pugixml
	dev-libs/libzip:=
	net-misc/curl:="
RDEPEND="${DEPEND}"

DOCS=( README.md )
PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_prepare() {
	mkdir lib obj || die
	mv "${WORKDIR}"/updfparser lib || die
	default
}

src_compile() {
	pushd lib/updfparser &> /dev/null || die
	emake BUILD_STATIC=1 BUILD_SHARED=0
	popd &> /dev/null || die

	emake
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr LIBDIR=/$(get_abi_LIBDIR) \
		install install_headers
	einstalldocs
}
