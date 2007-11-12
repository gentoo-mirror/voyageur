# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils flag-o-matic autotools

MY_P=${PN}_2.4_preview3
S=${WORKDIR}/${MY_P}

DESCRIPTION="Great Video editing/encoding tool"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
SRC_URI="http://download.berlios.de/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="a52 aac aften alsa altivec amrnb arts debug dts esd extrafilters fontconfig
	gtk jack libsamplerate mp2 mp3 nls oss qt4 sdl truetype vorbis X x264 xv xvid"

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
	jack? ( media-sound/jack-audio-connection-kit )
	libsamplerate? ( media-libs/libsamplerate )
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
	dev-util/cmake
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
		eerror "dev-lang/spidermonkey"
		eerror "Avidemux will not compile nor work without it!"
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

src_compile() {
	local myconf="-DCMAKE_INSTALL_PREFIX=/usr"

	# GUI
	use gtk || myconf="${myconf} -DNO_Gtk=1"
	use qt4 || myconf="${myconf} -DNO_Qt4=1"
	# AUDIO CODECS
	use aac || myconf="${myconf} -DNO_FAAC=1 -DNO_FAAD=1"
	use mp3 || myconf="${myconf} -DNO_MP3=1"
	use aften || myconf="${myconf} -DNO_Aften=1"
	use vorbis || myconf="${myconf} -DNO_Vorbis=1"
	use dts || myconf="${myconf} -DNO_libDCA=1"
	use amrnb || myconf="${myconf} -DNO_libAMRNB=1"
	# VIDEO CODECS
	use x264 || myconf="${myconf} -DNO_X264=1"
	use xvid || myconf="${myconf} -DNO_Xvid4=1"
	# AUDIO OUTPUT
	use arts || myconf="${myconf} -DNO_ARTS=1"
	use esd || myconf="${myconf} -DNO_ESD=1"
	use oss || myconf="${myconf} -DNO_OSS=1"
	use jack || myconf="${myconf} -DNO_JACK=1"
	# MISC
	use sdl || myconf="${myconf} -DNO_SDL=1"
	use libsamplerate || myconf="${myconf} -DNO_samplerate=1"
	use fontconfig || myconf="${myconf} -DNO_FontConfig=1"
	use truetype || myconf="${myconf} -DNO_FreeType=1"
	use nls || myconf="${myconf} -DNO_Gettext=1"
	use xv || myconf="${myconf} -DNO_Xvideo=1"

	cmake ${myconf} . || die "cmake failed"
	emake -j1 || die "emake failed"

	if ( use extrafilters ); then
		cd ${WORKDIR}/${P}/avidemux/ADM_filter
		sh buildummy.sh
	fi
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
	if use extrafilters; then
		dodir /usr/share/avidemux/
		dodir /usr/share/avidemux/filters
		exeinto /usr/share/avidemux/filters
		doexe ${WORKDIR}/avidemux-24000/avidemux/ADM_filter/dummy.so
	fi
	dodoc AUTHORS
	insinto /usr/share/pixmaps
	newins ${S}/avidemux_icon.png avidemux.png
}

pkg_postinst() {
	if use extrafilters; then
		echo
		einfo "If you want to activate external filters"
		einfo "open ~/.avidemux/config file and"
		einfo "set filter autoload active to 1"
		einfo "set filter autoload path to /usr/share/avidemux/filters"
		einfo "You can also set the path in the GUI in the"
		einfo "Edit > Preferences > External Filters dialog"
		einfo "Note that there are no usable external Avidemux filters yet,"
		einfo "so you may find this option useless."
	fi
	if use ppc && use oss; then
		echo
		einfo "OSS sound output may not work on ppc"
		einfo "If your hear only static noise, try"
		einfo "changing the sound device to ALSA or arts"
	fi
	echo
}
