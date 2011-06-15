# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="A FUSE filesystem providing access to MTP devices."
HOMEPAGE="http://www.adebenham.com/mtpfs/"
SRC_URI="http://www.adebenham.com/debian/${P/-/_}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=sys-fs/fuse-2.2
	>=dev-libs/glib-2.6
	>=media-libs/libmtp-0.3.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}.orig"

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	einstall
	dodoc AUTHORS INSTALL NEWS README ChangeLog
}

pkg_postinst() {
	einfo "To mount your MTP device, issue:"
	einfo "    /usr/bin/mtpfs <mountpoint>"
	einfo
	einfo "To unmount your MTP device, issue:"
	einfo "    /usr/bin/fusermount -u <mountpoint>"

	if use debug; then
		einfo
		einfo "You have enabled debugging output."
		einfo "Please make sure you run mtpfs with the -d flag."
	fi
}
