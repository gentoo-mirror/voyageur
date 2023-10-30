# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash@0.7.6
	aho-corasick@0.7.20
	autocfg@1.1.0
	bitflags@1.3.2
	cc@1.0.79
	cfg-if@1.0.0
	clap@4.1.10
	clap_derive@4.1.9
	clap_lex@0.3.3
	dlv-list@0.3.0
	errno-dragonfly@0.1.2
	errno@0.2.8
	getrandom@0.2.8
	glob@0.3.1
	hashbrown@0.12.3
	heck@0.4.1
	hermit-abi@0.3.1
	io-lifetimes@1.0.7
	is-terminal@0.4.4
	libc@0.2.139
	linux-raw-sys@0.1.4
	log@0.4.17
	memchr@2.5.0
	memoffset@0.7.1
	nix@0.26.2
	num_threads@0.1.6
	once_cell@1.17.1
	ordered-multimap@0.4.3
	os_str_bytes@6.4.1
	pin-utils@0.1.0
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.52
	quote@1.0.26
	regex-syntax@0.6.28
	regex@1.7.1
	rust-ini@0.18.0
	rustix@0.36.9
	serde@1.0.157
	static_assertions@1.1.0
	strsim@0.10.0
	syn@1.0.109
	termcolor@1.1.3
	time-core@0.1.0
	time-macros@0.2.8
	time@0.3.20
	unicode-ident@1.0.8
	users@0.11.0
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.45.0
	windows-targets@0.42.2
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_msvc@0.42.2
	windows_i686_gnu@0.42.2
	windows_i686_msvc@0.42.2
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_msvc@0.42.2
"

inherit cargo systemd

DESCRIPTION="Linux auto-suspend/wake power management daemon"
HOMEPAGE="https://github.com/mrmekon/circadian"
SRC_URI="
	https://github.com/mrmekon/circadian/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+=" MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X +network pulseaudio"

RDEPEND="
	X? (
		x11-misc/xprintidle
		x11-misc/xssstate
	)
	network? ( sys-apps/net-tools )
	pulseaudio? ( media-libs/libpulse )
"

src_install() {
	cargo_src_install

	systemd_dounit resources/${PN}.service
	insinto /etc
	newins resources/${PN}.conf.in ${PN}.conf
}
