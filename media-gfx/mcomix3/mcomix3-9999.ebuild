# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7,8} )
inherit desktop git-r3 python-r1 xdg-utils

DESCRIPTION="A fork of mcomix, a GTK3 image viewer for comic book archives"
HOMEPAGE="https://github.com/multiSnow/mcomix3"
EGIT_REPO_URI="https://github.com/multiSnow/mcomix3"
#AUTOTOOLS_AUTORECONF="1"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	virtual/jpeg
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	!media-gfx/comix
	!media-gfx/mcomix"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

src_install() {

	#dodoc CHANGELOG.txt DEVELOPING.txt README.txt TODO.txt

	python_foreach_impl python_domodule mcomix/mcomix
	python_foreach_impl python_newscript mcomix/mcomixstarter.py mcomix3

	doman man/mcomix.1

	for size in 16 22 24 32 48
	do
		doicon -s ${size} \
			mime/icons/${size}x${size}/*png \
			mcomix/mcomix/images/${size}x${size}/mcomix.png
	done
	doicon mcomix/mcomix/images/mcomix.png
	domenu mime/mcomix.desktop

	insinto /usr/share/metainfo
	doins mime/mcomix.appdata.xml

	insinto /usr/share/mime/packages
	doins mime/mcomix.xml

}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	xdg_icon_cache_update
	echo
	elog "Additional packages are required to open the most common comic archives:"
	elog
	elog "    cbr: app-arch/unrar"
	elog "    cbz: app-arch/unzip"
	elog
	elog "You can also add support for 7z or LHA archives by installing"
	elog "app-arch/p7zip or app-arch/lha. Install app-text/mupdf for"
	elog "pdf support."
	echo
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}