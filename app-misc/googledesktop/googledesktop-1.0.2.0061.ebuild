# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Google Desktop search"
HOMEPAGE="http://desktop.google.com/linux/"
SRC_URI="http://dl.google.com/linux/deb/pool/non-free/g/google-desktop-linux/google-desktop-linux_${PV}_i386.deb"

LICENSE="googledesktop as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="nostrip"

DEPEND=""
RDEPEND="x86? ( >=x11-libs/gtk+-2.2.0 )
		 amd64? ( app-emulation/emul-linux-x86-gtklibs )"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
}

src_install() {
	cp -pPR opt usr var "${D}"/ || die "installing data failed"
	dosym /opt/google/desktop/xdg/google-gdl.desktop /usr/share/applications/
	dosym /opt/google/desktop/xdg/google-gdl-preferences.desktop /usr/share/applications/

}
