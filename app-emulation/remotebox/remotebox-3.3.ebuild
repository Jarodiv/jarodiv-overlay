# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

MY_P="RemoteBox-${PV}"

DESCRIPTION="Open Source VirtualBox Client with Remote Management"
HOMEPAGE="http://remotebox.knobgoblin.org.uk/"
SRC_URI="http://remotebox.knobgoblin.org.uk/downloads/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/7.0"
KEYWORDS="~amd64"
IUSE="gnome freerdp krdc tigervnc turbovnc rdesktop rdp remmina vnc"
REQUIRED_USE="
        freerdp? ( rdp )
        krdc? ( || ( rdp vnc ) )
        tigervnc? ( vnc )
        turbovnc? ( vnc )
        rdesktop? ( rdp )
        remmina? ( || ( rdp vnc ) )
        rdp? ( || ( freerdp krdc rdesktop remmina ) )
        vnc? ( || ( krdc remmina tigervnc turbovnc ) )
"

DEPEND=">=dev-lang/perl-5.10
        dev-perl/Gtk3
        dev-perl/SOAP-Lite
        x11-misc/xdg-utils
        freerdp? ( net-misc/freerdp )
        rdesktop? ( net-misc/rdesktop )
        tigervnc? ( net-misc/tigervnc )
        turbovnc? ( net-misc/turbovnc )
        krdc? ( || (
                rdp? ( kde-apps/krdc[rdp] )
                vnc? ( kde-apps/krdc[vnc] )
        ) )
        remmina? ( || (
                rdp? ( net-misc/remmina[rdp] )
                vnc? ( net-misc/remmina[vnc] )
        ) )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
        # Call default handler
        default

        # Change paths
        sed -i -e "s|^\(use lib \"\).*\(\";\)$|\1/usr/share/remotebox\2|" remotebox || die
        sed -i -e "s|^\(our \$sharedir = \"\).*\(\";\)$|\1/usr/share/remotebox\2|" remotebox || die
        sed -i -e "s|^\(our \$docdir\)  \( = \"\).*\(\";\)$|\1\2/usr/share/doc/${P}\3|" remotebox || die

        # Cleanup comments
        sed -i -e "/^# \^\^\^.*$/d" remotebox || die
        sed -i -e "/^# \*\*\*.*$/d" remotebox || die
}

src_install() {
        # Install executable
        dobin remotebox || die

        # Install resources
        insinto /usr && doins -r share || die

        # Install documents
        dodoc docs/COPYING docs/changelog.txt || die

        # Install .desktop file
        domenu packagers-readme/remotebox.desktop || die

        # Install application icon
        doicon share/remotebox/icons/remotebox.png || die
}

pkg_postinst() {
        elog "This version of RemoteBox requires VirtualBox 7.0.x running on the server"
        elog "For details, refer to http://remotebox.knobgoblin.org.uk/documentation.cgi"
}