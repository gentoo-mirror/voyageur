# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Canonical's on-screen-display notification agent"
HOMEPAGE="https://launchpad.net/notify-osd"

SRC_URI="http://launchpad.net/notify-osd/trunk/${PV}/+download/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64 ~x86"
RDEPEND="!x11-misc/notification-daemon
	sys-apps/dbus
	>=x11-libs/gtk+-2.14
	x11-libs/libnotify
	x11-libs/libwnck"
DEPEND="${RDEPEND}
	dev-util/intltool"

src_install() {
	emake DESTDIR="${D}" install || die "installation failed"
}
