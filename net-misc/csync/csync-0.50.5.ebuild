# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit cmake-utils

DESCRIPTION="a client only bidirectional file synchronizer"
HOMEPAGE="http://www.csync.org/
	https://build.opensuse.org/package/files?package=csync&project=isv:ownCloud:devel"
SRC_URI="https://api.opensuse.org/public/source/isv:ownCloud:devel/${PN}/${P}.tar.bz2 "

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="log +owncloud samba sftp"

DEPEND=">=dev-db/sqlite-3.4:3
	>=dev-libs/iniparser-3.1
	log? ( >=dev-libs/log4c-1.2 )
	owncloud? ( net-libs/neon )
	samba? ( >=net-fs/samba-3.5[smbclient] )
	sftp? ( >=net-libs/libssh-0.5 )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README )
src_prepare() {
	# Hardcoded path for docs
	sed -e "s#doc/csync#doc/${PF}#" -i doc/CMakeLists.txt || die "doc sed failed"
}

src_configure() {
	mycmakeargs=(
		-DSYSCONF_INSTALL_DIR=/etc
		-DDOCDIR=/usr/share/doc/${PF}
		$(cmake-utils_use_with log LOG4C)
	)

	cmake-utils_src_configure
}
