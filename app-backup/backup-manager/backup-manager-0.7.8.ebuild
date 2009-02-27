# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Backup Manager is a command line backup tool for GNU/Linux."
HOMEPAGE="http://www.backup-manager.org/"
SRC_URI="http://www.backup-manager.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc s3"

DEPEND="dev-lang/perl
	sys-devel/gettext
	dbus? ( sys-apps/dbus )
	s3? ( dev-perl/Net-Amazon-S3
		dev-perl/File-Slurp )"

RDEPEND="${DEPEND}
	>=sys-apps/findutils-4.3.0"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	use doc && dodoc doc/user-guide.txt
}

pkg_postinst() {
	elog "After installing,"
	elog "copy ${ROOT%/}/usr/share/backup-manager/backup-manager.conf.tpl to"
	elog "/etc/backup-manager.conf and customize it for your environment."
	elog "You could also set-up your cron for daily or weekly backup."
	ebeep 3
	ewarn "New configuration keys have been defined. Please check the docs for info"
}

