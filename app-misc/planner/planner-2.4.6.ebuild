# Copyright 1999-2020 Gentoo Authors
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

DEPEND="x11-libs/gtk+:3
        dev-libs/libgee:0.8
        dev-libs/json-glib
        dev-db/sqlite:3
        net-libs/libsoup:2.4[vala]
        dev-libs/granite
        net-libs/webkit-gtk:4
        gnome-extra/evolution-data-server[vala]
        dev-libs/libical[vala]
        dev-util/meson
        >=dev-lang/vala-0.40.3"
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