# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit multilib cmake-utils git

DESCRIPTION="High performance flash player designed from scratch to be efficient on modern hardware"
HOMEPAGE="https://launchpad.net/lightspark"
SRC_URI=""
EGIT_REPO_URI="git://lightspark.git.sourceforge.net/gitroot/lightspark/lightspark"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="nsplugin pulseaudio"

RDEPEND="dev-libs/libpcre
	media-fonts/liberation-fonts
	media-libs/ftgl
	media-libs/glew
	media-libs/libsdl
	media-video/ffmpeg
	net-misc/curl
	virtual/opengl
	nsplugin? ( dev-libs/nspr
		net-libs/xulrunner:1.9
		x11-libs/gtkglext )
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}
	dev-lang/nasm
	dev-util/pkgconfig
	>=sys-devel/llvm-2.7"

src_prepare() {
	#/usr/share/fonts/truetype/ttf-liberation/LiberationSerif-Regular.ttf
	# Hardcoded font path...
	sed -i "s#truetype/ttf-liberation/#liberation-fonts/#" \
		swf.cpp || die "font path sed failed"
}

src_configure() {
	local mycmakeargs="$(cmake-utils_use nsplugin COMPILE_PLUGIN)
		$(cmake-utils_use pulseaudio ENABLE_SOUND)
		-DPLUGIN_DIRECTORY=/usr/$(get_libdir)/nsbrowser/plugins"
	cmake-utils_src_configure
}
