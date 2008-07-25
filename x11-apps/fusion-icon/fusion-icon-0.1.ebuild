# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2-utils python

MINIMUM_COMPIZ_RELEASE=0.6.0
GIT_SNAPSHOT="5e2dc91599f559040fd0c9d2040cd8906e302825"

DESCRIPTION="Compiz Fusion Tray Icon and Manager"
HOMEPAGE="http://compiz-fusion.org"
SRC_URI="http://gitweb.compiz-fusion.org/?p=users/crdlb/fusion-icon;a=snapshot;h=${GIT_SNAPSHOT};sf=tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk qt4"

RDEPEND="
	>=dev-python/compizconfig-python-${MINIMUM_COMPIZ_RELEASE}
	>=x11-wm/compiz-${MINIMUM_COMPIZ_RELEASE}
	virtual/python
	gtk? ( >=dev-python/pygtk-2.10 )
	qt4? ( dev-python/PyQt4 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19
	x11-apps/xvinfo"

S="${WORKDIR}/${PN}"

src_unpack() {
	tar zxf ${DISTDIR}/${A}
}

src_install() {
	use gtk && interfaces="${interfaces} gtk"
	use qt4 && interfaces="${interfaces} qt4"
	emake "interfaces=${interfaces}" DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	python_version
	python_mod_optimize	${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/FusionIcon

	use gtk && gnome2_icon_cache_update
}

pkg_postrm() {
	python_mod_cleanup
}
