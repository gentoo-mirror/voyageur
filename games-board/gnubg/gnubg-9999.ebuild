# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit autotools cvs desktop python-single-r1 xdg

DESCRIPTION="GNU BackGammon"
HOMEPAGE="https://www.gnu.org/software/gnubg/"
ECVS_SERVER="cvs.savannah.gnu.org:/sources/gnubg"
ECVS_MODULE="gnubg"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="cpu_flags_x86_avx cpu_flags_x86_fma3 cpu_flags_x86_sse cpu_flags_x86_sse2 gtk gtk3 neon python sqlite threads"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/gmp:0=
	dev-libs/libxml2
	media-fonts/dejavu
	media-libs/freetype:2
	media-libs/libcanberra
	media-libs/libpng:0=
	sys-libs/readline:0=
	x11-libs/cairo
	x11-libs/pango
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( gtk? ( x11-libs/gtk+:2 ) )
	python? ( ${PYTHON_DEPS} )
	virtual/libintl"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

REQUIRED_USE="gtk3? ( gtk )"
S=${WORKDIR}/${PN}

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# use ${T} instead of /tmp for constructing credits (bug #298275)
	sed -i -e 's:/tmp:${T}:' credits.sh || die
	sed -i -e 's/fonts //' Makefile.am || die # handle font install ourself to fix bug #335774
	sed -i \
		-e '/^localedir / s#=.*$#= @localedir@#' \
		-e '/^gnulocaledir / s#=.*$#= @localedir@#' \
		po/Makefile.in.in || die
	sed -i \
		-e '/^gnubgiconsdir / s#=.*#= /usr/share#' \
		-e '/^gnubgpixmapsdir / s#=.*#= /usr/share/pixmaps#' \
		pixmaps/Makefile.am || die

	eautoreconf
}

src_configure() {
	local simd=no
	use cpu_flags_x86_sse  && simd=sse
	use cpu_flags_x86_sse2 && simd=sse2
	use cpu_flags_x86_avx  && simd=avx
	use neon  && simd=neon
	econf \
		--localedir="${EPREFIX}"/usr/share/locale \
		--docdir="${EPREFIX}"/usr/share/doc/${PF}/html \
		--disable-cputest \
		--enable-simd="${simd}" \
		$(use_enable threads) \
		$(use_with gtk) \
		$(use_with gtk3 gtk3) \
		$(use_with gtk3 board3d) \
		$(use_with python python "${EPYTHON}") \
		$(use_with sqlite)
}

src_install() {
	default

	# installs pre-compressed man pages
	gunzip "${ED}"/usr/share/man/man6/*.6.gz || die

	insinto /usr/share/${PN}
	doins ${PN}.weights *bd
	dodir /usr/share/${PN}/fonts
	dosym ../../fonts/dejavu/DejaVuSans.ttf /usr/share/${PN}/fonts/Vera.ttf
	dosym ../../fonts/dejavu/DejaVuSans-Bold.ttf /usr/share/${PN}/fonts/VeraBd.ttf
	dosym ../../fonts/dejavu/DejaVuSerif-Bold.ttf /usr/share/${PN}/fonts/VeraSeBd.ttf
	make_desktop_entry "gnubg -w" "GNU Backgammon"
}
