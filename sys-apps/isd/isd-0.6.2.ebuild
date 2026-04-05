# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit python-r1 xdg

DESCRIPTION="An interactive systemd TUI"
HOMEPAGE="
        https://kainctl.github.io/isd/
        https://isd-project.github.io/isd/
"
SRC_URI="https://github.com/isd-project/isd/archive/refs/tags/v${PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
        dev-python/build[${PYTHON_USEDEP}]
        dev-python/installer[${PYTHON_USEDEP}]
        dev-python/hatchling[${PYTHON_USEDEP}]
        dev-python/editables[${PYTHON_USEDEP}]
        dev-python/setuptools[${PYTHON_USEDEP}]
        dev-python/wheel[${PYTHON_USEDEP}]
"
RDEPEND="
        sys-apps/systemd
        ${PYTHON_DEPS}
        dev-python/pfzy[${PYTHON_USEDEP}]
        dev-python/pydantic[${PYTHON_USEDEP}]
        dev-python/pydantic-settings[${PYTHON_USEDEP}]
        dev-python/rich[${PYTHON_USEDEP}]
        dev-python/textual[${PYTHON_USEDEP}]
        dev-python/xdg-base-dirs[${PYTHON_USEDEP}]
        x11-themes/hicolor-icon-theme
"

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
        default
}

src_compile() {
        python_foreach_impl python3 -m build --wheel --no-isolation || die
}

src_install() {
        python_foreach_impl python3 -m installer --destdir="${D}" dist/*.whl || die

        dodoc README.md

        python_foreach_impl python_optimize
}

pkg_postinst() {
        xdg_icon_cache_update
}