# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Internal library providing platform independent types, macros and a fallback for environments without LibC"
HOMEPAGE="https://github.com/zyantific/zycore-c"
SRC_URI="https://github.com/zyantific/zycore-c/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/zycore-c-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"