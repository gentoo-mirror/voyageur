# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit bash-completion multilib

DESCRIPTION="utility designed to install a minimal RPM-based distribution of GNU/Linux within a local directory"
HOMEPAGE="http://xen-tools.org/software/rinse/"
SRC_URI="http://xen-tools.org/software/rinse/${P}.tar.gz"

# "Like Perl itself"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-arch/rpm
	net-misc/wget"

src_prepare() {
	sed -e "s/lib/$(get_libdir)/g" -i Makefile || die "makefile sed failed"
}

src_install() {
	emake PREFIX="${D}" install || die "install failed"

	# bash-completion
	rm -r "${D}"/etc/bash_completion.d
	dobashcompletion misc/rinse
}
