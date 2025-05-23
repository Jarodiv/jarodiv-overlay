# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="The Gtk+ Stylesheet for elementary OS"
HOMEPAGE="https://github.com/elementary/stylesheet"
SRC_URI="https://github.com/elementary/stylesheet/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-build/meson
        dev-lang/sassc"
RDEPEND="${DEPEND}"

S="${WORKDIR}/stylesheet-${PV}"