# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake fcaps flag-o-matic git-r3 toolchain-funcs wxwidgets

DESCRIPTION="A PlayStation 2 emulator"
HOMEPAGE="https://www.pcsx2.net"
EGIT_REPO_URI="https://github.com/PCSX2/${PN}.git"
EGIT_SUBMODULES=()

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	dev-libs/libaio
	dev-libs/libfmt:=
	dev-libs/libxml2:2
	media-libs/alsa-lib
	media-libs/libpng:=
	media-libs/libsdl2[haptic,joystick,sound]
	media-libs/libsoundtouch
	media-libs/portaudio
	net-libs/libpcap
	sys-libs/zlib
	virtual/libudev
	virtual/opengl
	x11-libs/gtk+:3
	x11-libs/libICE
	x11-libs/libX11
	x11-libs/libXext
	>=x11-libs/wxGTK-3.0.4-r301:3.0-gtk3[X]
"
DEPEND="${RDEPEND}
	dev-cpp/pngpp
	dev-cpp/sparsehash
"

FILECAPS=(
	"CAP_NET_RAW+eip CAP_NET_ADMIN+eip" usr/bin/PCSX2
)

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary && $(tc-getCC) == *gcc* ]]; then
		# -mxsave flag is needed when GCC >= 8.2 is used
		# https://bugs.gentoo.org/685156
		if [[ $(gcc-major-version) -gt 8 || $(gcc-major-version) == 8 && $(gcc-minor-version) -ge 2 ]]; then
			append-flags -mxsave
		fi
	fi
}

src_configure() {
	# Build with ld.gold fails
	# https://github.com/PCSX2/pcsx2/issues/1671
	tc-ld-disable-gold

	# pcsx2 build scripts will force CMAKE_BUILD_TYPE=Devel
	# if it something other than "Devel|Debug|Release"
	local CMAKE_BUILD_TYPE="Release"

		# https://github.com/PCSX2/pcsx2/pull/422
#		local MYCMAKEARGS=(-DCMAKE_TOOLCHAIN_FILE=cmake/linux-compiler-i386-multilib.cmake)

	local mycmakeargs=(
		-DARCH_FLAG=
		-DDISABLE_BUILD_DATE=TRUE
		-DDISABLE_PCSX2_WRAPPER=TRUE
		-DDISABLE_SETCAP=TRUE
		-DEXTRA_PLUGINS=FALSE
		-DOPTIMIZATION_FLAG=
		-DPACKAGE_MODE=TRUE
		-DXDG_STD=TRUE

		-DCMAKE_LIBRARY_PATH="/usr/$(get_libdir)/${PN}"
		-DDOC_DIR=/usr/share/doc/"${PF}"
		-DGTK3_API=TRUE
		-DPLUGIN_DIR="/usr/$(get_libdir)/${PN}"
		# wxGTK must be built against same sdl version
		-DSDL2_API=TRUE
		-DUSE_VTUNE=FALSE
	)

	WX_GTK_VER="3.0-gtk3" setup-wxwidgets
	cmake_src_configure
}

src_install() {
	# Upstream issues:
	#  https://github.com/PCSX2/pcsx2/issues/417
	#  https://github.com/PCSX2/pcsx2/issues/3077
	QA_EXECSTACK="usr/bin/PCSX2"
	QA_TEXTRELS="usr/$(get_libdir)/pcsx2/* usr/bin/PCSX2"
	cmake_src_install
}
