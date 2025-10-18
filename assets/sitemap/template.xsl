<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://schema.slothsoft.net/farah/sitemap" xmlns:sfd="http://schema.slothsoft.net/farah/dictionary"
	xmlns:sfm="http://schema.slothsoft.net/farah/module" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ssh="http://schema.slothsoft.net/schema/historical-games-night">
	<xsl:template match="/*">
		<domain name="historischer-spieleabend.slothsoft.net" vendor="slothsoft" module="historischer-spieleabend.slothsoft.net" ref="pages/home" status-active="" status-public=""
			sfd:languages="de-de" version="1.1">

			<page name="sitemap" ref="//slothsoft@farah/sitemap-generator" status-active="" />

			<file name="favicon.ico" ref="/logos/logo-small.png" status-active="" />

			<page name="manuals" redirect="/" status-active="">
				<xsl:for-each select="//*[@name = 'manuals']/sfm:manifest-info">
					<file name="{@name}" ref="/manuals/{@name}" status-active="" />
				</xsl:for-each>
			</page>

			<page name="gfx" redirect="/" status-active="">
				<xsl:for-each select="//*[@name = 'gfx']/sfm:manifest-info">
					<file name="{@name}" ref="/gfx/{@name}" status-active="" />
				</xsl:for-each>
			</page>

			<page name="events" ref="/pages/events" status-active="">
				<xsl:for-each select="*/ids/id">
					<xsl:sort select="@xml:id" />
					<file name="{@xml:id}" ref="/pages/event?name={@xml:id}" status-active="" />
				</xsl:for-each>
			</page>

			<page name="games" ref="/pages/games" status-active="" />

			<page name="backend" ref="/pages/backend" status-active="">
				<page name="Event" redirect="/" status-active="">
					<xsl:for-each select="//ssh:event[@xml:id != '']">
						<xsl:sort select="@xml:id" />
						<page name="{@xml:id}" ref="/pages/event-backend?name={@xml:id}" status-active="" />
					</xsl:for-each>
				</page>
			</page>

			<file name="logo-small.svg" ref="/logos/logo-small.svg" status-active="" />
			<file name="logo-gil.png" ref="/logos/GIL.png" status-active="" />
			<page name="downloads" ref="/pages/downloads" status-active="" />
		</domain>
	</xsl:template>
</xsl:stylesheet>
				