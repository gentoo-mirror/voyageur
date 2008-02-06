# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python

DESCRIPTION="Object-oriented python bindings for subversion"
HOMEPAGE="http://pysvn.tigris.org/"
SRC_URI="http://pysvn.tigris.org/files/documents/1233/38915/${P}.tar.gz"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="doc"
DEPEND="dev-lang/python
		>=dev-util/subversion-1.2.0"
RDEPEND="${DEPEND}"

src_compile() {
	cd ${S}/Source
	python setup.py configure || die "unable to configure"

	sed -e 's:^\(CCFLAGS=\)\(.*\):\1$(CFLAGS) \2:g' \
		-e 's:^\(CCCFLAGS=\)\(.*\):\1$(CXXFLAGS) \2:g' \
		-e 's:-lgssapi_krb5 -lkrb5 -lk5crypto -lkrb5support::g' \
		-i ${S}/Source/Makefile

	emake || die "Failed to make."
}

src_install() {
	python_version

	local base_dir=${S}/Source/pysvn
	local module_dir=/usr/lib/python${PYVER}/site-packages/pysvn
	
	exeinto ${module_dir}
	doexe ${base_dir}/_pysvn_${PYVER/./_}.so
	insinto ${module_dir}
	doins ${base_dir}/__init__.py

	if use doc; then
		for doc in `ls ${S}/Docs/*.{html,js}`; do
			dohtml $doc
		done
	fi
}
