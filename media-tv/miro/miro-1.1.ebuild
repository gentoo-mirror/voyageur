# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Open source video player"
HOMEPAGE="http://www.getmiro.com/"
SRC_URI="http://ftp.osuosl.org/pub/pculture.org/miro/src/Miro-${PV}.tar.gz"
#SRC_URI="http://participatoryculture.org/nightlies/Miro-${PV/_/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

#TODO: This is simply rewritten from setup.cfg. Adding version requirements is strongly recommended.
DEPEND="dev-lang/python
	    dev-libs/nss
	    dev-util/devhelp
	    dev-python/gnome-python-extras
		dev-python/dbus-python
		=dev-libs/boost-1.34.1-r1
		dev-python/pysqlite
		media-libs/xine-lib
		media-libs/libfame
	    =dev-python/pyrex-0.9.6.4
	    dev-util/pkgconfig"
#	    <sys-libs/db-4.5
#		dev-util/subversion

pkg_setup() {
	if ! built_with_use dev-lang/python berkdb; then
		eerror ""
		eerror "You should reemerge dev-lang/python with \"berkdb\" flag set"
		eerror ""
		die "dev-lang/python reemerge needed"
	fi
}

src_compile() {
	./Miro-${PV/_/-}/platform/gtk-x11/setup.py build \
		|| die "build failed"
}

src_install() {
	./Miro-${PV/_/-}/platform/gtk-x11/setup.py install --root "${D}" \
		|| die "install failed"
}

pkg_postinst() {
	MOZSETUP=/usr/lib*/python*/site-packages/miro/mozsetup.py
	elog ""
	elog "To increase the font size of the main display area, add:"
	elog "user_pref(\"font.minimum-size.x-western\", 15);"
	elog ""
	elog "to the following file:"
	elog /usr/lib*/python*/site-packages/miro/mozsetup.py
	elog ""
}

