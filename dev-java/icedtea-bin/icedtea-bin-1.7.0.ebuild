# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-vm-2 rpm toolchain-funcs

DESCRIPTION="Java Plugin for 64 Bit Browsers"
HOMEPAGE="http://icedtea.classpath.org"
FEDORA_V="1.7.0.0-0.19.b21.snapshot.fc8.x86_64"
BASE_URI="http://fedora.tu-chemnitz.de/pub/linux/fedora/linux/releases/8/Fedora/x86_64/os/Packages"
SRC_URI="${BASE_URI}/java-${PV}-icedtea-${FEDORA_V}.rpm
        ${BASE_URI}/java-${PV}-icedtea-devel-${FEDORA_V}.rpm
	        nsplugin? ( ${BASE_URI}/java-${PV}-icedtea-plugin-${FEDORA_V}.rpm )"
SLOT="1.7"
LICENSE="OSGPL-0.0"
KEYWORDS="-* ~amd64"
IUSE="nsplugin"

RDEPEND=">=sys-devel/gcc-4.2"

S="${WORKDIR}"

pkg_setup() {
	java-vm-2_pkg_setup
	java-pkg-2_pkg_setup

	if [ $(gcc-version) != "4.2" ]; then
	ewarn "${P} is a binary package, and needs gcc-4.2 to be installed and"
	ewarn "set as currently active compiler!"
	sleep 5
	fi
}

src_unpack() {
	rpm_src_unpack
}
	
src_compile() {
	elog "We install a Fedora binary distribution. Nothing to compile."
}

src_install() {
	dodir /usr/lib64
	cp -a usr/lib/jvm* ${D}/usr/lib64

	if use nsplugin; then
		install_mozilla_plugin \
	/usr/lib64/jvm/java-${PV}-icedtea-${PV}.0.x86_64/jre/lib/amd64/gcjwebplugin.so
	fi

	set_java_env
}
