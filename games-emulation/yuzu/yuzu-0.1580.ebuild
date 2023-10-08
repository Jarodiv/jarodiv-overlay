# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Open-source, Nintendo Switch emulator"
HOMEPAGE="https://yuzu-emu.org/ https://github.com/yuzu-emu/yuzu-mainline"

MY_PV="mainline-${PV/./-}"
NX_TZDB_VERSION="220816"

SRC_URI="https://github.com/yuzu-emu/yuzu-mainline/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/lat9nq/tzdb_to_nx/releases/download/${NX_TZDB_VERSION}/${NX_TZDB_VERSION}.zip -> ${PN}-nx_tzdb-${NX_TZDB_VERSION}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cubeb +qt5 sdl +web-service"
REQUIRED_USE="|| ( qt5 sdl )"

DEPEND="
	<net-libs/mbedtls-3.1[cmac]
	>=app-arch/zstd-1.5
	>=dev-libs/dynarmic-6.4.7
	>=dev-libs/inih-52
	>=dev-libs/libfmt-9:=
	>=dev-libs/openssl-1.1:=
	>=dev-libs/xbyak-6.63
	>=dev-util/vulkan-headers-1.3.256
	>=media-video/ffmpeg-4.3:=
	>=net-libs/enet-1.3.17
	app-arch/lz4
	dev-cpp/cpp-httplib:0/0.12
	dev-cpp/cpp-jwt
	dev-libs/boost:=[context]
	dev-libs/sirit
	dev-libs/stb
	dev-libs/vulkan-memory-allocator
	media-libs/libva
	media-libs/mesa[vulkan]
	media-libs/opus
	media-libs/shaderc
	sys-libs/zlib
	virtual/libusb:1
	cubeb? ( >=media-libs/cubeb-0.2_p20230417 )
	qt5? (
		>=dev-qt/qtconcurrent-5.15:5
		>=dev-qt/qtcore-5.15:5
		>=dev-qt/qtgui-5.15:5
		>=dev-qt/linguist-tools-5.15:5
		>=dev-qt/qtmultimedia-5.15:5
		>=dev-qt/qtwebengine-5.15:5
	)
	sdl? (
		>=media-libs/libsdl2-2.28.2
	)
"
RDEPEND="
	${DEPEND}
	media-libs/vulkan-loader
"
BDEPEND="
	>=dev-cpp/nlohmann_json-3.8.0
	app-arch/unzip
	dev-cpp/robin-map
	dev-util/glslang
"

S="${WORKDIR}/${PN}-mainline-${MY_PV}"

PATCHES=(
	"${FILESDIR}/yuzu-skip-bundled-dependencies-1568.patch"
)

pkg_setup() {
	if tc-is-gcc; then
		[[ "$(gcc-major-version)" -lt 11 ]] && die "You need gcc version 11 or clang to compile this package"
	fi

	wget -O "${T}/compatibility_list.json" https://api.yuzu-emu.org/gamedb/ || die
}

src_prepare() {
	# Allow skip submodule downloading
	rm .gitmodules || die

	# Remove externals that have been replaced with dependencies
	rm --recursive "${S}/externals/"{SDL,Vulkan-Headers,cpp-httplib,cpp-jwt,cubeb,dynarmic,enet,ffmpeg,inih,libusb,mbedtls,opus,sirit,xbyak} || die

	mkdir -p "${S}_build/externals/nx_tzdb" || die
	cp "${DISTDIR}/${PN}-nx_tzdb-${NX_TZDB_VERSION}.zip" "${S}_build/externals/nx_tzdb/${NX_TZDB_VERSION}.zip" || die
	sed -re 's/set\(CAN_BUILD_NX_TZDB.*/set(CAN_BUILD_NX_TZDB false)/' -i externals/nx_tzdb/CMakeLists.txt || die

	cmake_src_prepare

	mkdir -p "${BUILD_DIR}/dist/compatibility_list" || die
	mv -f "${T}/compatibility_list.json" "${BUILD_DIR}/dist/compatibility_list/compatibility_list.json" || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_FULLNAME="${MY_PV}"
		-DBUILD_SHARED_LIBS=OFF
		-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF
		-DENABLE_CUBEB=$(usex cubeb)
		-DENABLE_LIBUSB=ON
		-DENABLE_QT=$(usex qt5)
		-DENABLE_QT_TRANSLATION=$(usex qt5)
		-DENABLE_SDL2=$(usex sdl)
		-DENABLE_WEB_SERVICE=$(usex web-service)
		-DGIT_BRANCH="${PN}"
		-DGIT_DESC="${PV}"
		-DGIT_REV="${PV}"
		-DUSE_DISCORD_PRESENCE=OFF
		-DYUZU_CHECK_SUBMODULES=OFF
		-DYUZU_TESTS=OFF
		-DYUZU_USE_EXTERNAL_SDL2=OFF
		-DYUZU_USE_EXTERNAL_VULKAN_HEADERS=OFF
		-DYUZU_USE_QT_MULTIMEDIA=ON
		-DYUZU_USE_QT_WEB_ENGINE=ON
	)

	cmake_src_configure
}