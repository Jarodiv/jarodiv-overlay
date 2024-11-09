# Copyright 1999-2024 Gentoo Authors
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

BDEPEND=">=dev-build/cmake-3.15"
DEPEND=">=app-arch/libarchive-3.7.4
        dev-qt/qtbase:6[concurrent,gui,widgets,xml]
        dev-qt/qtdeclarative:6
        dev-qt/qtsvg:6
        net-misc/curl
        net-libs/gnutls
        sys-fs/udisks:2
"
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${S}/src"

PATCHES=(
        "${FILESDIR}/0001-Use-system-dependencies-instead-of-bundled-ones.patch"
)

src_configure() {
        local mycmakeargs=(
                -DCMAKE_BUILD_TYPE=$(usex debug Debug Release)
        )

        cmake_src_configure
}