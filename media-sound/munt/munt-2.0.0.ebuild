# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="software synthesiser emulating pre-GM MIDI devices (Roland MT-32)"
HOMEPAGE="http://munt.sourceforge.net"
SRC_URI="mirror://sourceforge/munt/${PV}/${P}.tar.gz"

# library: GPL-2 and LGPL-2.1, qt frontend: GPL-3
LICENSE="LGPL-2.1+ GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa pulseaudio +qt5"

REQUIRED_USE="alsa? ( qt5 )
	pulseaudio? ( qt5 )"

DEPEND="alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5 )
	|| ( media-libs/soxr media-libs/libsamplerate )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "s#share/doc/${PN}#share/doc/${PF}#" \
		-e "s#COPYING\(.LESSER\)\?.txt ##g" \
		-i */CMakeLists.txt || die

	default
}

src_configure() {
	local mycmakeargs=(
		-Dmunt_WITH_MT32EMU_QT=$(usex qt5)
		-Dmt32emu-qt_WITH_ALSA_MIDI_SEQUENCER=$(usex alsa)
		-Dmt32emu-qt_USE_PULSEAUDIO_DYNAMIC_LOADING=$(usex pulseaudio)
		-Dmt32emu-qt_WITH_QT5=ON
	)
	cmake-utils_src_configure
}
