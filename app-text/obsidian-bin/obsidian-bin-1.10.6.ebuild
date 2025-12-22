# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN%-bin*}"

inherit unpacker xdg

DESCRIPTION="Obsidian is a powerful knowledge base on top of a local folder of plain text Markdown files."
HOMEPAGE="https://obsidian.md/"
SRC_URI="https://github.com/obsidianmd/obsidian-releases/releases/download/v${PV}/${MY_PN}_${PV}_amd64.deb"

S="${WORKDIR}"

LICENSE="Obsidian-EULA"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""

src_install() {
        # files
        doins -r ${S}/*

        # permissions
        fperms 4755 /opt/Obsidian/chrome-sandbox || die
        fperms +x  /opt/Obsidian/obsidian || die

        # executable
        dosym /opt/Obsidian/obsidian /usr/bin/obsidian

        # Fix QA Notice: One or more compressed files were found in docompressed directories
        find "${D}/usr/share/doc" -name '*.gz' -exec gunzip {} \; || die

        # Fix QA Notice: The ebuild is installing to one or more unexpected paths: /usr/share/doc/obsidian
        mv "${D}/usr/share/doc/${MY_PN}" "${D}/usr/share/doc/${PF}" || die
}

pkg_postinst() {
        xdg_pkg_postinst
}

pkg_postrm() {
        xdg_pkg_postrm
}
