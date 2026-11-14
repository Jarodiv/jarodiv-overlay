# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk ur vi zh-CN zh-TW
"

inherit chromium-2 desktop unpacker xdg

DESCRIPTION="Desktop application for optimizing prompts for large language models"
HOMEPAGE="https://github.com/linshenkx/prompt-optimizer"
SRC_URI="
	https://github.com/linshenkx/prompt-optimizer/releases/download/v${PV}/PromptOptimizer-${PV}-linux-x64.zip
		-> ${P}-linux-x64.zip
	https://raw.githubusercontent.com/linshenkx/prompt-optimizer/v${PV}/packages/desktop/icons/512x512.png
		-> ${P}-icon.png
	https://raw.githubusercontent.com/linshenkx/prompt-optimizer/v${PV}/LICENSE
		-> ${P}-LICENSE
"
S="${WORKDIR}"

LICENSE="
	0BSD AGPL-3 Apache-2.0 BSD BSD-2 BSD-4 BlueOak-1.0.0 CC0-1.0
	GPL-2 ISC LGPL-2.1+ MIT PYTHON Unlicense WTFPL-2 ZLIB openssl
"
SLOT="0"
KEYWORDS="-* ~amd64"
REQUIRED_USE="elibc_glibc"
RESTRICT="strip"

BDEPEND="app-arch/unzip"

RDEPEND="
	app-accessibility/at-spi2-core
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa[opengl]
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	virtual/udev
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/pango
"

QA_PREBUILT="opt/${PN}/*"

pkg_pretend() {
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default

	[[ -x ${S}/PromptOptimizer ]] || die "Could not locate the PromptOptimizer executable in the release archive"
	[[ -d ${S}/locales ]] || die "Could not locate the bundled Chromium locales"
	pushd "${S}/locales" >/dev/null || die
	chromium_remove_language_paks
	popd >/dev/null || die
}

src_install() {
	dodir "/opt/${PN}"
	cp -pPR "${S}/." "${ED}/opt/${PN}" || die "Failed to install the application files"

	[[ -f ${ED}/opt/${PN}/chrome-sandbox ]] || die "Could not locate the bundled Chromium sandbox"
	fperms 0755 "/opt/${PN}" "/opt/${PN}/PromptOptimizer"
	fowners root "/opt/${PN}/chrome-sandbox"
	fperms 4711 "/opt/${PN}/chrome-sandbox"

	dosym -r "/opt/${PN}/PromptOptimizer" /usr/bin/prompt-optimizer
	newicon -s 512 "${DISTDIR}/${P}-icon.png" prompt-optimizer.png
	newmenu "${FILESDIR}/prompt-optimizer.desktop" prompt-optimizer.desktop
	dodoc "${DISTDIR}/${P}-LICENSE" LICENSE.electron.txt LICENSES.chromium.html
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Launch the application with prompt-optimizer or its desktop menu entry."
	elog "Application updates are managed through Portage, not the built-in updater."
}
