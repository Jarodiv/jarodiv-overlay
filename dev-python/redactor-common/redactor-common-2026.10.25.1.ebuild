# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

MY_PN=${PN/-/_}
MY_TAG="$(ver_cut 1)-$(printf '%02d' $((10#$(ver_cut 2))))"
MY_TAG+="-$(printf '%02d' $((10#$(ver_cut 3))))"
MY_TAG+="-$(printf '%02d' $((10#$(ver_cut 4))))"

DESCRIPTION="Shared PyQt6 UI and core logic for the Redactor family"
HOMEPAGE="https://github.com/Erlbon/redactor_common"
SRC_URI="https://github.com/Erlbon/${MY_PN}/archive/refs/tags/${MY_TAG}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${MY_TAG}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/keyring[${PYTHON_USEDEP}]
		dev-python/pyqt6[${PYTHON_USEDEP},gui,network,svg,widgets]
	')
"
BDEPEND="
	test? (
		$(python_gen_cond_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
