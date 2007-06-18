# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Altered from version 0.13.1 of Saleem Abdulrasool 
# by Tim Taubert and Michael Dehler.

inherit autotools eutils fdo-mime mono

DESCRIPTION="Integrated Development Environemnt for .NET"
HOMEPAGE="http://www.monodevelop.com/"
SRC_URI="http://www.go-mono.com/sources/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="boo firefox java nemerle seamonkey subversion"
# debugger

#		 debugger? ( >=dev-util/mono-debugger-0.9 )
RDEPEND=">=dev-lang/mono-1.1.10
		 >=dev-util/monodoc-1.0
		 >=dev-dotnet/gtk-sharp-2.8.0
		 >=dev-dotnet/gconf-sharp-2.4
		 >=dev-dotnet/glade-sharp-2.4
		 >=dev-dotnet/gnome-sharp-2.4
		 >=dev-dotnet/gecko-sharp-0.10
		 >=dev-dotnet/gtkhtml-sharp-2.4
		 >=dev-dotnet/gnomevfs-sharp-2.4
		 >=dev-dotnet/gtksourceview-sharp-0.10
		 boo? ( >=dev-lang/boo-0.7.6 )
		 java? ( || ( >=dev-dotnet/ikvm-bin-0.14 >=dev-dotnet/ikvm-0.14.0.1-r1 ) )
		 nemerle? ( >=dev-lang/nemerle-0.9.3.99 )
		 subversion? ( dev-util/subversion )

	 	 firefox? ( || ( www-client/mozilla-firefox www-client/mozilla-firefox-bin ) )
		 seamonkey? ( || ( www-client/seamonkey www-client/seamonkey-bin ) )"
DEPEND="${RDEPEND}
		  x11-misc/shared-mime-info
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.19"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PN}-0.14-configure.patch
	eautoreconf
}

src_compile() {
	econf --disable-update-mimedb    \
		  --disable-update-desktopdb \
		  --enable-monoextensions    \
		  --enable-versioncontrol    \
		  --enable-monoquery         \
		  --disable-aspnet           \
		  --disable-aspnetedit       \
		  $(use_enable boo)          \
		  $(use_enable java)         \
		  $(use_enable nemerle)      \
		  $(use_enable subversion)   \
	|| die "configure failed"

#		  $(use_enable debugger)     \

	emake -j1 || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc ChangeLog README
}

pkg_postinst() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
