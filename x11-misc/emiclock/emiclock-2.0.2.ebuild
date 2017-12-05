# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Hyper-animated face analog clock for X11"
HOMEPAGE="http://www.vector.co.jp/soft/dl/unix/personal/se117802.html"
SRC_URI="http://ftp.vector.co.jp/11/78/1347/${P}.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="Xaw3d offensive"

RDEPEND="Xaw3d? ( x11-libs/libXaw3d )
		 media-libs/alsa-oss"
DEPEND="${RDEPEND}
	|| ( (
		x11-misc/gccmakedep
		x11-misc/imake )
	virtual/x11 )"

src_configure() {
	sed -i 's/#undef\s*USE_SOUND\(.*\)/#define USE_SOUND\1/' config.h
	if use Xaw3d; then
		sed -i 's/#undef\s*USE_XAW3D\(.*\)/#define USE_XAW3D\1/' config.h
		# No need for libXaw3d.a now
		sed -i 's#DEPXAWLIB = \$(USRLIBDIR)/libXaw3d.a#DEPXAWLIB =#' Imakefile
	fi
	if use offensive; then
		sed -i 's/\(cw->emiclock\.isTransparent =\) False/\1 True/' EmiClock.c
	fi
}

src_compile() {
	xmkmf || die "xmkmf failed"
	emake depend
	emake
}

src_install() {
	#Don't know how to change this before
	sed -i 's/\$(LIBDIR)\/EmiClock/$(DESTDIR)$(LIBDIR)\/EmiClock/' Makefile
	emake DESTDIR="${D}" install

	mv "${D}"/usr/bin/emiclock "${D}"/usr/bin/emiclock-bin
	dobin "${FILESDIR}"/emiclock
}
