# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1 git-r3 systemd

DESCRIPTION="Systemd suspend-on-idle daemon"
HOMEPAGE="https://github.com/voyageur/pycircadian"
EGIT_REPO_URI="https://github.com/voyageur/pycircadian.git"

LICENSE="GPL-3.0-or-later"
SLOT="0"
IUSE="X"

RDEPEND="
	X? (
		x11-misc/xprintidle
		x11-misc/xssstate
	)
"

src_install() {
	distutils-r1_src_install

	systemd_dounit resources/${PN}.service
	insinto /etc
	newins resources/${PN}.conf.in ${PN}.conf
}
