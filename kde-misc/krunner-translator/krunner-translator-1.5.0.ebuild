# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"


DESCRIPTION="Plugin for Plasma 5 KRunner to translate text using Google Translate, Bing Translator, youdao, or Baidu Fanyi"
HOMEPAGE="https://github.com/naraesk/krunner-translator"
SRC_URI="https://github.com/naraesk/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="app-i18n/translate-shell
        dev-qt/qtwidgets:5
        dev-qt/qtcore:5
        dev-qt/qtlocation:5
        kde-frameworks/kconfigwidgets:5
        kde-frameworks/ki18n:5
        kde-frameworks/krunner:5
        kde-frameworks/kservice:5
        kde-frameworks/ktextwidgets:5
        sys-devel/gettext"
RDEPEND="${DEPEND}"

src_configure() {
        local mycmakeargs=(
                -DCMAKE_INSTALL_PREFIX=$(kf5-config --prefix)
                -DKDE_INSTALL_QTPLUGINDIR=$(kf5-config --qt-plugins)
                -DCMAKE_BUILD_TYPE=Release
        )
        cmake_src_configure
}

src_install() {
        cmake_src_install
}
