# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit multilib python-single-r1 cmake-utils fdo-mime

DESCRIPTION="A simple interface for working with TeX documents"
HOMEPAGE="http://tug.org/texworks/"
SRC_URI="https://github.com/TeXworks/texworks/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lua python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="app-text/hunspell
	app-text/poppler[qt5]
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtscript:5[scripttools]
	lua? ( dev-lang/lua:0 )
	python? ( ${PYTHON_DEPS} ) "
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}-release-${PV}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DWITH_LUA=$(usex lua ON OFF)
		-DWITH_PYTHON=$(usex python ON OFF)
		-DTeXworks_PLUGIN_DIR="/usr/$(get_libdir)/texworks"
		-DTeXworks_DOCS_DIR="/share/doc/${PF}"
		-DDESIRED_QT_VERSION=5
		-DQTPDF_VIEWER=ON

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
