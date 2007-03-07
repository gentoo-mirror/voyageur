# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs

DESCRIPTION="Renouveau is used to clean room reverse engineer the nvidia drivers."

HOMEPAGE="http://nouveau.freedesktop.org/wiki/REnouveau"

SRC_URI=""

LICENSE="MIT"

SLOT="0"

KEYWORDS="-* ~amd64 ~x86"

ECVS_SERVER="nouveau.cvs.sourceforge.net:/cvsroot/nouveau"
ECVS_MODULE="renouveau"

IUSE=""

DEPEND="x11-drivers/nvidia-drivers
        x11-libs/libXvMC
        media-libs/libsdl"

RESTRICT="strip"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${ECVS_MODULE}

src_compile() {
	cd "${S}"
	emake || die "emake failed"
}

src_install() {
	dobin renouveau disasm_shader
	dodoc README license.txt
}

