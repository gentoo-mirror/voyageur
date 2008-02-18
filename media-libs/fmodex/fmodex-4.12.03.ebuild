# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/fmod/fmod-3.74.ebuild,v 1.5 2006/03/06 14:25:51 flameeyes Exp $

use amd64 && mysuffix="64"
MY_P="fmodapi${PV//.}linux${mysuffix}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="music and sound effects library, and a sound processing system"
HOMEPAGE="http://www.fmod.org/"
SRC_URI="http://www.fmod.org/index.php/release/version/${MY_P}.tar.gz"
RESTRICT="nostrip"

LICENSE="fmod"
SLOT="1"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""

src_compile() { :; }

src_install() {

	dolib api/lib/libfmodex${mysuffix}.so.${PV}
	use amd64 && dosym /usr/lib/libfmodex${mysuffix}.so.${PV} /usr/lib/libfmodex${mysuffix}.so
	dosym /usr/lib/libfmodex${mysuffix}.so.${PV} /usr/lib/libfmodex.so

	dolib api/lib/libfmodexp${mysuffix}.so.${PV}
	use amd64 && dosym /usr/lib/libfmodexp${mysuffix}.so.${PV} /usr/lib/libfmodexp${mysuffix}.so
	dosym /usr/lib/libfmodexp${mysuffix}.so.${PV} /usr/lib/libfmodexp.so

	dolib fmoddesignerapi/api/lib/libfmodevent${mysuffix}.so
	use amd64 && dosym /usr/lib/libfmodevent${mysuffix}.so /usr/lib/libfmodevent.so

	insinto /usr/include/fmodex
	doins api/inc/*
	doins fmoddesignerapi/api/inc/*

	dodoc fmoddesignerapi/README.TXT
	dodoc documentation/{LICENSE.TXT,revision.txt}
	insinto /usr/share/doc/${P}
	doins documentation/fmodex.pdf
}
