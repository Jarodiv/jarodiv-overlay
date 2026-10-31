# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="Enterprise wiki and knowledge-base application"
HOMEPAGE="https://www.xwiki.org/"
SRC_URI="https://nexus.xwiki.org/nexus/content/groups/public/org/xwiki/platform/xwiki-platform-distribution-war/${PV}/xwiki-platform-distribution-war-${PV}.war -> ${P}.war"
S="${WORKDIR}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+postgres +tomcat11 systemd"
RESTRICT="mirror"

RDEPEND="
	acct-group/xwiki
	acct-user/xwiki
	postgres? (
		dev-java/jdbc-postgresql:0
		|| (
			dev-db/postgresql:18
			dev-db/postgresql:17
			dev-db/postgresql:16
			dev-db/postgresql:15
			dev-db/postgresql:14
		)
	)
	tomcat11? (
		sys-apps/util-linux
		www-servers/tomcat:11
		>=virtual/jre-21:*
	)
"
DEPEND="
	postgres? (
		dev-java/jdbc-postgresql:0
	)
"
IDEPEND="
	acct-group/xwiki
	acct-user/xwiki
"
BDEPEND="
	acct-group/xwiki
	acct-user/xwiki
	app-arch/unzip
"

# Versioned payload directory
XWIKI_PAYLOADDIR="/usr/share/xwiki/${PVR}"
# Persistent state directory (managed by xwiki-deploy)
XWIKI_STATEDIR="/var/lib/xwiki"
# Runtime deployment directory (managed by xwiki-deploy)
XWIKI_RUNTIME="${XWIKI_STATEDIR}/deployments"
# Protected configuration directory
XWIKI_CONFDIR="/etc/xwiki"

src_unpack() {
	unzip -q "${DISTDIR}/${A}" -d "${S}" || die
}

src_install() {
	# Ship the two site-specific files as CONFIG_PROTECTed defaults, then symlink them back into WEB-INF
	diropts -m0750
	insopts -m0640
	insinto "${XWIKI_CONFDIR}"
	newins "${S}/WEB-INF/hibernate.cfg.xml" hibernate.cfg.xml
	newins "${S}/WEB-INF/xwiki.properties" xwiki.properties

	# Drop the originals from the unpacked tree so the payload ships symlinks to the protected copies instead of application-owned defaults
	rm "${S}/WEB-INF/xwiki.properties" "${S}/WEB-INF/hibernate.cfg.xml" || die

	# Conditional PostgreSQL JDBC support
	if use postgres; then
		# Symlink the Postgres JDBC driver, so it's always in sync with whatever dev-java/jdbc-postgresql currently has installed
		java-pkg_jar-from --into "${S}/WEB-INF/lib" jdbc-postgresql jdbc-postgresql.jar
	fi

	# Install the unpacked payload
	diropts -m0755
	insopts -m0644
	insinto "${XWIKI_PAYLOADDIR}"
	doins -r "${S}"/.

	# Re-create the removed configuration defaults as links to the protected /etc files
	dosym "${XWIKI_CONFDIR}/hibernate.cfg.xml" "${XWIKI_PAYLOADDIR}/WEB-INF/hibernate.cfg.xml"
	dosym "${XWIKI_CONFDIR}/xwiki.properties" "${XWIKI_PAYLOADDIR}/WEB-INF/xwiki.properties"

	# Set ownership for the payload
	fowners -R root:xwiki "${XWIKI_PAYLOADDIR}"
	fperms 0750 "${XWIKI_PAYLOADDIR}"

	# Install the deployment management tool
	exeinto /usr/libexec
	newexe "${FILESDIR}/xwiki-deploy" xwiki-deploy
	dosym ../libexec/xwiki-deploy /usr/sbin/xwiki-deploy

	# Conditional Tomcat integration
	if use tomcat11; then
		# XWiki service configuration and Context descriptor
		diropts -m0750
		insopts -m0640
		insinto "${XWIKI_CONFDIR}"
		newins "${FILESDIR}/xwiki.env" xwiki.env
		newins "${FILESDIR}/xwiki-context.xml" xwiki-context.xml

		# Install systemd service unit / OpenRC init.d script
		if use systemd; then
			insopts -m0644
			insinto /usr/lib/systemd/system
			newins "${FILESDIR}/xwiki.service" xwiki.service
		else
			newinitd "${FILESDIR}/xwiki.initd" xwiki
		fi
	fi

	# This package exclusively owns its configuration directory
	fowners -R root:xwiki "${XWIKI_CONFDIR}"

	# Create runtime directory structure with proper permissions
	keepdir "${XWIKI_RUNTIME}"
	fowners root:xwiki "${XWIKI_STATEDIR}" "${XWIKI_RUNTIME}"
	fperms 0750 "${XWIKI_STATEDIR}" "${XWIKI_RUNTIME}"
}

pkg_postinst() {
	einfo "XWiki ${PVR} payload has been installed to ${XWIKI_PAYLOADDIR}."
	einfo "Configuration files are in ${XWIKI_CONFDIR}."
	einfo " "
	einfo "If this is your first-time install, run:"
	einfo "  emerge --config =${CATEGORY}/${PF}"
	einfo " "
	einfo "Otherwise, to update your deployed installation, run:"
	einfo "  xwiki-deploy update"
}

pkg_config() {
	if [[ ${ROOT:-/} != / ]]; then
		eerror "pkg_config can only configure a live root filesystem."
		die "Unsupported ROOT for interactive instance configuration"
	fi

	if use tomcat11; then
		local tomcat_major=11
		local -r catalina_base="/var/lib/tomcat-${tomcat_major}-xwiki"
		local -r tomcat_conf="/etc/tomcat-${tomcat_major}-xwiki"
		local -r manager="/usr/share/tomcat-${tomcat_major}/gentoo/tomcat-instance-manager.bash"

		[[ -x ${manager} ]] || die "Tomcat instance manager not found: ${manager}"

		if [[ ! -e ${catalina_base} ]]; then
			einfo "Creating the dedicated Tomcat ${tomcat_major} instance for XWiki"
			"${manager}" --create --suffix xwiki --user xwiki --group xwiki || die "Failed to create Tomcat instance"

			# Clean up manager/host-manager/docs/examples apps we don't need
			rm --force --recursive \
				"${catalina_base}/webapps/ROOT" \
				"${tomcat_conf}/Catalina/localhost/manager.xml" \
				"${tomcat_conf}/Catalina/localhost/host-manager.xml" || die
		fi

		# Register the XWiki webapp with this instance
		local -r context_target="${XWIKI_CONFDIR}/xwiki-context.xml"
		local -r context_link="${tomcat_conf}/Catalina/localhost/xwiki.xml"

		chown --recursive root:xwiki "${tomcat_conf}" || die
		find "${tomcat_conf}" -type d -exec chmod 0750 {} + || die
		find "${tomcat_conf}" -type f -exec chmod 0640 {} + || die

		if [[ -L ${context_link} ]]; then
			[[ $(readlink -- "${context_link}") == "${context_target}" ]] || die "Unexpected target of existing ${context_link}"
		elif [[ -e ${context_link} ]]; then
			die "Refusing to replace existing ${context_link}"
		else
			ln --symbolic -- "${context_target}" "${context_link}" || die
		fi

		einfo "Tomcat instance is configured at '${catalina_base}'."
	else
		einfo "Tomcat integration disabled. Skipping instance creation."
	fi

	einfo " "
	einfo "Before starting XWiki:"
	if use postgres; then
		einfo "- Create the PostgreSQL role:"
		einfo "    su - postgres --command 'createuser xwiki --no-createdb --no-createrole --no-superuser --pwprompt'"
		einfo "- Create the PostgreSQL database:"
		einfo "    su - postgres --command \"psql --command \\\"CREATE DATABASE xwiki WITH OWNER xwiki ENCODING 'UTF8' LOCALE 'C.UTF-8' LOCALE_PROVIDER 'builtin' TEMPLATE template0;\\\"\""
		einfo "    su - postgres --command \"psql --command \\\"REVOKE ALL ON DATABASE xwiki FROM public;\\\"\""
	fi

	einfo "- Configure your Database connection details in '${XWIKI_CONFDIR}/hibernate.cfg.xml'"
	einfo "- Set 'environment.permanentDirectory' in '${XWIKI_CONFDIR}/xwiki.properties' (ensure the directory exists with xwiki:xwiki ownership)"

	if use tomcat11; then
		einfo "- Review the JVM heap settings in '${XWIKI_CONFDIR}/xwiki.env'"
		einfo " "
		einfo "Finally, to deploy your XWiki installation, run:"
		einfo "  xwiki-deploy update"
	fi
}

pkg_prerm() {
	if use tomcat11; then
		local tomcat_major=11
		local -r tomcat_conf="/etc/tomcat-${tomcat_major}-xwiki"

		# Do NOT touch runtime deployments, data or config - only the Context link we own
		if [[ -z ${REPLACED_BY_VERSION} && ${ROOT:-/} == / ]]; then
			local -r context_target="${XWIKI_CONFDIR}/xwiki-context.xml"
			local -r context_link="${tomcat_conf}/Catalina/localhost/xwiki.xml"

			if [[ -L ${context_link} && $(readlink -- "${context_link}") == "${context_target}" ]]; then
				rm --force "${context_link}" || die
			fi
		fi
	fi
}

pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		einfo "XWiki configuration, data and deployment snapshots may remain in:"
		einfo "  ${XWIKI_CONFDIR}"
		einfo "  /var/lib/xwiki"
		einfo " "
		einfo "After a backup, these can be removed manually:"
		einfo "  rm --force --recursive ${XWIKI_CONFDIR}"
		einfo "  rm --force --recursive /var/lib/xwiki"
	fi
}
