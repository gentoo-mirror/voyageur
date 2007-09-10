# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils flag-o-matic autotools

MY_P=${PN}_2.4_preview2
S=${WORKDIR}/${MY_P}

DESCRIPTION="Great Video editing/encoding tool"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="a52 aac aften alsa altivec amrnb arts debug dts esd fontconfig
	gtk mp2 mp3 nls oss qt4 sdl truetype vorbis X x264 xv xvid"

RDEPEND=">=dev-libs/libxml2-2.6.7
	>=dev-lang/spidermonkey-1.5-r2
	a52? ( >=media-libs/a52dec-0.7.4 )
	aac? ( >=media-libs/faac-1.23.5
	       >=media-libs/faad2-2.0-r7 )
	aften? ( media-libs/aften )
	alsa? ( >=media-libs/alsa-lib-1.0.9 )
	amrnb? ( media-libs/amrnb )
	arts? ( >=kde-base/arts-1.2.3 )
	dts? ( media-libs/libdts )
	esd? ( media-sound/esound )
	fontconfig? ( media-libs/fontconfig )
	mp2? ( >=media-sound/twolame-0.3.6 )
	mp3? ( media-libs/libmad
	       >=media-sound/lame-3.93 )
	nls? ( >=sys-devel/gettext-0.12.1 )
	sdl? ( media-libs/libsdl )
	truetype? ( >=media-libs/freetype-2.1.5 )
	vorbis? ( >=media-libs/libvorbis-1.0.1 )
	x264? ( >=media-libs/x264-svn-20061014 )
	xvid? ( >=media-libs/xvid-1.0.0 )
	X? (
		gtk? ( >=x11-libs/gtk+-2.6 )
		qt4? ( >=x11-libs/qt-4.0 )
		xv? ( x11-libs/libXv )
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXrender
		)
	"

DEPEND="$RDEPEND
	X? (
		x11-base/xorg-server
		x11-libs/libXt
		x11-proto/xextproto
		)
	dev-util/pkgconfig"

pkg_setup() {
	if ! ( built_with_use dev-lang/spidermonkey threadsafe ) ; then
		eerror "dev-lang/spidermonkey is missing threadsafe support, please"
		eerror "make sure you enable the threadsafe USE flag and re-emerge"
		eerror "dev-lang/spidermonkey - this Avidemux subversion build"
		eerror "will not compile nor work without it!"
		die "dev-lang/spidermonkey needs threadsafe support"
	fi

	if ! ( use oss || use arts || use alsa ) ; then
		eerror "You must select at least one from alsa, arts and oss audio output."
		die "Fix USE flags"
	fi

	if ( !( use X ) && ( use gtk || use qt4 ) ) ; then
		eerror "If you use gtk and/or qt4, you should also set X."
		die "Fix USE flags"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S} || die
	sed -i -e 's/QTPOSTFIX="-qt4"/QTPOSTFIX=""/' configure.in.in || die "sed failed"
	gmake -f Makefile.dist || die "autotools failed"
	eautoreconf
}

src_compile() {
	local myconf="--with-jsapi-include=/usr/include/js \
		--disable-warnings --disable-dependency-tracking"

	##########
	# CODECS #
	##########
	use a52 || myconf="${myconf} --without-a52dec"
	if use aac; then
		myconf="${myconf} --with-newfaad"
	else
		myconf="${myconf} --without-faac --without-faad2"
	fi
	use aften || myconf="${myconf} --without-aften"
	use mp3 || myconf="${myconf} --without-lame --without-libmad"
	# other codecs are autodetected and can't be turned off

	################
	# AUDIO OUTPUT #
	################
	use alsa || myconf="${myconf} --without-alsa"
	use arts || myconf="${myconf} --without-arts"
	use esd || myconf="${myconf} --without-esd"
	use oss || myconf="${myconf} --without-oss"

	#########
	# OTHER #
	#########
	use altivec && myconf="${myconf} --enable-altivec"
	use debug && myconf="${myconf} --enable-debug"
	use fontconfig || myconf="${myconf} --without-fontconfig"
	use sdl || myconf="${myconf} --without-libsdl"
	use truetype || myconf="${myconf} --without-freetype2"
	use X && myconf="${myconf} --with-x"
	use xv || myconf="${myconf} --without-xv"

	########
	# GUIS #
	########
	use qt4 && myconf="${myconf} --with-qt-dir=/usr  \
		--with-qt-include=/usr/include/qt4 --with-qt-lib=/usr/lib/qt4"

	econf ${myconf} || die "configure failed"
	emake -j1 || die "emake failed"

}

src_install() {
	dobin avidemux/avidemux2_cli || die "CLI could not be installed"
	if use gtk; then
		dobin avidemux/avidemux2_gtk || die "GTK GUI could not be installed"
		make_desktop_entry avidemux2_gtk "Avidemux2 GTK" avidemux.png
	fi
	if use qt4; then
		dobin avidemux/avidemux2_qt4 || die "QT4 GUI could not be installed"
		make_desktop_entry avidemux2_qt4 "Avidemux2 QT4" avidemux.png
	fi
	dodoc AUTHORS
	insinto /usr/share/pixmaps
	newins ${S}/avidemux_icon.png avidemux.png
}

pkg_postinst() {
	if use ppc && use oss; then
		echo
		einfo "OSS sound output may not work on ppc"
		einfo "If your hear only static noise, try"
		einfo "changing the sound device to ALSA or arts"
		echo
	fi
}
