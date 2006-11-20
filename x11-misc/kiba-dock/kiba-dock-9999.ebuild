# Copyright 1999-2006 Gentoo Foundation 
# Distributed under the terms of the GNU General Public License v2 
# $Header: $ 

inherit gnome2 cvs autotools

ECVS_SERVER="metascape.afraid.org:/cvsroot" 
ECVS_MODULE="kiba-dock" 
ECVS_LOCALNAME="kiba-dock" 

S=${WORKDIR}/${ECVS_LOCALNAME} 

DESCRIPTION="Kiba Dock" 
HOMEPAGE="http://forum.beryl-project.org/forum-17-kiba-dock" 
SRC_URI="" 
LICENSE="GPL" 
SLOT="0" 
KEYWORDS="-*" 
IUSE="glitz svg" 

DEPEND=">=x11-libs/gtk+-2.8
	>=dev-libs/glib-2.8
	gnome-base/gconf
	dev-util/glade
	svg? ( gnome-base/librsvg )
	glitz? ( >=media-libs/glitz-0.4 )"

src_compile() { 
	eautoreconf
	gnome2_src_compile $(use_enable glitz) $(use_enable svg)
}

kill_gconf() {
        # this function will kill all running gconfd that could be causing troubles
        if [ -x /usr/bin/gconftool ]
        then
                /usr/bin/gconftool --shutdown
        fi
        if [ -x /usr/bin/gconftool-1 ]
        then
                /usr/bin/gconftool-1 --shutdown
        fi

        # and for gconf 2
        if [ -x /usr/bin/gconftool-2 ]
        then
                /usr/bin/gconftool-2 --shutdown
        fi
        return 0
}

pkg_postinst(){ 
	kill_gconf

	echo 
	einfo "To add launchers, run /usr/bin/populate-dock.sh" 
	einfo "or drag shortcuts (from gnome-menu for example) onto the dock" 
	echo 
}

pkg_postinst() {
	einfo "Please report all bugs to http://bugs.gentoo-xeffects.org"
	einfo "Thank you on behalf of the Gentoo XEffects team"
}

