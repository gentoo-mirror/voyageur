# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

DESCRIPTION="eclass for GNUstep Apps, Frameworks, and Bundles build"

# IUSE variables across all GNUstep packages
# "debug"	- enable code for debugging; also nostrip
# "profile"	- enable code for profiling; also nostrip
# "doc" - build and install documentation, if available
IUSE="debug profile doc"
if use debug || use profile; then
	RESTRICT="nostrip"
fi

# Dependencies
# Most .app should be set up this way:
#   + DEPEND="${GS_DEPEND} other/depend ..."
#   + RDEPEND="${GS_RDEPEND} other/rdepend ..."

# packages needed to build docs
DOC_DEPEND="doc? ( virtual/tetex
	=dev-tex/latex2html-2002*
	>=app-text/texi2html-1.64 )"
# packages needed to view docs
DOC_RDEPEND="doc? ( virtual/man
	>=sys-apps/texinfo-4.6 )"
# packages needed to build any gnustep package
GNUSTEP_CORE_DEPEND="virtual/libc
	>=sys-devel/gcc-3.3.5
	${DOC_DEPEND}"
# packages needed to utilize .debug apps
DEBUG_DEPEND="debug? ( >=sys-devel/gdb-6.0 )"

GS_DEPEND=">=gnustep-base/gnustep-env-0.2"
GS_RDEPEND="${GS_DEPEND}
	${DEBUG_DEPEND}
	${DOC_RDEPEND}"

# Ebuild function overrides
gnustep_pkg_setup() {
	if test_version_info 3.3
	then
		strip-unsupported-flags
	elif test_version_info 3.4
	then
		# strict-aliasing is known to break obj-c stuff in gcc-3.4*
		filter-flags -fstrict-aliasing
	fi

	# known to break ObjC (bug 86089)
	filter-flags -fomit-frame-pointer
}

gnustep_src_compile() {
	egnustep_env
	egnustep_make || die
}

gnustep_src_install() {
	egnustep_env
	egnustep_install || die
	if use doc ; then
		egnustep_env
		egnustep_doc || die
	fi
	# Copies "convenience scripts"
	if [ -f ${FILESDIR}/config-${PN}.sh ]; then
		dodir `egnustep_install_path`/Tools/Gentoo
		exeinto `egnustep_install_path`/Tools/Gentoo
		doexe ${FILESDIR}/config-${PN}.sh
	fi
}

gnustep_pkg_postinst() {
	# Informs user about existence of "convenience script"	
	if [ -f ${FILESDIR}/config-${PN}.sh ]; then
		einfo "Make sure to set happy defaults for this package by executing:"
		einfo "  `egnustep_install_path`/Tools/Gentoo/config-${PN}.sh"
		einfo "as the user you will run the package as."
	fi
}


######################################################################################
#TODO merge
######################################################################################

# Prints out the dirname of GNUSTEP_SYSTEM_ROOT, i.e., "System" is installed
#  in egnustep_prefix
egnustep_prefix() {
	# Generally, only gnustep-make should be the one setting this value
	if [ "$1" ]; then
		__GS_PREFIX="$(dirname $1/prune)"
		return 0
	fi

	if [ -f /etc/conf.d/gnustep.env ]; then
		. /etc/conf.d/gnustep.env
		if [ -z "${GNUSTEP_SYSTEM_ROOT}" ] || [ "/" != "${GNUSTEP_SYSTEM_ROOT:0:1}" ]; then
			die "Please check /etc/conf.d/gnustep.env for consistency or remove it."
		fi
		__GS_PREFIX=$(dirname ${GNUSTEP_SYSTEM_ROOT})
	elif [ -z "${__GS_PREFIX}" ]; then
		__GS_PREFIX="/usr/GNUstep"
		__GS_SYSTEM_ROOT="/usr/GNUstep/System"
	fi

	echo "${__GS_PREFIX}"
}

# Prints/sets the GNUstep install domain; Generally, this will only be
#  "System" or "Local"
egnustep_install_domain() {
	if [ -z "$1" ]; then
		echo ${__GS_INSTALL_DOMAIN}
		return 0
	fi

	if [ "$1" == "System" ]; then
		__GS_INSTALL_DOMAIN="SYSTEM"
	elif [ "$1" == "Local" ]; then
		__GS_INSTALL_DOMAIN="LOCAL"
	else
		die "An invalid parameter has been passed to ${FUNCNAME}"
	fi
}

# Prints the GNUstep install path
egnustep_install_path() {
	if [ "$__GS_INSTALL_DOMAIN" == "SYSTEM" ]; then
		echo "${__GS_SYSTEM_ROOT}"
	elif [ "$__GS_INSTALL_DOMAIN" == "LOCAL" ]; then
		echo "${__GS_LOCAL_ROOT}"
	fi
}

# Clean/reset an ebuild to the installed GNUstep environment
egnustep_env() {
	GNUSTEP_SYSTEM_ROOT="$(egnustep_prefix)/System"
	if [ -f ${GNUSTEP_SYSTEM_ROOT}/Library/Makefiles/GNUstep.sh ] ; then
		. ${GNUSTEP_SYSTEM_ROOT}/Library/Makefiles/GNUstep-reset.sh
		if [ -f /etc/conf.d/gnustep.env ]; then
			. /etc/conf.d/gnustep.env
		else
			GNUSTEP_SYSTEM_ROOT="/usr/GNUstep/System"
		fi
		. ${GNUSTEP_SYSTEM_ROOT}/Library/Makefiles/GNUstep.sh

		__GS_SYSTEM_ROOT=${GNUSTEP_SYSTEM_ROOT}
		__GS_LOCAL_ROOT=${GNUSTEP_LOCAL_ROOT}
		__GS_NETWORK_ROOT=${GNUSTEP_NETWORK_ROOT}
		__GS_USER_DIR=${GNUSTEP_USER_DIR}
		__GS_USER_DEFAULTS_DIR=${GNUSTEP_USER_DEFAULTS_DIR}

		# Set up common env vars for make operations
		__GS_MAKE_EVAL=" \
			HOME=\"\${T}\" \
			GNUSTEP_USER_DIR=\"\${T}\" \
			GNUSTEP_USER_DEFAULTS_DIR=\"\${T}\"/Defaults \
			DESTDIR=\"\${D}\" \
			GNUSTEP_INSTALLATION_DOMAIN=\"$(egnustep_install_domain)\" \
			GNUSTEP_MAKEFILES=\"\${GNUSTEP_SYSTEM_ROOT}\"/Library/Makefiles \
			TAR_OPTIONS=\"\${TAR_OPTIONS} --no-same-owner\" \
			-j1" # this is dirty!
	else
		die "gnustep-make not installed!"
	fi
}

# Get/Set the GNUstep system root
egnustep_system_root() {
	if [ "$1" ]; then
		__GS_SYSTEM_ROOT="$(dirname $1/prune)"
	else
		echo ${__GS_SYSTEM_ROOT}
	fi
}

# Get/Set the GNUstep local root
egnustep_local_root() {
	if [ "$1" ]; then
		__GS_LOCAL_ROOT="$(dirname $1/prune)"
	else
		echo ${__GS_LOCAL_ROOT}
	fi
}

# Get/Set the GNUstep network root
egnustep_network_root() {
	if [ "$1" ]; then
		__GS_NETWORK_ROOT="$(dirname $1/prune)"
	else
		echo ${__GS_NETWORK_ROOT}
	fi
}

# Get/Set the GNUstep user dir
egnustep_user_dir() {
	if [ "$1" ]; then
		__GS_USER_DIR="$(dirname $1/prune)"
	else
		echo ${__GS_USER_DIR}
	fi
}

# Make utilizing GNUstep Makefiles
egnustep_make() {
	if [ -f ./[mM]akefile -o -f ./GNUmakefile ] ; then
		local gs_make_opts="${1} messages=yes"
		if use debug ; then
			gs_make_opts="${gs_make_opts} debug=yes"
		fi
		if use profile; then
			gs_make_opts="${gs_make_opts} profile=yes"
		fi
		emake ${__GS_MAKE_EVAL} ${gs_make_opts} all || die "package make failed"
	else
		die "no Makefile found"
	fi
	return 0
}

# Make-install utilizing GNUstep Makefiles
egnustep_install() {
	if [ -f ./[mM]akefile -o -f ./GNUmakefile ] ; then
		local gs_make_opts="${1} messages=yes"
		if use debug ; then
			gs_make_opts="${gs_make_opts} debug=yes"
		fi
		if use profile; then
			gs_make_opts="${gs_make_opts} profile=yes"
		fi
		emake ${__GS_MAKE_EVAL} ${gs_make_opts} install || die "package install failed"
	else
		die "no Makefile found"
	fi
	return 0
}

# Make and install docs using GNUstep Makefiles
# Note: docs installed with this from a GNUMakefile,
#  not just some files in a Documentation directory
egnustep_doc() {
	cd ${S}/Documentation
	if [ -f ./[mM]akefile -o -f ./GNUmakefile ] ; then
		local gs_make_opts="${1} messages=yes"
		if use debug ; then
			gs_make_opts="${gs_make_opts} debug=yes"
		fi
		if use profile; then
			gs_make_opts="${gs_make_opts} profile=yes"
		fi
		emake ${__GS_MAKE_EVAL} ${gs_make_opts} all || die "doc make failed"
		emake ${__GS_MAKE_EVAL} ${gs_make_opts} install || die "doc install failed"
	fi
	cd ..
	return 0
}

EXPORT_FUNCTIONS pkg_setup src_compile src_install pkg_postinst
