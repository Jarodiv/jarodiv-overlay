# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A collection of C++20 utilities which is common to a number of merry's projects"
HOMEPAGE="https://github.com/merryhime/mcl"
SRC_URI="https://github.com/merryhime/mcl/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"