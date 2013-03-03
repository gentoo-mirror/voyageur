# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/aqemu/aqemu-0.8.2-r2.ebuild,v 1.3 2012/05/04 17:57:16 scarabeus Exp $

EAPI=4

inherit cmake-utils git-2

DESCRIPTION="Graphical interface for QEMU and KVM emulators. Using Qt4."
HOMEPAGE="http://sourceforge.net/projects/aqemu"
SRC_URI=""
EGIT_REPO_URI="git://aqemu.git.sourceforge.net/gitroot/aqemu/aqemu"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+vnc"

DEPEND="${RDEPEND}"
RDEPEND="|| ( app-emulation/qemu-kvm >=app-emulation/qemu-0.9.0 )
	vnc? ( net-libs/libvncserver )
	dev-qt/qtgui:4
	dev-qt/qttest:4
	dev-qt/qtxmlpatterns:4"

DOCS="AUTHORS CHANGELOG README TODO"
PATCHES=()

src_configure() {
	local mycmakeargs=(
		"-DMAN_PAGE_COMPRESSOR="
		"-DWITHOUT_EMBEDDED_DISPLAY=$(use vnc && echo "OFF" || echo "ON")"
	)

	cmake-utils_src_configure
}
