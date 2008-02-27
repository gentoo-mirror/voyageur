# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
WX_GTK_VER="2.8"
inherit wxwidgets

DESCRIPTION="The W3C Web-Browser"
HOMEPAGE="http://www.w3.org/Amaya/"
SRC_URI="http://www.w3.org/Amaya/Distribution/${PN}-fullsrc-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug opengl"

DEPEND="media-libs/imlib
	x11-libs/wxGTK:2.8"
RDEPEND="${DEPEND}"

S=${WORKDIR}/Amaya/LINUX-ELF
ECONF_SOURCE=${WORKDIR}/Amaya

src_compile() {
	mkdir "${S}"
	cd "${S}"

	econf --enable-system-wx \
		$(use_with opengl gl) \
		$(use_with debug) || die "econf failed"
	# Does not seem to like parallel make
	emake -j1|| die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "make install failed"
	rm "${D}"/usr/bin/amaya
	dosym /usr/Amaya/wx/bin/amaya /usr/bin/amaya
}
