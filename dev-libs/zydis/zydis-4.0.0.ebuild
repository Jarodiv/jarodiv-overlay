# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fast and lightweight x86/x86-64 disassembler and code generation library"
HOMEPAGE="https://github.com/zyantific/zydis"
SRC_URI="https://github.com/zyantific/zydis/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND=">=dev-libs/zycore-1.4.0"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		# Fix 'relocation R_X86_64_PC32 against symbol `zydis_decoder_tree_root' can not be used when making a shared object; recompile with -fPIC'
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DZYAN_SYSTEM_ZYCORE=ON
	)
	cmake_src_configure
}