# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="nls"

MY_P="${P}gtk2-0.1"
DESCRIPTION="3-Dimensional File System Visualizer"
HOMEPAGE="http://www.nslabs.jp/fsv-gtk2.rhtml http://fsv.sourceforge.net/"
SRC_URI="http://www.nslabs.jp/archives/${MY_P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND=">=x11-libs/gtk+-2.12
	>=x11-libs/gtkglarea-1.99
	>=gnome-base/libgnomeui-2.22"

S=${WORKDIR}/${MY_P}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed"
	dodoc AUTHORS ChangeLog NOTES TODO
}
