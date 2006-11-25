# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PN="HomePlayer"
DESCRIPTION="HomePlayer is a multimedia player which can stream multimedia files to the TV connected to a Freebox."
HOMEPAGE="http://homeplayer.free.fr/index.html"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
#KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-video/vlc-0.8.5"

pkg_setup() {
	#
	# Check if vlc is build with httpd, stream, ffmpeg, libmpeg and live use flags
	#
	if ! built_with_use -a media-video/vlc httpd stream ffmpeg mpeg live; then
		eerror "Please, add 'httpd stream ffmpeg mpeg live' to your USE flags and emerge vlc again."
		die "Homeplayer requires httpd stream ffmpeg mpeg and live support in vlc."
	fi
}

src_install() {
	#
	# Install HomePlayer in /opt/homeplayer/
	#
	dodir /opt/${PN}
	cp -R ${WORKDIR}/* ${D}/opt/${PN}

	#
	# Install the homeplayer executable in /usr/bin
	#
	exeinto /usr/bin
	doexe ${FILESDIR}/${PN}

	#
	# Create menu item
	#
	domenu ${FILESDIR}/${PN}.desktop
	doicon ${FILESDIR}/${PN}.png
}

pkg_postinst() {
	# Executable
	chmod 755 /opt/${PN}/${PN}.sh
	# Update directory & permissions
	mkdir -m 777 /opt/${PN}/update
}
