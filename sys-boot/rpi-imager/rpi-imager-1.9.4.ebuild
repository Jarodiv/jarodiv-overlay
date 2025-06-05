# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Raspberry Pi Imaging Utility"
HOMEPAGE="https://github.com/raspberrypi/rpi-imager"
SRC_URI="https://github.com/raspberrypi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"
RESTRICT="mirror"

BDEPEND=">=dev-build/cmake-3.22"
DEPEND=">=app-arch/libarchive-3.8.0
        >=app-arch/xz-utils-5.8.1
        >=app-arch/zstd-1.5.7
        >=net-libs/nghttp2-1.65.0
        >=net-misc/curl-8.13.0
        dev-qt/qtbase:6[concurrent,gui,widgets,xml]
        dev-qt/qtdeclarative:6
        dev-qt/qtsvg:6
        net-libs/gnutls
        sys-fs/udisks:2
"
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${S}/src"

PATCHES=(
        "${FILESDIR}/use-system-dependencies--1.9.4.patch"
)

src_configure() {
        local mycmakeargs=(
                -DCMAKE_BUILD_TYPE=$(usex debug Debug Release)
        )

        cmake_src_configure
}