# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2 python-distutils-ng

DESCRIPTION="A script that automatically downloads all images from a picasa web album"
HOMEPAGE="https://github.com/legoktm/picasa/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/legoktm/picasa.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-python/gdata"
RDEPEND="${DEPEND}"

