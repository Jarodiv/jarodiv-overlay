# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson vala

DESCRIPTION="XML parser and writer, providing both Vala and C object oriented API through GObject"
HOMEPAGE="https://wiki.gnome.org/GXml"

SRC_URI="https://gitlab.gnome.org/GNOME/gxml/-/archive/${PV}/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
        dev-libs/libxml2
"
DEPEND="${RDEPEND}
        dev-lang/vala
        dev-libs/libgee
"

PATCHES=(
        "${FILESDIR}/fix_dependency-requirement-could-not-be-satisfied.patch"
)

src_prepare() {
        vala_setup
        default
}

src_configure() {
        meson_src_configure
}

src_install() {
        meson_src_install
}