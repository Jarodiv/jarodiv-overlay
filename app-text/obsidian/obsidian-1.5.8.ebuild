# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Obsidian is a powerful knowledge base on top of a local folder of plain text Markdown files."
HOMEPAGE="https://obsidian.md/"
SRC_URI="https://github.com/obsidianmd/obsidian-releases/releases/download/v${PV}/${PN}_${PV}_amd64.deb"

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
}
