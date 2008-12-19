# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils webapp depend.php depend.apache

DESCRIPTION="Tiny Tiny RSS - A web-based news feed (RSS/Atom) aggregator using AJAX"
HOMEPAGE="http://tt-rss.org/"
SRC_URI="http://tt-rss.org/download/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="mysql postgres"

need_httpd_cgi
need_php_httpd

pkg_setup() {
	webapp_pkg_setup
	if ! use mysql && ! use postgres ; then
		die "You must enable one of the two databases USE flags: mysql or postgres"
	fi
	if use mysql && use postgres ; then
		warn "You have both mysql and postgres USE flags set, mysql will be used"
	fi

	# check for required PHP features
	local flags=""
	use mysql && flags="${flags} mysql"
	use postgres && flags="${flags} postgres"
	if ! PHPCHECKNODIE="yes" require_php_with_use ${flags}; then
		die "Re-install ${PHP_PKG} with ${flags}"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# See http://tt-rss.org/forum/viewtopic.php?f=1&t=393
	epatch "${FILESDIR}/${P}_inofficial_libxml2_bug_workaround_magpierss.patch"
	epatch "${FILESDIR}/${P}_inofficial_libxml2_bug_workaround_simplepie.patch"

	# Customize config.php so that the right 'DB_TYPE' is already set (according to the USE flag(s))
	elog "Customizing config.php..."
	cp config.php-dist config.php
	local db_type=""
	# mysql preferred other postgresql
	if use mysql; then
		db_type="mysql";
	else
		if ! use mysql && use postgres; then
			db_type="pgsql"
		fi
	fi
	sed -e "s|define('DB_TYPE', \"pgsql\"); // or mysql$|define('DB_TYPE', \"${db_type}\"); // pgsql or mysql|" \
	    -i config.php
}

src_install () {
	webapp_src_preinst

	dodoc README
	rm -f README

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	dodir "${MY_HTDOCSDIR}"/icons

	webapp_serverowned "${MY_HTDOCSDIR}"/icons
	webapp_configfile "${MY_HTDOCSDIR}"/config.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
