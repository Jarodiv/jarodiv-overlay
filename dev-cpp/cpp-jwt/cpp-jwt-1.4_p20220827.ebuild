# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT_SHA="4b66cf74e5ece16e7f7e8c3d8c0c63d01b4cc9aa"

DESCRIPTION=" A little library built with lots of ❤︎ for working with JWT easier"
HOMEPAGE="https://github.com/arun11299/cpp-jwt"
SRC_URI="https://github.com/arun11299/cpp-jwt/archive/${COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/cpp-jwt-${COMMIT_SHA}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

BDEPEND+="
	test? (
		dev-cpp/gtest
	)
"

src_configure() {
	local mycmakeargs=(
		-DCPP_JWT_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
