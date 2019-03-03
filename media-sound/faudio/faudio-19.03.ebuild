# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib virtualx

DESCRIPTION="Accuracy-focused XAudio reimplementation for open platforms"
HOMEPAGE="https://fna-xna.github.io/"
SRC_URI="https://github.com/FNA-XNA/FAudio/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+abi_x86_32 +abi_x86_64 +ffmpeg"
REQUIRED_USE="|| ( abi_x86_32 abi_x86_64 )"

RDEPEND="media-libs/libsdl2:=[sound,${MULTILIB_USEDEP}]
	ffmpeg? ( media-video/ffmpeg:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/FAudio-${PV}"

multilib_src_configure() {
	local mycmakeargs=(
		"-DFFMPEG=$(usex ffmpeg 1 0)"
	)
	cmake-utils_src_configure
}
