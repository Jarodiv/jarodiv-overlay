# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN%-bin*}"

inherit desktop wrapper xdg

DESCRIPTION="Free universal database tool (community edition)."
HOMEPAGE="https://dbeaver.io/"
SRC_URI="https://dbeaver.io/files/${PV}/${MY_PN}-ce-${PV}-linux.gtk.x86_64.tar.gz -> ${P}-amd64.tar.gz"

LICENSE="Apache-2.0 EPL-1.0 BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
        sed -e "s/^Icon=.*/Icon=${MY_PN}/" \
                -e 's:/usr/share/dbeaver:/opt/dbeaver:g' \
                -e '/^WMCLASS.*/d' \
                -e "s:^Exec=.*:Exec=${EPREFIX}/usr/bin/${MY_PN}:" \
                -i "${MY_PN}-ce.desktop" || die
        default
}

src_install() {
        doicon -s 128 "${MY_PN}.png"
        newicon icon.xpm "${MY_PN}.xpm"

        domenu "${MY_PN}-ce.desktop"
        einstalldocs
        
        rm "${MY_PN}-ce.desktop" "${MY_PN}.png" icon.xpm readme.txt || die
        
        insinto "/opt/${MY_PN}-ce"
        doins -r *

        # Delete unnecessary libraries for other platforms
        find "${D}${JNA_PLUGIN_DIR}" -type d \( \
                -name "freebsd-*" -o \
                -name "sunos-*" -o \
                -name "linux-aarch64" -o \
                -name "linux-arm" -o \
                -name "linux-armel" -o \
                -name "linux-loongarch64" -o \
                -name "linux-mips64el" -o \
                -name "linux-ppc" -o \
                -name "linux-ppc64le" -o \
                -name "linux-riscv64" -o \
                -name "linux-s390x" \
        \) -exec rm -rf {} + || die

        fperms 0755 "/opt/${MY_PN}-ce/${MY_PN}"
        
        make_wrapper "${MY_PN}" "/opt/${MY_PN}-ce/${MY_PN}" "/opt/${MY_PN}-ce"
        sed -e "s:^exec /opt/${MY_PN}-ce/${MY_PN}:exec /opt/${MY_PN}-ce/${MY_PN} -vm ${EPREFIX}/opt/openjdk-bin-17/bin:" -i "${D}/usr/bin/${MY_PN}" || die
}