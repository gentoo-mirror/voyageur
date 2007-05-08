# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-make/gnustep-make-1.13.0.ebuild,v 1.3 2007/03/18 01:33:13 genone Exp $

inherit gnustep

DESCRIPTION="GNUstep Makefile Package"

HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
LICENSE="GPL-2"

IUSE="${IUSE} doc non-flattened layout-from-conf-file"
DEPEND="${GNUSTEP_CORE_DEPEND}
	>=sys-devel/make-3.75"
RDEPEND="${DEPEND}
	${DOC_RDEPEND}"

egnustep_install_domain "System"

pkg_setup() {
	gnustep_pkg_setup

	if ! built_with_use sys-devel/gcc objc; then
		ewarn "gcc must be compiled with Objective-C support! See the objc USE flag."
		die "ObjC support not available"
	fi

	# setup defaults here
	egnustep_prefix "/usr/GNUstep"
	egnustep_system_root "/usr/GNUstep/System"
	egnustep_local_root "/usr/GNUstep/Local"
	egnustep_network_root "/usr/GNUstep/Network"
	egnustep_user_dir 'GNUstep'

	elog "GNUstep installation will be laid out as follows:"
	elog "\tGNUSTEP_SYSTEM_ROOT=`egnustep_system_root`"
	elog "\tGNUSTEP_LOCAL_ROOT=`egnustep_local_root`"
	elog "\tGNUSTEP_NETWORK_ROOT=`egnustep_network_root`"
	elog "\tGNUSTEP_USER_DIR=`egnustep_user_dir`"
}

src_compile() {
	cd ${S}

	# gnustep-make ./configure : "prefix" here is going to be where
	#  "System" is installed -- other correct paths should be set
	#  by econf
	local myconf
	myconf="--prefix=`egnustep_prefix`"
	use non-flattened && myconf="$myconf --disable-flattened --enable-multi-platform"
	myconf="$myconf --with-tar=/bin/tar"
	myconf="$myconf --with-local-root=`egnustep_local_root`"
	myconf="$myconf --with-network-root=`egnustep_network_root`"
	myconf="$myconf --with-user-root=`egnustep_user_root`"
	econf $myconf || die "configure failed"

	egnustep_make
}

src_install() {
	. ${S}/GNUstep.sh

	local make_eval="INSTALL_ROOT=${D} \
		GNUSTEP_SYSTEM_ROOT=${D}$(egnustep_system_root) \
		GNUSTEP_NETWORK_ROOT=${D}$(egnustep_network_root) \
		GNUSTEP_LOCAL_ROOT=${D}$(egnustep_local_root) \
		GNUSTEP_MAKEFILES=${D}$(egnustep_system_root)/Library/Makefiles \
		GNUSTEP_USER_ROOT=${TMP} \
		GNUSTEP_DEFAULTS_ROOT=${TMP}/${__GS_USER_ROOT_POSTFIX} \
		-j1"

	local docinstall="GNUSTEP_INSTALLATION_DIR=${D}$(egnustep_system_root)"

	make_eval="${make_eval} GNUSTEP_INSTALLATION_DIR=${D}$(egnustep_system_root)"

	use debug && make_eval="${make_eval} debug=yes"
	use verbose && make_eval="${make_eval} verbose=yes"

	make ${make_eval} DESTDIR=${D} install \
		|| die "install has failed"

	if use doc ; then
		cd Documentation
		emake ${make_eval} all \
			|| die "doc make has failed"
		emake ${make_eval} DESTDIR=${D} ${docinstall} install \
			|| die "doc install has failed"
		cd ..
	fi

	dodir /etc/conf.d
	echo "GNUSTEP_SYSTEM_ROOT=$(egnustep_system_root)" > ${D}/etc/conf.d/gnustep.env
	echo "GNUSTEP_LOCAL_ROOT=$(egnustep_local_root)" >> ${D}/etc/conf.d/gnustep.env
	echo "GNUSTEP_NETWORK_ROOT=$(egnustep_network_root)" >> ${D}/etc/conf.d/gnustep.env
	echo "GNUSTEP_USER_DIR='$(egnustep_user_dir)'" >> ${D}/etc/conf.d/gnustep.env

	insinto /etc/GNUstep
	doins ${S}/GNUstep.conf

	exeinto /etc/profile.d
	doexe ${FILESDIR}/gnustep.sh
	doexe ${FILESDIR}/gnustep.csh
}

