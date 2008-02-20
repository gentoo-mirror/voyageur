# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://llvm.org/releases/${PV}/llvm-${PV}.tar.gz"

LICENSE="LLVM"
# most part of LLVM fall under the "University of Illinois Open Source License"
# which doesn't seem to exist in portage yet, so I call it 'LLVM' for now.  it
# can be read from llvm/LICENSE.TXT in the source tarball.

# the directory llvm/runtime/GCCLibraries/libc contains a stripped down C
# library licensed under the LGPL 2.1 with some third party copyrights, see the
# two LICENCE* files in that directory.  Those parts do *not* get built, so
# we omit LGPL in ${LICENCE}

SLOT="0"

KEYWORDS="~x86"
# That arch status as of 2.0 is as follows (according to the docs):
#
# x86:     Works.  Code generation for >= i568
#
# x86-64:  Claimed to work.  No native code generation
#
# PowerPC: Partial support claimed.  No native code generation.  (C/C++
#          frontend will not build on this)
#
# Alpha:   Partial support claimed.  Native code generation exists but is
#          incomplete
#
# IA-64:   Partial support claimed.  Native code generation exists but is
#          incomplete

IUSE="debug alltargets"
# 'jit' is not a flag anymore.  at least on x86, disabling it saves nothing
# at all, so having it always enabled for platforms that support it is fine

# we're not mirrored, fetch from homepage
RESTRICT="mirror"

DEPEND="dev-lang/perl"
RDEPEND="dev-lang/perl"
PDEPEND=""
# note that app-arch/pax is no longer a dependency

S="${WORKDIR}/llvm-${PV}"

MY_LLVM_GCC_PREFIX=/usr/lib/llvm-gcc
# this same variable is located in llvm-gcc's ebuild; keep them in sync

pkg_setup() {
	# TODO: some version of GCC are known to miscompile LLVM, check for them
	# here.  (See docs/GettingStarted.html)

	# inherit toolchain-funcs
	# tc-getXX 
	# gcc-fullversion
	true
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# unfortunately ./configure won't listen to --mandir and the-like, so take
	# care of this.
	einfo "Fixing install dirs"
	sed -e 's,^PROJ_docsdir.*,PROJ_docsdir := $(DESTDIR)$(PROJ_prefix)/share/doc/'${PF}, \
		-e 's,^PROJ_etcdir.*,PROJ_etcdir := $(DESTDIR)/etc/llvm,' \
		-i Makefile.config.in || die "sed failed"

	# fix gccld and gccas, which would otherwise point to the build directory
	einfo "Fixing gccld and gccas"
	sed -e 's,^TOOLDIR.*,TOOLDIR=/usr/bin,' \
		-i tools/gccld/gccld.sh tools/gccas/gccas.sh || die "sed failed"

	# all binaries get rpath'd to a dir in the temporary tree that doesn't
	# contain libraries anyway; can safely remove those to avoid QA warnings
	# (the exception would be if we build shared libraries, which we don't)
	einfo "Fixing rpath"
	sed -e 's,-rpath \$(ToolDir),,g' -i Makefile.rules || die "sed failed"
}


src_compile() {
	local CONF_FLAGS=""

	if use debug; then
		CONF_FLAGS="${CONF_FLAGS} --disable-optimized"
		einfo "Note: Compiling LLVM in debug mode will create huge and slow binaries"
		# ...and you probably shouldn't use tmpfs, unless it can hold 900MB
	else
		CONF_FLAGS="${CONF_FLAGS} --enable-optimized"
	fi
	
	if use alltargets; then
		CONF_FLAGS="${CONF_FLAGS} --enable-targets=all"
	else
		CONF_FLAGS="${CONF_FLAGS} --enable-targets=host-only"
	fi

	# a few minor things would be built a bit differently depending on whether
	# llvm-gcc is already present on the system or not.  let's avoid that by
	# not letting it find llvm-gcc.  llvm-gcc isn't required for anything
	# anyway.  this dummy path will get spread to a few places, but none where
	# it really matters.
	CONF_FLAGS="${CONF_FLAGS} --with-llvmgccdir=/dev/null"

	econf ${CONF_FLAGS} || die "econf failed"
	emake tools-only || die "emake failed"
}

src_install()
{
	make DESTDIR="${D}" install || die "make install failed"

	# for some reason, LLVM creates a few .dir files.  remove them
	find "${D}" -name .dir -print0 | xargs -r0 rm

	# tblgen and stkrc do not get installed and wouldn't be very useful anyway,
	# so remove their man pages.  llvmgcc.1 and llvmgxx.1 are present here for
	# unknown reasons.  llvm-gcc will install proper man pages for itself, so
	# remove these strange thingies here.
	einfo "Removing unnecessary man pages"
	rm "${D}"/usr/share/man/man1/{tblgen,stkrc,llvmgcc,llvmgxx}.1

	# this also installed the man pages llvmgcc.1 and llvmgxx.1, which is a bit
	# a mistery because those binares are provided by llvm-gcc

	# llvmc makes use of the files in /etc/llvm to find programs to run; those
	# files contain markers that are meant to be replaced at runtime with
	# strings that were determined at llvm-base's compile time (odd isn't it?);
	# those strings will be empty in case llvm-base is built while llvm-gcc
	# doesn't exist yet (which is a common case).  to make things work in
	# either case, fix it by replacing the markers with hard strings of where
	# llvm-gcc will be in case it will be installed

	einfo "Configuring llvmc"

	for X in c c++ cpp cxx ll st; do
		sed -e "s,%cc1%,${MY_LLVM_GCC_PREFIX}/libexec/gcc/${CHOST}/4.0.1/cc1,g" \
			-e "s,%cc1plus%,${MY_LLVM_GCC_PREFIX}/libexec/gcc/${CHOST}/4.0.1/cc1plus,g" \
			-e "s,%llvmgccdir%,${MY_LLVM_GCC_PREFIX},g" \
			-e "s,%llvmgcclibexec%,${MY_LLVM_GCC_PREFIX}/libexec/gcc/${CHOST}/4.0.1,g" \
			-e "s,%bindir%,/usr/bin,g" \
			-i "${D}/etc/llvm/$X" || "sed failed"
	done
}

