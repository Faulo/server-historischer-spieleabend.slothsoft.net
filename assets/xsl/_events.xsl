<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:svg="http://www.w3.org/2000/svg" xmlns:sfs="http://schema.slothsoft.net/farah/sitemap"
	xmlns:sfd="http://schema.slothsoft.net/farah/dictionary" xmlns:sfm="http://schema.slothsoft.net/farah/module" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl"
	xmlns:lio="http://slothsoft.net" xmlns:func="http://exslt.org/functions" extension-element-prefixes="func" xmlns:ssh="http://schema.slothsoft.net/schema/historical-games-night">

	<xsl:import href="farah://slothsoft@historischer-spieleabend.slothsoft.net/xsl/functions" />

	<xsl:variable name="eventId" select="//sfs:page[@current]/@name" />
	<xsl:variable name="event" select="id($eventId)" />

	<xsl:template match="/*">
		<html>
			<head>
				<title data-dict="">title</title>
				<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=yes" />
				<link rel="icon" href="/favicon.ico" />
				<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css" integrity="sha384-GJzZqFGwb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS"
					crossorigin="anonymous" />
			</head>
			<body>
				<h1>Themenliste</h1>
				<div class="h3">
					<a href="/">Startseite</a>
					<xsl:text> | </xsl:text>
					<a href="/games/">Spieleliste</a>
				</div>
				<xsl:for-each select="//ssh:track">
					<xsl:sort select="@xml:id" />
					<xsl:variable name="track" select="." />
					<hr />
					<section>
						<details open="open">
							<summary class="h2">
								<xsl:value-of select="concat('[', @xml:id, 'xxx] ')" />
								<xsl:value-of select="@name" />
							</summary>
							<xsl:for-each select="ssh:subtrack">
								<xsl:variable name="id" select="concat($track/@xml:id, position())" />
								<details open="open">
									<summary class="h3">
										<xsl:value-of select="concat('[', $id, 'xx] ')" />
										<xsl:value-of select="@name" />
									</summary>
									<ul>
										<xsl:for-each select="//ssh:event[starts-with(@xml:id, $id)]">
											<xsl:sort select="@xml:id" />
											<li>
												<xsl:apply-templates select="." mode="global-link" />
											</li>
										</xsl:for-each>
									</ul>
								</details>
							</xsl:for-each>
						</details>
					</section>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>