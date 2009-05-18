# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P/_/}"

DESCRIPTION="A lightweight GTK image viewer forked from GQview"
HOMEPAGE="http://geeqie.sourceforge.net/"
SRC_URI="mirror://sourceforge/geeqie/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="exif lcms lirc xmp"

S="${WORKDIR}/${MY_P}"

RDEPEND=">=x11-libs/gtk+-2.4.0
	xmp? ( media-gfx/exiv2[xmp] )
	!xmp? ( exif? ( media-gfx/exiv2 ) )
	lcms? ( media-libs/lcms )
	lirc? ( app-misc/lirc )
	virtual/libintl"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

src_compile() {
	econf \
		--disable-dependency-tracking \
		$(use_enable exif exiv2) \
		$(use_enable lcms) \
		$(use_enable lirc) \
		|| die "econf faild"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -f "${D}/usr/share/doc/${MY_P}/COPYING"
}
