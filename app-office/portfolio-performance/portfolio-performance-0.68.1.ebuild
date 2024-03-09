# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Open source tool to calculate the overall performance of an investment portfolio."
HOMEPAGE="https://www.portfolio-performance.info/ https://github.com/portfolio-performance/portfolio"

SRC_URI="https://github.com/portfolio-performance/portfolio/releases/download/${PV}/PortfolioPerformance-${PV}-linux.gtk.x86_64.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/portfolio"

src_install() {
    insinto /opt/${PN}
    doins -r ${S}/*

    fperms +x /opt/${PN}/PortfolioPerformance
    dosym -r /opt/${PN}/PortfolioPerformance /usr/bin/PortfolioPerformance
}