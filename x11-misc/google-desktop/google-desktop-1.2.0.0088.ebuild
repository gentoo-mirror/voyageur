# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils multilib rpm #mozextension

MY_PN=${PN}-linux

DESCRIPTION="Google Desktop"
HOMEPAGE="http://desktop.google.com/linux/"
SRC_URI="amd64? ( http://dl.google.com/linux/deb/pool/non-free/g/${MY_PN}/${MY_PN}_${PV}_amd64.deb )
	x86? ( http://dl.google.com/linux/deb/pool/non-free/g/${MY_PN}/${MY_PN}_${PV}_i386.deb )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="firefox thunderbird"
RESTRICT="strip"

RDEPEND="x11-libs/gtk+
	x11-libs/libXft"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

# Updated from bug #183492
xpi_install() {
	local emid

	# You must tell xpi_install which xpi to use
	[[ ${#} -ne 1 ]] && die "$FUNCNAME takes exactly one argument, please specify an xpi to unpack"

	x="${1}"
	cd ${x}
	# Determine install.rdf type & determine id for extension
	if grep -e 'xmlns:NC' ${x}/install.rdf; then
		emid=$(sed -n -e '/<\?em:id>\?/!d; s/.*\([\"{].*[}\"]\).*/\1/; s/\"//g; p; q' ${x}/install.rdf) \
		|| die "failed to determine extension id"
	else
		emid=$(tr -d "\n" < ${x}/install.rdf | sed -ne 's|<em:targetApplication>.*</em:targetApplication>||g; s|.*<em:id>\(.*\)</em:id>.*|\1|;p;q') \
		|| die "failed to determine extension id"
	fi
	insinto "${MOZILLA_FIVE_HOME}"/extensions/${emid}
	doins -r "${x}"/* || die "failed to copy extension"
}

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
	rm -f data.tar.gz 
}

src_install() {
	insinto /opt/google/desktop
	doins ${S}/opt/google/desktop/*

	exeinto /opt/google/desktop/bin
	doexe ${S}/opt/google/desktop/bin/*

	insinto /opt/google/desktop/resource
	doins ${S}/opt/google/desktop/resource/*

	insinto /opt/google/desktop/xdg
	doins ${S}/opt/google/desktop/xdg/*

	insinto /usr/bin
	dosym /opt/google/desktop/bin/gdlinux /usr/bin/gdlinux 

	into /opt/google/desktop
	dolib.so ${S}/opt/google/desktop/lib/*

	keepdir /var/cache/google/desktop
	fperms 777 /var/cache/google/desktop
	fperms o+t /var/cache/google/desktop

	insinto /usr/share/desktop-directories
	doins ${S}/opt/google/desktop/xdg/google-gdl.directory
	domenu ${S}/opt/google/desktop/xdg/google-gdl.desktop \ 
		${S}/opt/google/desktop/xdg/google-gdl-preferences.desktop

	# Install Extensions
	declare MOZILLA_FIVE_HOME
	if use firefox; then
		if has_version '>=www-client/mozilla-firefox-1.5'; then
			MOZILLA_FIVE_HOME="/usr/$(get_libdir)/mozilla-firefox"
			xpi_install ${S}/opt/google/desktop/plugin/firefox \
			|| die "xpi install for firefox failed!"
		fi
		if has_version '>=www-client/mozilla-firefox-bin-1.5'; then
			MOZILLA_FIVE_HOME="/opt/firefox"
			xpi_install ${S}/opt/google/desktop/plugin/firefox \
			|| die "xpi install for firefox-bin failed!"
		fi
	fi
	if use thunderbird; then
		if has_version '>=mail-client/mozilla-thunderbird-1.5'; then
			MOZILLA_FIVE_HOME="/usr/$(get_libdir)/mozilla-thunderbird"
			xpi_install ${S}/opt/google/desktop/plugin/thunderbird \
			|| die "xpi install for thunderbird failed!"
		fi
		if has_version '>=mail-client/mozilla-thunderbird-bin-1.5'; then
			MOZILLA_FIVE_HOME="/opt/thunderbird"
			xpi_install ${S}/opt/google/desktop/plugin/thunderbird \
			|| die "xpi install for thunderbird-bin failed!"
		fi
	fi
}
