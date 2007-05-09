# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gnustep-funcs.eclass,v 1.12 2006/09/03 18:08:45 grobian Exp $

inherit toolchain-funcs eutils

###########################################################################
# IUSE="debug profile"
# - These USE variables are utilized here, but set in gnustep.eclass IUSE.
# - Packages that inherit this gnustep-funcs.eclass file to gain information
#    and access as to how GNUstep is deployed on the system can safely do so.
# - Packages built on the GNUstep libraries should inherit gnustep.eclass
#    directly (it inherits from this eclass as well)
###########################################################################

DESCRIPTION="EClass that centralizes access to GNUstep environment information."

###########################################################################
# Functions
# ---------

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

# Clean/reset an ebuild to the installed GNUstep evironment; generally,
#  this is called once an ebuild (at least), and packages that will
#  inherit from gnustep.eclass already do this
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
# Note: watch out for this one
# ~ and such must be enclosed in single-quotes when passed in
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
		eval emake ${__GS_MAKE_EVAL} ${gs_make_opts} all || die "package make failed"
	else
		die "no Makefile found"
	fi
	return 0
}

# Copies "convenience scripts"
egnustep_package_config() {
	if [ -f ${FILESDIR}/config-${PN}.sh ]; then
		dodir `egnustep_install_path`/Tools/Gentoo
		exeinto `egnustep_install_path`/Tools/Gentoo
		doexe ${FILESDIR}/config-${PN}.sh
	fi
}

# Informs user about existence of "convenience script"
egnustep_package_config_info() {
	if [ -f ${FILESDIR}/config-${PN}.sh ]; then
		einfo "Make sure to set happy defaults for this package by executing:"
		einfo "  `egnustep_install_path`/Tools/Gentoo/config-${PN}.sh"
		einfo "as the user you will run the package as."
	fi
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
		eval emake ${__GS_MAKE_EVAL} ${gs_make_opts} install || die "package install failed"
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
		eval emake ${__GS_MAKE_EVAL} ${gs_make_opts} all || die "doc make failed"
		eval emake ${__GS_MAKE_EVAL} ${gs_make_opts} install || die "doc install failed"
	fi
	cd ..
	return 0
}

