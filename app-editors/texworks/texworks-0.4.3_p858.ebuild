# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2

MY_P=${P/_p/-r}
DESCRIPTION="A simple interface for working with TeX documents"
HOMEPAGE="http://tug.org/texworks/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tar.gz"
#SRC_URI="http://texworks.googlecode.com/files/texworks-0.4.3-r858.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+latex"

LANGS="ar ca cs de es fa fr it ja ko nl pl pt_BR ru sl tr zh_CN"
for LNG in ${LANGS}; do
	IUSE="${IUSE} linguas_${LNG}"
done

RDEPEND=">=x11-libs/qt-core-4.5.2
		 >=x11-libs/qt-gui-4.5.2[dbus]
		 >=app-text/poppler-0.12.3-r3[qt4]
		 >=app-text/hunspell-1.2.8"
DEPEND="${RDEPEND}"
PDEPEND="latex? ( dev-texlive/texlive-latex )
	!latex? ( app-text/texlive-core )"

S=${WORKDIR}/${P/_p*//}

src_prepare() {
	# disable guessing path to tex binary, we already know it
	sed -i '\:system(./getDefaultBinPaths.sh): d' TeXworks.pro || die
	echo '#define DEFAULT_BIN_PATHS "/usr/bin"' > src/DefaultBinaryPaths.h || die

	sed -i '/TW_HELPPATH/ s:/usr/local:/usr:' TeXworks.pro || die
	cp "${FILESDIR}/TeXworks.desktop" "${S}" || die
}

src_configure() {
	eqmake4 TeXworks.pro
}

src_install() {
	dobin ${PN} || die

	# install translations
	insinto /usr/share/${PN}/
	for LNG in ${LANGS}; do
		if use linguas_${LNG}; then
			doins trans/TeXworks_${LNG}.qm || die
		fi
	done
	insinto /usr/share/pixmaps/
	doins res/images/TeXworks.png || die
	insinto /usr/share/applications/
	doins TeXworks.desktop || die
}
