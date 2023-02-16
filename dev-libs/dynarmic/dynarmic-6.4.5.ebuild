# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO:
# * ebuild for oaknut v1.1.4 (https://github.com/merryhime/oaknut.git)

EAPI=8

inherit cmake

DESCRIPTION="An ARM dynamic recompiler"
HOMEPAGE="https://github.com/MerryMage/dynarmic"
SRC_URI="https://github.com/merryhime/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="0BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-libs/boost:="
DEPEND="${RDEPEND}
	>=dev-cpp/catch-3.2.1
	>=dev-libs/libfmt-9.0.0
	>=dev-libs/mcl-0.1.12
	>=dev-libs/xbyak-6.68
	>=dev-libs/zydis-4.0.0
	dev-cpp/robin-map
	dev-libs/oaknut
"

PATCHES=(
	"${FILESDIR}/dynarmic-skip-bundled-dependencies.patch"
)

src_prepare() {
	cmake_src_prepare

	# Remaining:
	# * oaknut v1.1.4 (https://github.com/merryhime/oaknut.git)
	rm -r externals/{catch,fmt,mcl,oaknut,robin-map,xbyak,zycore,zydis} || die
}

src_configure() {
	local mycmakeargs=(
		-DDYNARMIC_SKIP_EXTERNALS=ON
		-DDYNARMIC_TESTS=$(usex test)
		-DDYNARMIC_WARNINGS_AS_ERRORS=OFF
	)
	cmake_src_configure
}
