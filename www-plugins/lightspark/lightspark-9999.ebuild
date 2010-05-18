# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit multilib cmake-utils bzr

DESCRIPTION="High performance flash player designed from scratch to be efficient on modern hardware"
HOMEPAGE="https://launchpad.net/lightspark"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
# Disabling nsplugin is broken for now
IUSE="+nsplugin vaapi"

EBZR_REPO_URI="lp:lightspark"

RDEPEND="dev-libs/libpcre
	media-libs/ftgl
	media-libs/libsdl
	media-video/ffmpeg
	net-misc/curl
	nsplugin? ( dev-libs/nspr
		net-libs/xulrunner:1.9
		x11-libs/gtkglext )
	vaapi? ( x11-libs/libva[opengl] )"
DEPEND="${RDEPEND}
	dev-lang/nasm
	dev-util/pkgconfig
	>=sys-devel/llvm-2.7"

src_configure() {
	local mycmakeargs="$(cmake-utils_use nsplugin COMPILE_PLUGIN)
		$(cmake-utils_use vaapi USE_VAAPI)"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# Get plugin in correct place for us
	dodir /usr/$(get_libdir)/nsbrowser/plugins
	mv "${D}"/usr/lib/mozilla/plugins/* \
		"${D}"/usr/$(get_libdir)/nsbrowser/plugins || die "plugin move failed"
	rmdir -p "${D}"/usr/lib/mozilla/plugins

	# Executable bit missing
	chmod a+x "${D}"/usr/bin/* "${D}"/usr/lib/mozilla/plugins/*
}
