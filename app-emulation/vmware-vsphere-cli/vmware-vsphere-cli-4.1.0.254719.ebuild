# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils perl-module versionator

MY_PV=$(replace_version_separator 3 '-' )
MY_PN="VMware-vSphere-CLI-${MY_PV}"

DESCRIPTION="VMware vSphere Command-Line Interface"
HOMEPAGE="http://www.vmware.com/"
SRC_URI=" x86? ( http://mail.sootmonkey.com/${MY_PN}.i386.tar.gz )
		amd64? ( http://mail.sootmonkey.com/${MY_PN}.x86_64.tar.gz ) "

LICENSE="vmware"
IUSE=""
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
RESTRICT="strip"

DEPEND="
	>=dev-lang/perl-5
	dev-libs/expat
	dev-libs/glib
	dev-libs/libxml2
	dev-libs/openssl
	dev-perl/Archive-Zip
	dev-perl/Class-MethodMaker
	dev-perl/Crypt-SSLeay
	dev-perl/Data-Dump
	dev-perl/Data-Dumper-Concise
	dev-perl/HTML-Parser
	dev-perl/SOAP-Lite
	dev-perl/URI
	dev-perl/Data-UUID
	dev-perl/XML-LibXML
	dev-perl/XML-NamespaceSupport
	dev-perl/XML-SAX
	dev-perl/libwww-perl
	dev-perl/libxml-perl
	perl-core/Compress-Raw-Zlib
	perl-core/IO-Compress
	perl-core/version
	sys-fs/e2fsprogs
	sys-libs/zlib
	!=dev-perl/LWP-Protocol-https-6.30.0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-distrib

pkg_setup() {
	if use x86; then
		MY_P="${MY_PN}.i386"
	elif use amd64; then
		MY_P="${MY_PN}.x86_64"
	fi
}

src_prepare() {
	VMWARE_INSTALL_DIR=/opt/${PN//-//}

	shortname="vcli"
	product="vmware-vcli"
	config_dir="/etc/vmware-vcli"
	product_name="vSphere CLI"

	sed -i.bak -e "s:/sbin/lsmod:/bin/lsmod:" "${S}"/installer/services.sh || die "sed of services"

	# We won't want any perl scripts from VMware
	rm -f *.pl bin/*.pl
	rm -f etc/installer.sh

	epatch "${FILESDIR}"/makefile.patch

	perl-module_src_prepare || die
}

src_install() {
	# We loop through our directories and copy everything to our system.
	for x in apps bin
	do
		if [[ -e "${S}"/${x} ]]
		then
			dodir "${VMWARE_INSTALL_DIR}"/${x}
			cp -pPR "${S}"/${x}/* "${D}""${VMWARE_INSTALL_DIR}"/${x} || die "copying ${x}"
		fi
	done

	perl-module_src_install || die

	# init script
	if [[ -e "${FILESDIR}/${PN}.rc" ]]
	then
		newinitd "${FILESDIR}"/${PN}.rc ${product} || die "newinitd"
	fi

	# create the environment
	local envd="${T}/90vmware-cli"
	cat > "${envd}" <<-EOF
		PATH='${VMWARE_INSTALL_DIR}/bin'
		ROOTPATH='${VMWARE_INSTALL_DIR}/bin'
	EOF
	doenvd "${envd}"

	# Last, we check for any mime files.
	if [[ -e "${FILESDIR}/${PN}.xml" ]]
	then
		insinto /usr/share/mime/packages
		doins "${FILESDIR}"/${PN}.xml
	fi

	doman man/*
}

pkg_postinst() {
	elog "To fix \"Server version unavailable\" error messages, try to set:"
	elog "# export PERL_LWP_SSL_VERIFY_HOSTNAME=0"
}
