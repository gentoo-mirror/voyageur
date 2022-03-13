# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Hyper-animated face analog clock for X11"
HOMEPAGE="http://www.vector.co.jp/soft/dl/unix/personal/se117802.html"
SRC_URI="http://ftp.vector.co.jp/11/78/1347/${P}.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="Xaw3d offensive"

RDEPEND="media-libs/alsa-oss
	x11-libs/libX11
	Xaw3d? ( x11-libs/libXaw3d )"
DEPEND="${RDEPEND}
	|| (
		x11-misc/gccmakedep
		x11-misc/imake )"

src_prepare() {
	default

	sed -i 's/#undef\s*USE_SOUND\(.*\)/#define USE_SOUND\1/' config.h || die
	if use Xaw3d; then
		sed -i 's/#undef\s*USE_XAW3D\(.*\)/#define USE_XAW3D\1/' config.h || die
		# No need for libXaw3d.a now
		sed -i 's#DEPXAWLIB = \$(USRLIBDIR)/libXaw3d.a#DEPXAWLIB =#' Imakefile || die
	fi
	if use offensive; then
		sed -i 's/\(cw->emiclock\.isTransparent =\) False/\1 True/' EmiClock.c || die
	fi
}

src_compile() {
	xmkmf || die
	emake depend
	emake
}

src_install() {
	#Don't know how to change this before
	sed -i 's/\$(LIBDIR)\/EmiClock/$(DESTDIR)$(LIBDIR)\/EmiClock/' Makefile || die
	emake DESTDIR="${D}" install

	mv "${D}"/usr/bin/emiclock "${D}"/usr/bin/emiclock-bin || die
	dobin "${FILESDIR}"/emiclock
}
