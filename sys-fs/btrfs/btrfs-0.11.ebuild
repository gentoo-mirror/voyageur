# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod eutils

MODULE_NAMES="btrfs(btrfs)"
BUILD_TARGETS="all"

DESCRIPTION="A Checksumming Copy on Write Filesystem"
HOMEPAGE="http://oss.oracle.com/projects/btrfs/"
SRC_URI="http://oss.oracle.com/projects/btrfs/dist/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/btrfs-0.10-get_current.patch
}

src_compile() {
	BUILD_PARAMS="KERNELDIR=${KV_OUT_DIR}" linux-mod_src_compile
}

src_install() {
	linux-mod_src_install

	dodoc INSTALL TODO
}
