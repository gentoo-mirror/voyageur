# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit autotools

MY_P="google-gadgets-for-linux-${PV}"
DESCRIPTION="Google desktop gadgets"
HOMEPAGE="http://code.google.com/p/google-gadgets-for-linux/"
SRC_URI="http://google-gadgets-for-linux.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk qt"

DEPEND="dev-lang/spidermonkey
	net-misc/curl
	dev-libs/libxml2
	sys-libs/zlib
	net-libs/xulrunner
	sys-apps/dbus
	media-libs/gstreamer
	media-libs/gst-plugins-base
	gtk? ( x11-libs/cairo x11-libs/gtk+ )
	qt? ( x11-libs/qt-webkit )"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${MY_P}

pkg_setup() {
	if built_with_use net-misc/curl gnutls; then
		eerror
		eerror "googlegadgets needs net-misc/curl with USE=-gnutls (for now)"
		eerror
		die "net-misc/curl rebuild needed"
	fi
}
src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-Werror.patch
	eautoreconf
}

src_compile() {
	econf $(use_enable gtk libggadget-gtk ) \
		$(use_enable gtk gtk-system-framework ) \
		$(use_enable gtk gtkmoz-browser-element ) \
		$(use_enable gtk gtk-host ) \
		$(use_enable qt libggadget-qt ) \
		$(use_enable qt qt-system-framework ) \
		$(use_enable qt qtwebkit-browser-element ) \
		$(use_enable qt qt-host ) \
	|| die "configuration failed"
	emake || die "compilation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed"

	# Desktop entries
	insinto /usr/share/icons/hicolor/32x32/apps
	newins resources/gadgets.png googlegadgets.png
	if use gtk; then
		make_desktop_entry "ggl-gtk" "Google Gadgets (GTK)" googlegadgets
		make_desktop_entry "ggl-gtk -s" "Google Gadgets (sidebar)" googlegadgets
	fi
	if use qt; then
		make_desktop_entry "ggl-qt" "Google Gadgets (QT)" googlegadgets
	fi


}
