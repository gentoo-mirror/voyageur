# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit flag-o-matic

DESCRIPTION="3-Dimensional File System Visualizer"
HOMEPAGE="https://bitbucket.org/legoscia/fsv/overview
	http://fsv.sourceforge.net/"
SRC_URI="https://cafarelli.fr/gentoo/${P/_}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.12:2
	>=x11-libs/gtkglarea-1.99:2"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/_}
DOCS=( AUTHORS ChangeLog NOTES TODO )

src_configure() {
	append-libs -lm
	default
}
