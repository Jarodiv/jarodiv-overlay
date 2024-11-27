# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BUILD_DIR="${WORKDIR}/${P}-build"

inherit meson vala xdg

DESCRIPTION="Elementary OS library that extends GTK+"
HOMEPAGE="https://github.com/elementary/granite"
SRC_URI="https://github.com/elementary/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~x86"

BDEPEND="
        $(vala_depend)
        dev-lang/sassc
        dev-lang/vala
        virtual/pkgconfig
"

DEPEND="
        >=dev-build/meson-0.56.0
        >=dev-libs/glib-2.50:2
        >=gui-libs/gtk-4.4
        dev-libs/gobject-introspection
        dev-libs/libgee:0.8[introspection]
"

RDEPEND="${DEPEND}"

src_prepare() {
        default
}


src_configure() {
        # docs disabled due to: https://github.com/elementary/granite/issues/482
        local emesonargs=(
                -Ddocumentation=false
        )
        meson_src_configure
}

pkg_postinst() {
        xdg_icon_cache_update
}

pkg_postrm() {
        xdg_icon_cache_update
}