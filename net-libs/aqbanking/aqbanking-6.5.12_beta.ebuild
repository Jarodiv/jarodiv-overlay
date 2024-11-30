# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV/_beta/beta}"

inherit autotools

DESCRIPTION="Generic Online Banking Interface"
HOMEPAGE="https://www.aquamaniac.de/sites/aqbanking/index.php"
SRC_URI="https://github.com/aqbanking/aqbanking/archive/refs/tags/${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="debug doc ebics examples ofx"

BDEPEND="
        sys-devel/gettext
        virtual/pkgconfig
        doc? ( app-text/doxygen )
"
DEPEND="
        app-misc/ktoblzcheck
        dev-libs/gmp:0=
        >=sys-libs/gwenhywfar-5.11.2_beta:=
        virtual/libintl
        ebics? ( dev-libs/xmlsec:=[gcrypt] )
        ofx? ( >=dev-libs/libofx-0.9.5:= )sys-libs/gwenhywfar
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
    default
    eautoreconf
}

src_configure() {
        local backends="aqhbci aqnone aqpaypal"
        use ofx && backends="${backends} aqofxconnect"
        use ebics && backends="${backends} aqebics"

        local myeconfargs=(
                --docdir="${EPREFIX}"/usr/share/doc/"${PF}"
                $(use_enable debug)
                $(use_enable doc full-doc)
                --with-backends="${backends}"
        )
        econf "${myeconfargs[@]}"
}

src_install() {
        emake DESTDIR="${D}" install

        rm -rv "${ED}"/usr/share/doc/ || die "Failed to remove docs"

        einstalldocs

        if use examples; then
                docinto tutorials
                dodoc tutorials/*.{c,h} tutorials/README
        fi

        find "${D}" -name '*.la' -type f -delete || die
}