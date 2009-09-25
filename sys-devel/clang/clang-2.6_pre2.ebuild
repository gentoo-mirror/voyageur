# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="C language family frontend for LLVM"
HOMEPAGE="http://clang.llvm.org/"
# Fetching LLVM as well: see http://llvm.org/bugs/show_bug.cgi?id=4840
SRC_URI="http://llvm.org/prereleases/${PV/_pre*}/pre-release${PV/*_pre}/llvm-${PV/_pre*}.tar.gz -> llvm-${PV}.tar.gz
	http://llvm.org/prereleases/${PV/_pre*}/pre-release${PV/*_pre}/${PN}-${PV/_pre*}.tar.gz -> ${P}.tar.gz"

# See http://www.opensource.org/licenses/UoI-NCSA.php
LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+static-analyzer"

# TODO: non-system deps?
# Note: for LTO support, clang will depend on binutils with gold plugins, and LLVM built after that - http://llvm.org/docs/GoldPlugin.html
DEPEND=""
RDEPEND="~sys-devel/llvm-${PV}"

S="${WORKDIR}/llvm-2.6"

src_prepare() {
	mv "${WORKDIR}"/clang-2.6 "${S}/tools/clang" || die "clang source directory not found"
}

src_configure() {
	local CONF_FLAGS=""

	if use debug; then
		CONF_FLAGS="${CONF_FLAGS} --disable-optimized"
		einfo "Note: Compiling LLVM in debug mode will create huge and slow binaries"
		# ...and you probably shouldn't use tmpfs, unless it can hold 900MB
	else
		CONF_FLAGS="${CONF_FLAGS} \
			--enable-optimized \
			--disable-assertions \
			--disable-expensive-checks"
	fi

	if use alltargets; then
		CONF_FLAGS="${CONF_FLAGS} --enable-targets=all"
	else
		CONF_FLAGS="${CONF_FLAGS} --enable-targets=host-only"
	fi

	if use amd64; then
		CONF_FLAGS="${CONF_FLAGS} --enable-pic"
	fi

	# things would be built differently depending on whether llvm-gcc is
	# already present on the system or not.

	CONF_FLAGS="${CONF_FLAGS} \
		--with-llvmgccdir=/dev/null \
		--with-llvmgcc=none \
		--with-llvmgxx=none"

	econf ${CONF_FLAGS} || die "econf failed"
}

src_compile() {
	emake VERBOSE=1 KEEP_SYMBOLS=1  clang-only || die "emake failed"
}

src_install() {
	cd "${S}/tools/clang"
	emake DESTDIR="${D}" install || die "emake install failed"
	
	if use static-analyzer ; then
		dobin utils/scan-build
		dobin utils/ccc-analyzer
		dobin tools/scan-view/scan-view
	fi
}
