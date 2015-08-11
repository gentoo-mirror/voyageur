# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/pysolfc/pysolfc-2.0-r3.ebuild,v 1.1 2014/04/07 20:11:18 tupone Exp $

EAPI=5
ESVN_REPO_URI="svn://svn.code.sourceforge.net/p/pysolfc/code/PySolFC/trunk"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"
DISTUTILS_SINGLE_IMPL="1"

inherit eutils subversion python-single-r1 distutils-r1 games

CARDSETS=PySolFC-Cardsets-2.0

DESCRIPTION="An exciting collection of more than 1000 solitaire card games"
HOMEPAGE="http://pysolfc.sourceforge.net/"
SRC_URI="extra-cardsets? ( mirror://sourceforge/${PN}/${CARDSETS}.tar.bz2 )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+extra-cardsets minimal +sound"

DEPEND=""
RDEPEND="${RDEPEND}
	sound? ( dev-python/pygame[${PYTHON_USEDEP}] )
	!minimal? ( dev-python/pillow[tk,${PYTHON_USEDEP}]
		dev-tcltk/tktable )"

src_unpack() {
	use extra-cardsets && unpack ${A}
	subversion_src_unpack
}

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}-PIL-imports.patch" #471514
		"${FILESDIR}"/${PN}-2.0-gentoo.patch
	)

	distutils-r1_python_prepare_all
}

pkg_setup() {
	games_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	distutils-r1_src_prepare

	sed -i \
		-e "/pysol.desktop/d" \
		-e "s:share/icons:share/pixmaps:" \
		-e "s:data_dir =.*:data_dir = \'${GAMES_DATADIR}/${PN}\':" \
		setup.py || die

	sed -i \
		-e "s:@GAMES_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		pysollib/settings.py || die "fixing settings"

	mv docs/README{,.txt}
}

python_compile_all() {
	# Missing in SVN checkout
	emake mo rules
}

src_compile() {
	distutils-r1_src_compile
}

python_install_all() {
	make_desktop_entry pysol.py "PySol Fan Club Edition" pysol02

	if use extra-cardsets; then
		# doins is slow
		cp -ra "${WORKDIR}"/${CARDSETS}/* "${D}/${GAMES_DATADIR}"/${PN}
	fi

	doman docs/*.6

	DOCS=( README AUTHORS docs/README.txt docs/README.SOURCE )
	HTML_DOCS=( data/*html )

	distutils-r1_python_install_all

	dodir "${GAMES_BINDIR}"

	mv "${D}"/usr/bin/pysol.py "${D}""${GAMES_BINDIR}"/

	prepgamesdirs
}

src_install() {
	distutils-r1_src_install
}
