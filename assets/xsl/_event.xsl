<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:sfs="http://schema.slothsoft.net/farah/sitemap" xmlns:sfd="http://schema.slothsoft.net/farah/dictionary"
	xmlns:sfm="http://schema.slothsoft.net/farah/module" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl" xmlns:lio="http://slothsoft.net"
	xmlns:func="http://exslt.org/functions" extension-element-prefixes="func">

	<xsl:import href="farah://slothsoft@historischer-spieleabend.slothsoft.net/xsl/functions" />

	<xsl:variable name="eventId" select="//sfs:page[@current]/@name" />
	<xsl:variable name="event" select="id($eventId)" />

	<xsl:template match="/*">
		<html>
			<head>
				<title>Historischer Spieleabend</title>
				<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=yes" />
				<link rel="icon" href="/favicon.ico" />
				<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css" integrity="sha384-GJzZqFGwb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS"
					crossorigin="anonymous" />

				<xsl:copy-of select="." />
			</head>
			<body>
				<xsl:choose>
					<xsl:when test="$event">
						<xsl:apply-templates select="$event" />
					</xsl:when>
					<xsl:otherwise>
						<h1>
							<xsl:text>Error: Failed to find event with ID '</xsl:text>
							<xsl:value-of select="$eventId" />
							<xsl:text>'.</xsl:text>
						</h1>
					</xsl:otherwise>
				</xsl:choose>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="event">
		<h1>
			<xsl:apply-templates select="." mode="link" />
		</h1>
		<xsl:if test="req">
			<p class="prereqs">
				Prereqs:
				<xsl:apply-templates select="req" />
			</p>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>