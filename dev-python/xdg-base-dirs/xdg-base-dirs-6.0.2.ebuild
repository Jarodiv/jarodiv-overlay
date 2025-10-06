# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python module to return paths to the directories defined by the XDG Base Directory Specification"
HOMEPAGE="
        https://pypi.org/project/xdg-base-dirs/
        https://github.com/srstevenson/xdg-base-dirs
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

distutils_enable_tests pytest