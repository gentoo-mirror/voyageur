# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

S=${WORKDIR}/gnustep-back-${PV}

DESCRIPTION="Cairo back-end component for the GNUstep GUI Library."

HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-${PV}.tar.gz"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="LGPL-2.1"

PROVIDE="virtual/gnustep-back"

IUSE="${IUSE} opengl xim doc glitz"
DEPEND="${GNUSTEP_CORE_DEPEND}
	~gnustep-base/gnustep-gui-${PV}
	opengl? ( virtual/opengl virtual/glu )

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXft
	x11-libs/libXrender

	>=media-libs/freetype-2.1.9
	>=x11-libs/cairo-1.2.0
	gnustep-base/mknfonts
	!virtual/gnustep-back"
RDEPEND="${DEPEND}
	${DEBUG_DEPEND}
	${DOC_RDEPEND}"

egnustep_install_domain "System"

src_compile() {
	egnustep_env

	use opengl && myconf="--enable-glx"
	myconf="$myconf `use_enable xim`"
	myconf="$myconf --enable-server=x11"
	myconf="$myconf --enable-graphics=cairo --with-name=cairo"
	# Seems broken for now
	#myconf="$myconf `use_enable glitz`"
	
	econf $myconf || die "configure failed"

	egnustep_make
	
}

src_install() {
	egnustep_env

	gnustep_src_install

	dosym \
		"$(egnustep_system_root)/Library/Bundles/libgnustep-cairo-012.bundle" \
		"$(egnustep_system_root)/Library/Bundles/libgnustep-cairo.bundle"
}

