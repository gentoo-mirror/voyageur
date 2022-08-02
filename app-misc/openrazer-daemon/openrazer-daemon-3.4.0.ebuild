# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

OPENRAZER=openrazer-${PV}
DESCRIPTION="Userspace daemon for OpenRazer"
HOMEPAGE="https://openrazer.github.io/"
SRC_URI="https://github.com/openrazer/openrazer/archive/refs/tags/v${PV}.tar.gz -> ${OPENRAZER}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Skipping dev-python/notify and x11-misc/xautomation
DEPEND="${PYTHON_DEPS}
	dev-python/daemonize[$PYTHON_USEDEP]
	dev-python/dbus-python[$PYTHON_USEDEP]
	dev-python/pygobject:3[$PYTHON_USEDEP]
	dev-python/python-evdev[$PYTHON_USEDEP]
	dev-python/pyudev[$PYTHON_USEDEP]
	dev-python/setproctitle[$PYTHON_USEDEP]
	x11-libs/gtk+:3[introspection]"
RDEPEND="${DEPEND}
	acct-group/plugdev
	app-misc/openrazer-driver"

S=${WORKDIR}/${OPENRAZER}/daemon

python_test() {
	for test in tests/test_*.py
	do
		"${EPYTHON}" -dv ${test} || die
	done
}

python_install_all() {
	exeinto /usr/bin
	newexe run_openrazer_daemon.py openrazer-daemon

	insinto /usr/share/dbus-1/services
	newins resources/org.razer.service.in org.razer.service

	insinto /usr/share/openrazer
	newins resources/razer.conf razer.conf.example

	doman resources/man/razer.conf.5
	doman resources/man/openrazer-daemon.8
}
