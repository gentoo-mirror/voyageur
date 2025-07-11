# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="An emulator for Nintendo Switch"
HOMEPAGE="https://eden-emulator.github.io/"
EGIT_REPO_URI="https://git.eden-emu.dev/eden-emu/eden.git"

EGIT_SUBMODULES=( '-*' 'VulkanMemoryAllocator' 'cpp-httplib' 'cpp-jwt' 'ffmpeg' 'mbedtls' 'simpleini' 'sirit' 'xbyak'
	'externals/boost-headers'
	'externals/dynarmic/externals/unordered_dense'
	'externals/dynarmic/externals/zycore-c'
	'externals/dynarmic/externals/zydis'
	'externals/nx_tzdb/tzdb_to_nx/externals/tz/tz'
)
# Dynarmic is not intended to be generic, it is tweaked to fit emulated processor
# Bundled back some libs: cpp-* mbedtls
LICENSE="|| ( Apache-2.0 GPL-2+ ) 0BSD BSD GPL-2+ ISC MIT
	!system-vulkan? ( Apache-2.0 )"
SLOT="0"
KEYWORDS=""
IUSE="-compatibility-list +cubeb lto +qt6 sdl +system-libfmt +system-vulkan test webengine"

#	external ffmpeg not supported by upstream, needs internal header and old API
#	Change YUZU_USE_BUNDLED_FFMPEG and drop from EGIT_SUBMODULES when fixed
#	>=media-video/ffmpeg-4.3:=
RDEPEND="
	app-arch/lz4:=
	>=app-arch/zstd-1.5
	dev-libs/boost:=[context]
	>=dev-libs/inih-52
	>=dev-libs/openssl-1.1:=
	media-libs/opus
	>=media-libs/vulkan-loader-1.3.274
	>=net-libs/enet-1.3
	net-wireless/wireless-tools
	sys-libs/zlib
	virtual/libusb:1
	cubeb? ( media-libs/cubeb )
	qt6? (
		>=dev-qt/qtbase-6.6.0:6[gui,widgets]
		webengine? ( dev-qt/qtwebengine:6[widgets] )
	)
	sdl? ( >=media-libs/libsdl2-2.28 )
	system-libfmt? ( >=dev-libs/libfmt-9:= )
"
DEPEND="${RDEPEND}
	system-vulkan? (
		dev-util/spirv-headers
		dev-util/spirv-tools
		>=dev-util/vulkan-headers-1.4.307
		dev-util/vulkan-utility-libraries
		x11-libs/libX11
	)
	test? ( >dev-cpp/catch-3:0 )
"
BDEPEND="
	>=dev-cpp/nlohmann_json-3.8.0
	dev-cpp/robin-map
	dev-util/glslang
"
REQUIRED_USE="|| ( qt6 sdl ) "
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${P}-cstdlib.patch"
)

src_unpack() {
	if use !system-vulkan; then
		EGIT_SUBMODULES+=('SPIRV-Headers')
		EGIT_SUBMODULES+=('SPIRV-Tools')
		EGIT_SUBMODULES+=('Vulkan-Headers')
		EGIT_SUBMODULES+=('Vulkan-Utility-Libraries')
	fi

	if use test; then
		EGIT_SUBMODULES+=('Catch2')
	fi

	git-r3_src_unpack

	# Do not fetch via sources because this file always changes
	use compatibility-list && curl https://api.citron-emu.org/gamedb/ > "${S}"/compatibility_list.json
}

src_prepare() {
	# temporary fix
	sed -i -e '/Werror/d' src/CMakeLists.txt || die

	# Workaround: GenerateSCMRev fails
	sed -i -e "s/@GIT_BRANCH@/${EGIT_BRANCH:-master}/" \
		-e "s/@GIT_REV@/$(git rev-parse --short HEAD)/" \
		-e "s/@GIT_DESC@/$(git describe --always --long)/" \
		src/common/scm_rev.cpp.in || die

	# Unbundle cubeb
	sed -i '/^if.*cubeb/,/^endif()/d' externals/CMakeLists.txt || die

	# Unbundle enet
	sed -i -e '/^if.*enet/,/^endif()/d' externals/CMakeLists.txt || die
	sed -i -e '/enet\/enet\.h/{s/"/</;s/"/>/}' src/network/network.cpp || die

	# LZ4 temporary fix: https://github.com/yuzu-emu/yuzu/pull/9054/commits/a8021f5a18bc5251aef54468fa6033366c6b92d9
	sed -i 's/lz4::lz4/lz4/' src/common/CMakeLists.txt || die

	if ! use system-libfmt; then # libfmt >= 9
		sed -i '/fmt.*REQUIRED/d' CMakeLists.txt || die
	fi

	# Relax vulkan version requirement
	sed -i -e 's/(VulkanHeaders.*)/(VulkanHeaders REQUIRED)/' CMakeLists.txt || die

	# Do not require qt-multimedia
	sed -i -e '/find_package(Qt6/s/Multimedia //' CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
		# Libraries are private and rely on circular dependency resolution.
		-DYUZU_ENABLE_LTO=$(usex lto ON OFF)
		-DBUILD_SHARED_LIBS=OFF # dynarmic
		-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=$(usex compatibility-list)
		-DENABLE_CUBEB=$(usex cubeb ON OFF)
		-DENABLE_LIBUSB=ON
		-DENABLE_QT=$(usex qt6 ON OFF)
		-DENABLE_QT_TRANSLATION=$(usex qt6 ON OFF)
		-DENABLE_SDL2=$(usex sdl ON OFF)
		-DENABLE_WEB_SERVICE=ON
		-DSIRIT_USE_SYSTEM_SPIRV_HEADERS=$(usex system-vulkan ON OFF)
		-DUSE_DISCORD_PRESENCE=OFF
		-DYUZU_TESTS=$(usex test)
		-DYUZU_USE_EXTERNAL_VULKAN_SPIRV_TOOLS=$(usex system-vulkan OFF ON)
		-DYUZU_USE_EXTERNAL_VULKAN_HEADERS=$(usex system-vulkan OFF ON)
		-DYUZU_USE_EXTERNAL_VULKAN_UTILITY_LIBRARIES=$(usex system-vulkan OFF ON)
		-DYUZU_USE_EXTERNAL_SDL2=OFF
		-DYUZU_USE_BUNDLED_FFMPEG=ON
		-DYUZU_CHECK_SUBMODULES=false
		-DYUZU_USE_QT_MULTIMEDIA=OFF
		-DYUZU_USE_QT_WEB_ENGINE=$(usex webengine ON OFF)
	)

	cmake_src_configure

	# This would be better in src_unpack but it would be unlinked
	if use compatibility-list; then
		mv "${S}"/compatibility_list.json "${BUILD_DIR}"/dist/compatibility_list/ || die
	fi
}
