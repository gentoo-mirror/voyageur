# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit flag-o-matic

DESCRIPTION="3-Dimensional File System Visualizer"
HOMEPAGE="https://bitbucket.org/legoscia/fsv/overview
   http://fsv.sourceforge.net/"
SRC_URI="https://bitbucket.org/legoscia/fsv/downloads/${P/_}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.12:2
	>=x11-libs/gtkglarea-1.99:2
	>=gnome-base/libgnomeui-2.22"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/_}
DOCS=( AUTHORS ChangeLog NOTES TODO )

src_configure() {
	append-libs -lm
	econf
}
