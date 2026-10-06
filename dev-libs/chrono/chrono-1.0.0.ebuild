# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson vala

DESCRIPTION="A natural language date and time parser library for Vala/GLib applications"
HOMEPAGE="https://github.com/alainm23/chrono"
EGIT_REPO_URI="https://github.com/alainm23/chrono.git"
EGIT_COMMIT="${PV}"

LICENSE="GPL-3.0-or-later"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="docs"

BDEPEND="
	$(vala_depend)
	dev-build/meson
	dev-util/glib-utils
	virtual/pkgconfig
	docs? ( dev-lang/vala[valadoc] )
"

DEPEND="
	>=dev-libs/glib-2.70:2
	dev-libs/libgee:0.8
"

RDEPEND="${DEPEND}"

src_prepare() {
	vala_setup
	default
}

src_configure() {
	local emesonargs=(
		-Ddocs=$(usex docs true false)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}
