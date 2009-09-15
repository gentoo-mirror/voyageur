# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

EAPI=2

inherit multilib

LLVM_GCC_VERSION=4.2
MY_PV=${LLVM_GCC_VERSION}-${PV/_pre}
LLVM_GCC_PREFIX=usr/$(get_libdir)/${PN}/${MY_PV}

DESCRIPTION="LLVM C front-end"
HOMEPAGE="http://llvm.org"
#SRC_URI="http://llvm.org/releases/${PV}/${PN}-${MY_PV}.source.tar.gz"
SRC_URI="http://llvm.org/prereleases/${PV/_pre}/${PN}-${MY_PV}.source.tar.gz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=sys-devel/llvm-$PV"
DEPEND="${RDEPEND}
	>=sys-apps/texinfo-4.2-r4
	>=sys-devel/binutils-2.18
	>=sys-devel/bison-1.875"
# test? ( sys-devel/autogen dev-util/dejagnu )

S=${WORKDIR}/llvm-gcc${MY_PV}.source

src_compile() {
	GCC_LANG="c,c++"
	PROGRAM_PREFIX=${PN}-${MY_PV}
	BUILDOPTIONS="LLVM_VERSION_INFO=${MY_PV}"
	TARGETOPTIONS=""

	#we keep the directory structure suggested by README.LLVM,
	mkdir -p obj "${D}"/${MY_LLVM_GCC_PREFIX}
	cd obj
	ECONF_SOURCE=${S} econf --prefix=/${LLVM_GCC_PREFIX} \
	--program-prefix=${PROGRAM_PREFIX}- \
	--enable-llvm=/usr --enable-languages=${GCC_LANG} \
	${TARGET_OPTIONS} || die "configure failed"
	# TODO use bootstrap?
	emake ${BUILDOPTIONS} || die "emake failed"
}

src_install() {
	cd obj
	emake DESTDIR="${D}" install || die "installation failed"
	#need no licence or fundin files, licences are kept separately
	llvm_man7=${D}/${LLVM_GCC_PREFIX}/man.man7
	rm -rf "${llvm_man7}"
	if ! use nls; then
		llvm_locales=${D}/${LLVM_GCC_PREFIX}/share/locale
		einfo "nls USE flag disabled, not installing ${llvm_locales}"
		rm -rf -- ${llvm_locales}
	fi
}
