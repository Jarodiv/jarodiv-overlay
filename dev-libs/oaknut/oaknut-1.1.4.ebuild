# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A C++20 assembler for AArch64 (ARMv8.0 to ARMv8.2)"
HOMEPAGE="https://github.com/merryhime/oaknut"
SRC_URI="https://github.com/merryhime/oaknut/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/oaknut-enable-skip-tests.patch"
)

src_configure() {
	local mycmakeargs=(
		-DWITH_TEST=OFF
	)
	cmake_src_configure
}