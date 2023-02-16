# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake vcs-snapshot

COMMIT_SHA="d7ad93a88864bda94e282e95028f90b5784e4d20"

DESCRIPTION="A runtime SPIR-V assembler"
HOMEPAGE="https://github.com/ReinUsesLisp/sirit"
SRC_URI="https://github.com/ReinUsesLisp/sirit/archive/${COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-util/spirv-headers"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DSIRIT_USE_SYSTEM_SPIRV_HEADERS=ON
	)
	cmake_src_configure
}

src_install() {
	dodoc LICENSE.txt README.md
	dolib.so "${BUILD_DIR}/src/libsirit.so"
	doheader -r include/sirit
}
