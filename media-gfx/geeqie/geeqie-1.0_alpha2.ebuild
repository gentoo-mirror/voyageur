# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P/_/}"

DESCRIPTION="A lightweight image viewer forked from GQview"
HOMEPAGE="http://geeqie.sourceforge.net/"
SRC_URI="mirror://sourceforge/geeqie/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lcms exif"

S="${WORKDIR}/${MY_P}"

RDEPEND=">=x11-libs/gtk+-2.4.0
	lcms? ( media-libs/lcms )
	exif? ( <media-gfx/exiv2-0.18 )
	virtual/libintl"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

src_compile() {
	econf \
		--disable-dependency-tracking \
		$(use_with lcms) \
		$(use_with exif exiv2) \
		|| die "econf faild"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	# leave README uncompressed because the program reads it
	dodoc AUTHORS ChangeLog TODO
	rm -f "${D}/usr/share/doc/${PF}/COPYING"
}
