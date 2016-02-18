# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit multiprocessing toolchain-funcs

DESCRIPTION="Zoomable user interface with plugin applications"
HOMEPAGE="http://eaglemode.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jpeg pdf png svg tiff truetype xine"

DEPEND=">=dev-lang/perl-5.8
	x11-libs/libX11
	jpeg? ( virtual/jpeg:* )
	png? ( media-libs/libpng:* )
	tiff? ( media-libs/tiff:* )
	xine? ( media-libs/xine-lib )
	svg? ( gnome-base/librsvg:2 )
	pdf? ( app-text/poppler[cairo] )
	truetype? ( media-libs/freetype:2 )"
RDEPEND="${DEPEND}
	>=app-text/ghostscript-gpl-8"

PATCHES=(
	"${FILESDIR}"/${P}-pkg-config.patch
)

src_prepare() {
	default
	sed -e "s/\<gcc/$(tc-getCC)/" -i makers/unicc/plugins/unicc_gnu.pm || die
}

make_pl_buildargs() {
	echo "continue=no"
	# make sure we don't try to build modules that need build-time libs
	if ! (use jpeg && use pdf && use png && use svg && use tiff && use xine); then
		echo "projects=not:$(\
			use jpeg || echo -n emJpeg,; use png || echo -n emPng,;\
			use tiff || echo -n emTiff,; use xine || echo -n emAv,;\
			use pdf || echo -n emPdf,; use svg || echo -n emSvg)"
	fi
}

src_compile() {
	local cpus
	if has_version dev-lang/perl[ithreads] ; then
		einfo "Building with mutliple CPU cores"
		cpus=$(makeopts_jobs)
	else
		einfo "Perl not built with threads support, using 1 CPU core"
		cpus=1
	fi
	# TODO honor CFLAGS/LDFLAGS/...
	perl make.pl build cpus="${cpus}" \
		$(make_pl_buildargs) || die "Compilation failed"
}

src_install() {
	# TODO multilib
	perl make.pl install "root=${D}" "dir=/usr/lib/eaglemode" \
		menu=yes bin=yes || die "Installation failed"

	dodoc README
	dosym /usr/lib/eaglemode/doc/ /usr/share/doc/${PF}/doc
}

pkg_postinst() {
	elog "Eaglemode can use many optional programs at runtime"
	elog "to display and process different kinds of files."
	elog "For a list of these optional programs see"
	elog "/usr/share/doc/${PF}/doc/html/SystemRequirements.html"
}
