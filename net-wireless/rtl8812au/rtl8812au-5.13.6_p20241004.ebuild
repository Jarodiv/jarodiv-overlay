# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info linux-mod

COMMIT="c01259932bfdee01e871b1468d4e75153fef1a12"

DESCRIPTION="Linux kernel driver for rtl8812au USB WiFi chipsets"
HOMEPAGE="https://github.com/morrownr/8812au-20210820"
SRC_URI="https://github.com/morrownr/8812au-20210820/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MODULE_NAMES="8812au(net/wireless:)"
BUILD_TARGETS="all"
DEPEND="!!net-wireless/rtl8812au_astsam
        !!net-wireless/rtl8812au_aircrack-ng"

S="${WORKDIR}/8812au-20210820-${COMMIT}"

pkg_setup() {
        linux-mod_pkg_setup
        #compile against selected (not running) target
	BUILD_PARAMS="KERN_DIR=${KV_DIR} KSRC=${KV_DIR} KERN_VER=${KV_FULL} O=${KV_OUT_DIR} V=1 KBUILD_VERBOSE=1 -Wno-error="
}

src_compile(){
        linux-mod_src_compile
}

src_install() {
        linux-mod_src_install
}

pkg_postinst() {
        linux-mod_pkg_postinst
}