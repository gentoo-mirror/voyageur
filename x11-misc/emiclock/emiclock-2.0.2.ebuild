# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Hyper-animated face analog clock for X11"
HOMEPAGE="http://download.vector.co.jp/pack/unix/personal/tokei/"
SRC_URI="http://download.vector.co.jp/pack/unix/personal/tokei/${P}.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64"
IUSE="Xaw3d offensive"

DEPEND="Xaw3d? ( x11-libs/Xaw3d )"

src_compile() {

	sed -i 's/#undef\s*USE_SOUND\(.*\)/#define USE_SOUND\1/' config.h
	if use Xaw3d; then
		sed -i 's/#undef\s*USE_XAW3D\(.*\)/#define USE_XAW3D\1/' config.h
	fi
	if use offensive; then
		sed -i 's/\(cw->emiclock\.isTransparent =\) False/\1 True/' EmiClock.c
	fi

	xmkmf || die "xmkmf failed"
	make depend || die "make depend failed"
	make || die "make failed"
}

src_install() {

	#Don't know how to change this before
	sed -i 's/\$(LIBDIR)\/EmiClock/$(DESTDIR)$(LIBDIR)\/EmiClock/' Makefile
	make DESTDIR="${D}" install || die "install failed"

}

