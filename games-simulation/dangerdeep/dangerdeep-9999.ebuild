# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop git-r3 scons-utils toolchain-funcs

DESCRIPTION="a World War II German submarine simulation"
HOMEPAGE="http://dangerdeep.sourceforge.net/"
EGIT_REPO_URI="https://git.code.sf.net/p/${PN}/git"

LICENSE="GPL-2 CC-BY-NC-ND-2.0"
SLOT="0"
KEYWORDS=""
IUSE="cpu_flags_x86_sse debug"

RDEPEND="virtual/opengl
	virtual/glu
	sci-libs/fftw:3.0
	media-libs/libsdl[joystick,opengl,video]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-net"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${P}/${PN}
DOCS=( ChangeLog CREDITS README )
PATCHES=( "${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-gcc6.patch )

src_compile() {
	local sse=-1

	if use cpu_flags_x86_sse ; then
		use amd64 && sse=3 || sse=1
	fi

	CXX="$(tc-getCXX)" escons \
		usex86sse=${sse} debug=$(usex debug 1 0) \
		datadir=/usr/share/${PN}
}

src_install() {
	dobin build/linux/${PN}

	insinto /usr/share/${PN}
	doins -r data/*

	newicon dftd_icon.png ${PN}.png
	make_desktop_entry ${PN} "Danger from the Deep"

	einstalldocs
}
