# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit multilib python-single-r1 cmake-utils fdo-mime

DESCRIPTION="A simple interface for working with TeX documents"
HOMEPAGE="http://tug.org/texworks/"
SRC_URI="https://github.com/TeXworks/texworks/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lua python +qt4 qt5"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	^^ ( qt4 qt5 )"

QT4_DEPS="
	app-text/poppler[qt4]
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qtscript:4
"
QT5_DEPS="
	app-text/poppler[qt5]
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtscript:5[scripttools]
"
RDEPEND="
	app-text/hunspell
	qt4? ( ${QT4_DEPS} )
	qt5? ( ${QT5_DEPS} )
	lua? ( dev-lang/lua:0 )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}-release-${PV}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with lua LUA)
		$(cmake-utils_use_with python PYTHON)
		-DTeXworks_PLUGIN_DIR="/usr/$(get_libdir)/texworks"
		-DTeXworks_DOCS_DIR="/share/doc/${PF}"
		-DDESIRED_QT_VERSION=$(usex qt4 4 "$(usex qt5 5 4)")
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	elog "=== optional dependencies ==="
	elog
	elog "For typesetting support (e.g. converting to pdf)"
	elog "you'll need processing tools, such as 'pdfTex' or 'pdfLaTeX'."
	elog "These can be found in e.g.:"
	elog "  app-text/texlive-core"
	elog "  dev-texlive/texlive-latex"
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
