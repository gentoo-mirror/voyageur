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
	>=x11-libs/cairo-1.2.0"

RDEPEND="${DEPEND}
	${DEBUG_DEPEND}
	${DOC_RDEPEND}
	media-fonts/dejavu"

egnustep_install_domain "System"

src_unpack() {
	unpack ${A}
	cd ${S}

	# DejaVu font is successor of Bitstream Vera
	sed -i -e "s:BitstreamVeraSans-Roman:DejaVuSans:g" \
		-e "s:BitstreamVeraSansMono-Roman:DejaVuSansMono:g" \
		-e "s:BitstreamVeraSans-Bold:DejaVuSans-Bold:g" \
		"${S}/Source/art/ftfont.m"
}

src_compile() {
	egnustep_env

	use opengl && myconf="--enable-glx"
	myconf="$myconf `use_enable xim`"
	myconf="$myconf --enable-server=x11"
	myconf="$myconf --enable-graphics=cairo --with-name=cairo"
	myconf="$myconf `use_enable glitz`"
	
	econf $myconf || die "configure failed"

	egnustep_make
}

src_install() {
	egnustep_env

	gnustep_src_install
	cd ${S}
	mkdir -p "${D}/$(egnustep_system_root)/Library/Fonts"
	cp -pPR Fonts/Helvetica.nfont "${D}/$(egnustep_system_root)/Library/Fonts"
	rm -rf "${D}/$(egnustep_system_root)/var"

	dosym \
		"$(egnustep_system_root)/Library/Bundles/libgnustep-cairo-012.bundle" \
		"$(egnustep_system_root)/Library/Bundles/libgnustep-cairo.bundle"
}

