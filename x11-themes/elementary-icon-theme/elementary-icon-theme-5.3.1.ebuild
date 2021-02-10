# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson xdg-utils

DESCRIPTION="Elementary icon theme is designed to be smooth, sexy, clear, and efficient"
HOMEPAGE="https://github.com/elementary/icons"
SRC_URI="https://github.com/elementary/icons/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="x11-apps/xcursorgen"
RDEPEND=""

S="${WORKDIR}/icons-${PV}"

pkg_preinst() {
				gnome2_icon_savelist
}

pkg_postinst() {
				gnome2_icon_cache_update
        xdg_icon_cache_update
}

pkg_postrm() {
				gnome2_icon_cache_update
        xdg_icon_cache_update
}