# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1
CRATES="
        bitflags@1.3.2
        cache-padded@1.2.0
        cc@1.0.73
        cmake@0.1.48
        cubeb-backend@0.10.3
        cubeb-core@0.10.3
        cubeb-sys@0.10.3
        libc@0.2.133
        pkg-config@0.3.25
        ringbuf@0.2.8
        semver@1.0.14"
inherit cargo cmake flag-o-matic

HASH_CUBEB=48689ae7a73caeb747953f9ed664dc71d2f918d8
HASH_PULSERS=cf48897be5cbe147d051ebbbe1eaf5fd8fb6bbc9

DESCRIPTION="Cross-platform audio library"
HOMEPAGE="https://github.com/mozilla/cubeb/"
SRC_URI="
        https://github.com/mozilla/cubeb/archive/${HASH_CUBEB}.tar.gz -> ${P}.tar.gz
        pulseaudio? ( rust? (
                https://github.com/mozilla/cubeb-pulse-rs/archive/${HASH_PULSERS}.tar.gz
                        -> ${PN}-pulse-rs-${HASH_PULSERS::10}.tar.gz
                ${CARGO_CRATE_URIS}
        ) )"
S="${WORKDIR}/${PN}-${HASH_CUBEB}"

LICENSE="ISC pulseaudio? ( rust? ( || ( Apache-2.0 MIT ) ) )"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="alsa doc jack pulseaudio +rust sndio test"
RESTRICT="!test? ( test )"

RDEPEND="
        media-libs/speexdsp
        alsa? ( media-libs/alsa-lib )
        jack? ( virtual/jack )
        pulseaudio? ( media-libs/libpulse )
        sndio? ( media-sound/sndio:= )"
DEPEND="
        ${RDEPEND}
        test? ( dev-cpp/gtest )"
BDEPEND="
        doc? ( app-doc/doxygen )
        pulseaudio? ( rust? ( ${RUST_DEPEND} ) )"

PATCHES=(
        "${FILESDIR}"/${PN}-0.2_p20211213-automagic.patch
)

src_unpack() {
        use pulseaudio && use rust && cargo_src_unpack || default
}

src_prepare() {
        if use pulseaudio && use rust; then
                mv ../${PN}-pulse-rs-${HASH_PULSERS} src/${PN}-pulse-rs || die
        fi

        cmake_src_prepare

        use !debug || sed -i 's|/release/|/debug/|' CMakeLists.txt || die
}

src_configure() {
        local mycmakeargs=(
                -DBUILD_RUST_LIBS=$(usex rust)
                -DBUILD_TESTS=$(usex test)
                -DBUILD_TOOLS=no # semi-broken without most backends and not needed
                -DCHECK_ALSA=$(usex alsa)
                -DCHECK_JACK=$(usex jack)
                -DCHECK_PULSE=$(usex pulseaudio)
                -DCHECK_SNDIO=$(usex sndio)
                -DLAZY_LOAD_LIBS=no
                -DUSE_SANITIZERS=no
                $(cmake_use_find_package doc Doxygen)
        )

        if use pulseaudio && use rust; then
                # undefined references with cubeb-core, often need to be filtered for
                # cmake bits as well if combined with rust in case of llvm mismatch
                filter-lto
                cargo_src_configure --manifest-path src/${PN}-pulse-rs/Cargo.toml
        fi

        cmake_src_configure
}

src_compile() {
        use pulseaudio && use rust && cargo_src_compile

        cmake_src_compile
}

src_test() {
        use pulseaudio && use rust && cargo_src_test

        # these tests need access to audio devices and no sandbox
        cmake_src_test -E '(audio|callback_ret|device_changed_callback|devices|duplex|latency|record|sanity|tone)'
}

src_install() {
        cmake_src_install

        use doc && dodoc -r "${BUILD_DIR}"/docs/html
}