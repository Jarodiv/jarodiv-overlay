# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome2-utils meson vala xdg-utils

COMMIT="adf3629bcacfc9978f6dde5b87eff0278533ab3e"

DESCRIPTION="Task manager with Todoist support designed for GNU/Linux"
HOMEPAGE="https://github.com/alainm23/planner"
SRC_URI="https://github.com/alainm23/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-db/sqlite:3
        dev-lang/vala
        dev-libs/glib
        dev-libs/granite:0/7.3.0
        dev-libs/json-glib
        dev-libs/libgee:0.8
        dev-libs/libical[glib,vala]
        dev-libs/libportal[gtk,vala]
        dev-util/meson
        gui-libs/gtk
        gui-libs/libadwaita
        net-libs/libsoup[vala]
        net-libs/webkit-gtk:6
        x11-themes/elementary-theme
        >=gnome-extra/evolution-data-server-3.45.1[vala]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

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