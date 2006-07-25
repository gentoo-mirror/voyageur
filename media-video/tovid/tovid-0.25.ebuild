# Copyright 2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="Video conversion and DVD authoring tools"
HOMEPAGE="http://tovid.org/"

IUSE=""

DEPEND="media-video/mplayer
	media-video/mjpegtools
	media-video/ffmpeg
	media-video/transcode
	media-sound/normalize
	>=media-gfx/imagemagick-6.0
	media-sound/sox
	>=media-video/dvdauthor-0.6.0
	media-video/vcdimager
	media-video/lsdvd
	>=dev-python/wxpython-2.6
	virtual/cdrtools
	app-cdr/dvd+rw-tools
	app-cdr/cdrdao"

KEYWORDS="~x86 ~amd64"
LICENSE="GPL-2"
RESTRICT="nomirror"
SLOT="0"

SRC_URI="http://download.berlios.de/tovid/${P}.tar.gz"

pkg_setup() {
	if ! $(which mencoder &>/dev/null); then
		eerror "Could not find 'mencoder'."
		eerror "Please merge mplayer with useflag 'encode'."
		die
	fi
}
src_compile() {
	econf || die
}

src_install() {
	make DESTDIR=${D} install || die
	python setuplib.py install --prefix=${D}/usr || die
}

pkg_postinst() {
	einfo ""
	einfo "List of suite components:"
	einfo "   dvrequant:   Shrinks and re-authors titles from existing DVDs"
	einfo "   idvid:       Identifies video format, resolution, and length"
	einfo "   makemenu:    Creates (S)VCD/DVD menus"
	einfo "   makeslides:  Creates mpeg still slides for (S)VCD"
	einfo "   makexml:     Creates XML specification for an (S)VCD or DVD navigation hierarchy"
	einfo "   postproc:    Adjusts A/V sync and does shrinking of encoded video"
	einfo "   tovid:       Converts video to (S)VCD or DVD mpeg format"
	einfo ""
	einfo "Please check out the tovid documentation on the web:"
	einfo "   http://tovid.sourceforge.net/"
	einfo ""
}
