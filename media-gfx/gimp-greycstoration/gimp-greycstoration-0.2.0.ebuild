# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P#gimp-}"

DESCRIPTION="GIMP plugin for images restoration using the CImg library"
HOMEPAGE="http://haypocalc.com/wiki/Gimp_Plugin_GREYCstoration"
#SRC_URI="http://www.haypocalc.com/perso/prog/greycstoration/${MY_P}.tar.bz2"
SRC_URI="http://cafarelli.fr/gentoo/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-gfx/gimp-2.2
	>=x11-libs/gtk+-2.6"
DEPEND="${RDEPEND}
	dev-util/intltool
	>=sys-devel/gettext-0.12
	>=dev-util/pkgconfig-0.9"

S="${WORKDIR}/${MY_P}"

src_install() {
	make DESTDIR=${D} install || die "Installation failed"
	dodoc AUTHORS ChangeLog README
}
