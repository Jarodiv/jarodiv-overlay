# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome2-utils meson vala xdg-utils

DESCRIPTION="Task manager with Todoist support designed for GNU/Linux"
HOMEPAGE="https://github.com/alainm23/planner"
SRC_URI="https://github.com/alainm23/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=dev-lang/vala-0.56.13
        >=dev-libs/granite-7.3.0
        >=dev-libs/gxml-0.20.0
        >=gnome-extra/evolution-data-server-3.45.1[vala]
        >=gui-libs/libadwaita-1.4.0
        dev-db/sqlite:3
        dev-libs/glib
        dev-libs/json-glib
        dev-libs/libgee:0.8
        dev-libs/libical[glib,vala]
        dev-libs/libportal[gtk,vala]
        dev-build/meson
        gui-libs/gtk
        gui-libs/gtksourceview
        net-libs/libsoup[vala]
        net-libs/webkit-gtk:6
        x11-themes/elementary-theme"
RDEPEND="${DEPEND}"

src_prepare() {
        vala_src_prepare
        default
}

src_configure() {
        meson_src_configure
}

src_install() {
        meson_src_install
}

pkg_postinst() {
        gnome2_schemas_update
        xdg_icon_cache_update
}

pkg_postrm() {
        gnome2_schemas_update
        xdg_icon_cache_update
}