# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/emacs/emacs-22.0.50_pre20050225.ebuild,v 1.3 2005/04/12 21:28:03 eradicator Exp $

IUSE="qt4 debug"

inherit eutils

DESCRIPTION="Hydranode - a p2p daemon"

HOMEPAGE="http://www.hydranode.com"
SRC_URI="http://osdn.dl.sourceforge.net/sourceforge/hydranode/hydranode-${PV}-r2998-src.tar.bz2"

#SANDBOX_DISABLED="0"

DEPEND="qt4? ( >=x11-libs/qt-4.0.0 ) 
	dev-libs/boost"

PROVIDE=""

SLOT="1"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

S=hydranode-${PV}-src

src_unpack() {
	unpack ${A}
	cd ${S}
	cp ${FILESDIR}/Jamrules . || die "Jamrules not patched"
	epatch ${FILESDIR}/qt4.jam.patch || die "couldn't apply qt patch"
	cp ${FILESDIR}/project-root.jam . || die "project-root patching failed"
	#this causes major breakage if not renamed for qt4 gui. maybe it'll be fixed soon.
	mv hncgcomm/test/ecomm.cpp~ hncgcomm/test/ecomm.cpp
	mv hncgcomm/test/ecomm.h~ hncgcomm/test/ecomm.h
}

src_compile() {
	cd ${WORKDIR}/${S}
	einfo "building hydranode core..."
	if use debug; then
		einfo "--[building debug version"
		bjam || die " debug build failed"
	else
		bjam release || die "build failed"
	fi
	if use qt4; then
		einfo "building hydranode Qt4 gui..."
		if use debug; then
			einfo "--[building debug version"
			bjam hngui || die "qt4 debug gui build failed"
		else
			bjam release hngui || die "qt4gui build failed"
		fi
	fi
}

src_install () {
	doinitd ${FILESDIR}/hydranode
	cd ${WORKDIR}/${S}	

#bjam --install violates sandbox, no matter the prefix :(	
#so the manual way is needed

	if use debug; then 
		directory=debug
	else
		directory=release
	fi

	einfo installing core executables...
	exeinto /opt/hydranode
	for filename in ${directory}/*; do
	    doexe $filename
	done
	
	insinto /opt/hydranode/plugins
	for filename in ${directory}/plugins/*; do
	    doins $filename
	done
	insinto /opt/hydranode/lib
	for filename in ${directory}/lib/*; do
	    doins $filename
	done

	if use qt4; then
	    einfo installing gui files
	    exeinto /opt/hydranode
	    for filename in hngui/${directory}/*; do
		doexe $filename
	    done
	    insinto /opt/hydranode/plugins
	    for filename in hngui/${directory}/plugins/*; do
		doins $filename
	    done
	    insinto /opt/hydranode/lib
	    for filename in hngui/${directory}/lib/*; do
		doins $filename
	    done
	    #hydranode gui wrapper
	    dobin ${FILESDIR}/hngui
	#pictures for gui
	cp -R hngui/backgrounds ${D}/opt/hydranode
	cp -R hngui/icon ${D}/opt/hydranode
	fi

	#cfg files
	newconfd ${FILESDIR}/hnconf hydranode
	newinitd ${FILESDIR}/hninit hydranode

}
