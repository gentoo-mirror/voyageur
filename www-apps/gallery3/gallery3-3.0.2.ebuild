# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit webapp eutils depend.php

DESCRIPTION="Web based photo album organizer"
HOMEPAGE="http://gallery.menalto.com/"
SRC_URI="mirror://sourceforge/gallery/${P/y3/y}.zip"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+gd imagemagick mysql mysqli"

DEPEND=""
RDEPEND=">=dev-db/mysql-5.0
	>=dev-lang/php-5.2.3[ctype,gd?,filter,iconv,json,mysql?,mysqli?,simplexml,tokenizer]
	>=www-servers/apache-2.2
	imagemagick? ( || ( media-gfx/imagemagick
		media-gfx/graphicsmagick[imagemagick] ) )"

REQUIRED_USE="|| ( gd imagemagick )
	|| ( mysql mysqli )"

S=${WORKDIR}/${PN}

need_httpd_cgi
need_php_httpd

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	dodir "${MY_HTDOCSDIR}"/data

	dodir "${MY_HTDOCSDIR}"/var
	webapp_serverowned "${MY_HTDOCSDIR}"/var

	webapp_src_install
}
