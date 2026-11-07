# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit desktop python-single-r1 wrapper xdg

MY_TAG="$(ver_cut 1)-$(printf '%02d' $((10#$(ver_cut 2))))"
MY_TAG+="-$(printf '%02d' $((10#$(ver_cut 3))))"
MY_TAG+="-$(printf '%02d' $((10#$(ver_cut 4))))"

DESCRIPTION="PyQt6 desktop tool for bulk-editing tags of MP4 and MKV files"
HOMEPAGE="https://github.com/Erlbon/videoredactor"
SRC_URI="https://github.com/Erlbon/${PN}/archive/refs/tags/v${MY_TAG}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_TAG}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	media-video/ffmpeg
	media-video/mkvtoolnix
	$(python_gen_cond_dep '
		~dev-python/redactor-common-2026.10.25.1[${PYTHON_USEDEP}]
		dev-python/keyring[${PYTHON_USEDEP}]
		dev-python/pyqt6[${PYTHON_USEDEP},gui,multimedia,network,svg,widgets]
		dev-python/send2trash[${PYTHON_USEDEP}]
		media-libs/mutagen[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	test? (
		media-video/ffmpeg
		media-video/mkvtoolnix
		$(python_gen_cond_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2026.10.30.1-xdg-config-dir.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_test() {
	local -x QT_QPA_PLATFORM=offscreen
	"${EPYTHON}" -m pytest -q || die
}

src_install() {
	local appdir="/usr/share/${PN}"

	insinto "${appdir}"
	doins -r assets core gui videocli
	doins ABOUT.md CHANGELOG.md CREDITS.md main.py

	python_optimize "${ED}${appdir}"

	make_wrapper "${PN}" "${EPYTHON} main.py" "${appdir}"

	newicon assets/icon.png "${PN}.png"
	make_desktop_entry "${PN}" "The Ʌideo Redactor" "${PN}" "AudioVideo;Video;Qt;"

	dodoc README.md
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
