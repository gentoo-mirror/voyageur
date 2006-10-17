# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Small suite of video4linux related software"
HOMEPAGE="http://bytesex.org/xawtv/"
SRC_URI="http://dl.bytesex.org/cvs-snapshots/xawtv-20061011-144447.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="aalib alsa dv lirc mmx motif nls opengl quicktime X xv zvbi xext"

RDEPEND=">=sys-libs/ncurses-5.1
	>=media-libs/jpeg-6b
	media-libs/libpng
	X? ( || ( (
			x11-libs/libFS
			x11-libs/libXmu
			x11-libs/libX11
			x11-libs/libXaw
			x11-libs/libXt
			x11-libs/libXext
			x11-libs/libXrender
			xext? (
				x11-libs/libXinerama
				x11-libs/libXxf86dga
				x11-libs/libXrandr
				x11-libs/libXxf86vm
			)
			x11-apps/xset
			xv? ( x11-libs/libXv )
		) <virtual/x11-7 )
	)
	motif? ( x11-libs/openmotif
		app-text/recode )
	alsa? ( media-libs/alsa-lib )
	aalib? ( media-libs/aalib )
	dv? ( media-libs/libdv )
	lirc? ( app-misc/lirc )
	opengl? ( virtual/opengl )
	quicktime? ( virtual/quicktime )
	zvbi? ( media-libs/zvbi )"

DEPEND="${RDEPEND}
	X? ( || ( (
				x11-apps/xset
				x11-apps/bdftopcf
				x11-proto/videoproto
				xext? ( x11-proto/xineramaproto )
			) <virtual/x11-7 )
		)"


DEPEND=""
RDEPEND=""
S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/xawtv-3.95-libquicktime-compat.patch"
}

src_compile() {
	./autogen.sh
	econf \
		$(use_with X x) \
		$(use_enable xext xfree-ext) \
		$(use_enable xv xvideo) \
		$(use_enable dv)  \
		$(use_enable mmx) \
		$(use_enable motif) \
		$(use_enable quicktime) \
		$(use_enable alsa) \
		$(use_enable lirc) \
		$(use_enable opengl gl) \
		$(use_enable zvbi) \
		$(use_enable aalib aa) \
		|| die " xawtv configure failed"

	econf
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
