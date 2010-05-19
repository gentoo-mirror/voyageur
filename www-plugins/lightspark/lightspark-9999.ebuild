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
IUSE="+nsplugin"

RDEPEND="dev-libs/libpcre
	media-libs/ftgl
	media-libs/libsdl
	media-video/ffmpeg
	net-misc/curl
	nsplugin? ( dev-libs/nspr
		net-libs/xulrunner:1.9
		x11-libs/gtkglext )"
DEPEND="${RDEPEND}
	dev-lang/nasm
	dev-util/pkgconfig
	>=sys-devel/llvm-2.7"

src_configure() {
	local mycmakeargs="$(cmake-utils_use nsplugin COMPILE_PLUGIN)"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use nsplugin; then
		# Get plugin in correct Gentoo place
		dodir /usr/$(get_libdir)/nsbrowser/plugins
		mv "${D}"/usr/lib/mozilla/plugins/* \
			"${D}"/usr/$(get_libdir)/nsbrowser/plugins || die "plugin move failed"
		rmdir -p "${D}"/usr/lib/mozilla/plugins
	fi

	# Executable bit missing
	chmod a+x "${D}"/usr/bin/* "${D}"/usr/$(get_libdir)/nsbrowser/plugins/*
}
