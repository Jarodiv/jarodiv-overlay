# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Puppet Development Kit"
HOMEPAGE="https://www.puppet.com/docs/pdk/latest/pdk"
SRC_URI="http://apt.puppetlabs.com/pool/bookworm/puppet-tools/${PN:0:1}/${PN}/${PN}_${PV}-1bookworm_amd64.deb"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="strip mirror"

DEPEND="sys-libs/libselinux
        virtual/libcrypt"
RDEPEND="${DEPEND}"

S=${WORKDIR}

QA_PREBUILT="
        /opt/puppetlabs/pdk
        /opt/puppetlabs/pdk/lib/engines/*
        /opt/puppetlabs/pdk/lib/*
        /opt/puppetlabs/pdk/bin/*"

src_prepare() {
        default

        # Remove broken libs to avoid QA errors
        rm opt/puppetlabs/pdk/private/ruby/*/lib/ruby/*/x86_64-linux/readline.so
}

src_install() {
        # Drop the opt folder into place
        insinto /opt
        doins -r opt/*

        # Ensure permissions
        find "${D}" -iwholename '*/bin/*' -exec chmod 0755 {} +
        chmod 0755 -R "${D}/opt/puppetlabs/pdk/private/git/lib/git-core/"

        # Add symlinks
        dosym /opt/puppetlabs/pdk/bin/pdk /usr/bin/pdk
}