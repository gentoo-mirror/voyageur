# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 cmake-utils

DESCRIPTION="SteelSeries Sensei Raw configuration tool"
HOMEPAGE="https://github.com/pjanouch/sensei-raw-ctl"
EGIT_REPO_URI="https://github.com/pjanouch/sensei-raw-ctl.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="gtk"

RDEPEND="virtual/libusb:1
	gtk? ( x11-libs/gtk+:3 )"
DEPEND="${RDEPEND}
	sys-apps/help2man"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build gtk GUI)
	)

	cmake-utils_src_configure
}
