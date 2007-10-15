# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Full sources including HRT patches"
HOMEPAGE="http://dev.gentoo.org/~angelos/"

KEYWORDS="~amd64"
IUSE=""

K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="1"
HRT_VER="2"
UNIPATCH_STRICTORDER="1"
ETYPE="sources"
inherit kernel-2

detect_version

UNIPATCH_LIST="${DISTDIR}/patch-${OKV}-hrt${HRT_VER}.patch.bz2"

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI}
	http://www.kernel.org/pub/linux/kernel/people/tglx/hrtimers/${OKV}/patch-${OKV}-hrt${HRT_VER}.patch.bz2"
