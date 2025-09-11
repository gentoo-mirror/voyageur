# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="An emulator for Nintendo Switch"
HOMEPAGE="https://eden-emulator.github.io/"
EGIT_REPO_URI="https://git.eden-emu.dev/eden-emu/eden.git"

LICENSE="|| ( Apache-2.0 GPL-2+ ) 0BSD BSD GPL-2+ ISC MIT
	!system-vulkan? ( Apache-2.0 )"
SLOT="0"
KEYWORDS=""
IUSE="+cubeb lto sdl +system-ffmpeg +system-vulkan test webengine web-service wifi"

RDEPEND="
	app-arch/lz4:=
	>=app-arch/zstd-1.5
	dev-cpp/simpleini
	dev-libs/boost:=[context]
	>=dev-libs/inih-52
	>=dev-libs/libfmt-9:=
	>=dev-libs/openssl-1.1:=
	dev-libs/quazip:=[qt6(+)]
	>=dev-qt/qtbase-6.6.0:6[gui,widgets]
	media-libs/opus
	>=media-libs/vulkan-loader-1.3.274
	>=net-libs/enet-1.3
	net-libs/mbedtls:0[cmac]
	sys-libs/zlib
	virtual/libusb:1
	cubeb? ( media-libs/cubeb )
	sdl? ( >=media-libs/libsdl2-2.28 )
	system-ffmpeg? ( >=media-video/ffmpeg-4.3:= )
	webengine? ( dev-qt/qtwebengine:6[widgets] )
	wifi? ( net-wireless/wireless-tools )
"
DEPEND="${RDEPEND}
	system-vulkan? (
		dev-util/spirv-headers
		dev-util/spirv-tools
		dev-util/vulkan-utility-libraries
		x11-libs/libX11
	)
	test? ( >=dev-cpp/catch-3:0 )
"
BDEPEND="
	>=dev-cpp/nlohmann_json-3.8.0
	dev-cpp/robin-map
	dev-util/glslang
"
RESTRICT="!test? ( test )"

pkg_pretend() {
	if has network-sandbox ${FEATURES}; then
		ewarn 'This live version requires network access during compilation'
		einfo 'This can be achieved via /etc/portage/package.env'
		einfo 'In /etc/portage/env/no_net_sandbox :'
		einfo ' FEATURES="${FEATURES} -network-sandbox"'
		einfo 'In /etc/portage/package.env :'
		einfo ' ~games-emulation/eden-9999 no_net_sandbox'
		die
	fi
}

src_prepare() {
	# lz4: temporary fix https://github.com/yuzu-emu/yuzu/pull/9054/commits/a8021f5a18bc5251aef54468fa6033366c6b92d9
	sed -i 's/lz4::lz4/lz4/' src/common/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF # dynarmic
		-DCMAKE_DISABLE_PRECOMPILE_HEADERS=OFF
		-DDYNARMIC_ENABLE_LTO=$(usex lto ON OFF)
		-DDYNARMIC_TESTS=$(usex test)
		-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF
		-DENABLE_CUBEB=$(usex cubeb ON OFF)
		-DENABLE_LIBUSB=ON
		-DENABLE_QT=ON
		-DENABLE_QT_TRANSLATION=ON
		-DENABLE_QT_UPDATE_CHECKER=OFF
		-DENABLE_SDL2=$(usex sdl ON OFF)
		-DENABLE_WEB_SERVICE=$(usex web-service ON OFF)
		-DENABLE_WIFI_SCAN=$(usex wifi ON OFF)
		-DSIRIT_USE_SYSTEM_SPIRV_HEADERS=$(usex system-vulkan ON OFF)
		-DUSE_DISCORD_PRESENCE=OFF
		-DYUZU_CHECK_SUBMODULES=OFF
		-DYUZU_ENABLE_LTO=$(usex lto ON OFF)
		-DYUZU_TESTS=$(usex test)
		-DYUZU_USE_BUNDLED_FFMPEG=$(usex system-ffmpeg OFF ON)
		-DYUZU_USE_EXTERNAL_SDL2=OFF
		-DYUZU_USE_EXTERNAL_VULKAN_SPIRV_TOOLS=$(usex system-vulkan OFF ON)
		-DYUZU_USE_EXTERNAL_VULKAN_UTILITY_LIBRARIES=$(usex system-vulkan OFF ON)
		-DYUZU_USE_FASTER_LD=OFF
		-DYUZU_USE_QT_MULTIMEDIA=OFF
		-DYUZU_USE_QT_WEB_ENGINE=$(usex webengine ON OFF)

		# May be shorter to switch to
		# -DCPMUTIL_FORCE_SYSTEM=yes and -D*FORCE_BUNDLED
		-DQuaZip-Qt6_FORCE_SYSTEM=ON
		-DSPIRV-Headers_FORCE_SYSTEM=ON
		-DSPIRV-Tools_FORCE_SYSTEM=ON
		-DSimpleIni_FORCE_SYSTEM=ON
		-DVulkanUtilityLibraries_FORCE_SYSTEM=ON
		-Dcubeb_FORCE_SYSTEM=ON
		-Dlibusb_FORCE_SYSTEM=ON
		-Dmbedtls_FORCE_SYSTEM=ON
	)

	cmake_src_configure
}
