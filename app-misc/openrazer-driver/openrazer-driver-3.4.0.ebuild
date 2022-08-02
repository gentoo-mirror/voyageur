# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit linux-mod udev

OPENRAZER=openrazer-${PV}
DESCRIPTION="Drivers for Razer peripherals on GNU/Linux"
HOMEPAGE="https://openrazer.github.io/"
SRC_URI="https://github.com/openrazer/openrazer/archive/refs/tags/v${PV}.tar.gz -> ${OPENRAZER}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

S=${WORKDIR}/${OPENRAZER}/driver
MODULE_NAMES="
	razerkbd(kernel/drivers/hid)
	razermouse(kernel/drivers/hid)
	razerkraken(kernel/drivers/hid)
	razeraccessory(kernel/drivers/hid)
"
BUILD_TARGETS="clean modules"
BUILD_PARAMS="-C ${KERNEL_DIR} M=${S}"

src_install() {
	linux-mod_src_install

	udev_dorules ../install_files/udev/99-razer.rules
	exeinto "$(get_udevdir)"
	doexe ../install_files/udev/razer_mount
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
