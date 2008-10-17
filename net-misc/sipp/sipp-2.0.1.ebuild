# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs eutils

DESCRIPTION="A free Open Source test tool and traffic generator for the SIP protocol"
HOMEPAGE="http://sipp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/_/}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE="debug gsl pcap ssl"

DEPEND="sys-libs/ncurses
		gsl? ( sci-libs/gsl )
		pcap? ( net-libs/libpcap
				net-libs/libnet )
		ssl? ( dev-libs/openssl )"

S="${WORKDIR}/${P/_/}.src"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s:^CC_linux=.*:CC_linux=$(tc-getCC):" \
		-e "s:^CPP_linux=.*:CPP_linux=$(tc-getCXX):" \
		-e "s:^CFLAGS_linux=\(.*\):CFLAGS_linux=${CFLAGS} \1:" \
		-e "s:^CPPFLAGS_linux=\(.*\):CPPFLAGS_linux=${CXXFLAGS} \1:" \
		-e "s:^INCDIR_linux=.*:INCDIR_linux=-I.:" \
	Makefile || die "sed failed"

	if use ssl; then
		sed -i -e "s:^INCDIR_linux=.*:INCDIR_linux=-I. -I/usr/include/openssl:" \
		Makefile || die "sed failed"
	fi

	if use gsl; then
		sed -i \
			-e 's:$(EXTRACFLAGS):-DHAVE_GSL:' \
			-e 's:$(EXTRACPPFLAGS):-DHAVE_GSL:' \
			-e 's:$(EXTRALIBS):-lgsl -lgslcblas:' \
			Makefile || die "sed failed"
	fi

	if use debug; then
		sed -i -e 's:$(DEBUG_FLAGS):-g -pg:' \
		Makefile || die "sed failed"
	fi
}

src_compile() {
	local makeopt

	use pcap && makeopt="pcapplay"
	use ssl && makeopt="${makeopt:+${makeopt}_}ossl"

	emake -j1 ${makeopt} || die "make failed"
}

src_install() {
	dobin sipp
	dodoc *.txt sipp.dtd
	if use pcap; then
		insinto /usr/share/${PN}/pcap
		doins "${S}"/pcap/*pcap
	fi
}
