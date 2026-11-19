# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
PYTHON_REQ_USE="ssl"

inherit python-single-r1

DESCRIPTION="Find and download subtitles for video files from OpenSubtitles"
HOMEPAGE="https://github.com/emericg/OpenSubtitlesDownload"
SRC_URI="https://github.com/emericg/OpenSubtitlesDownload/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OpenSubtitlesDownload-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnome kde"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	gnome? (
		gnome-extra/zenity
		net-misc/wget[ssl]
		sys-process/procps
	)
	kde? (
		kde-apps/kdialog
		sys-process/procps
	)
"

PATCHES=(
	"${FILESDIR}/${P}-backends.patch"
)

src_prepare() {
	default

	local gnome_enabled=False kde_enabled=False
	use gnome && gnome_enabled=True
	use kde && kde_enabled=True
	sed -i \
		-e "s/@GENTOO_GNOME@/${gnome_enabled}/" \
		-e "s/@GENTOO_KDE@/${kde_enabled}/" \
		OpenSubtitlesDownload.py || die
	python_fix_shebang OpenSubtitlesDownload.py
}

src_install() {
	newbin OpenSubtitlesDownload.py opensubtitlesdownload
	dodoc README.md
}
