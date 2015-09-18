# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="software synthesiser emulating pre-GM MIDI devices (Roland MT-32)"
HOMEPAGE="http://munt.sourceforge.net"
SRC_URI="mirror://sourceforge/munt/${PV}/${P}.tar.gz"

# library: GPL-2 and LGPL-2.1, qt frontend: GPL-3
LICENSE="LGPL-2.1+ GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa pulseaudio +qt4"

REQUIRED_USE="alsa? ( qt4 )
	pulseaudio? ( qt4 )"

DEPEND="alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	qt4? ( dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtmultimedia:4 )
	|| ( media-libs/soxr media-libs/libsamplerate )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "s#share/doc/${PN}#share/doc/${PF}#" \
		-e "s#COPYING\(.LESSER\)\?.txt ##g" \
		-i */CMakeLists.txt || die "sed failed"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use qt4 munt_WITH_MT32EMU_QT)
		$(cmake-utils_use alsa mt32emu-qt_WITH_ALSA_MIDI_DRIVER)
		$(cmake-utils_use pulseaudio mt32emu-qt_USE_PULSEAUDIO_DYNAMIC_LOADING)
	)
#		-DTeXworks_DOCS_DIR="/share/doc/${PF}"
#		-DDESIRED_QT_VERSION=$(usex qt4 4 "$(usex qt5 5 4)")
	cmake-utils_src_configure
}
