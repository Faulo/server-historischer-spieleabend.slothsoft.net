<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:svg="http://www.w3.org/2000/svg" xmlns:sfs="http://schema.slothsoft.net/farah/sitemap"
	xmlns:sfd="http://schema.slothsoft.net/farah/dictionary" xmlns:sfm="http://schema.slothsoft.net/farah/module" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl"
	xmlns:lio="http://slothsoft.net" xmlns:func="http://exslt.org/functions" xmlns:set="http://exslt.org/sets" extension-element-prefixes="func set"
	xmlns:ssh="http://schema.slothsoft.net/schema/historical-games-night">

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
				<h1>Spieleliste</h1>
				<div class="h3">
					<a href="/">Startseite</a>
					<xsl:text> | </xsl:text>
					<a href="/events/">Themenliste</a>
				</div>
				<hr />
				<table border="1">
					<thead>
						<tr>
							<th data-sort-type="text">Spieltitel</th>
							<th data-sort-type="number">Jahr</th>
							<th data-sort-type="text">Entwickler</th>
							<th data-sort-type="text">Plattform</th>
							<th data-sort-type="text">Themen</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="//ssh:game">
							<xsl:variable name="game" select="." />
							<xsl:variable name="all" select="//ssh:game[@name = $game/@name and @from = $game/@from]" />
							<xsl:if test="generate-id($game) = generate-id($all[1])">
								<tr>
									<td>
										<xsl:for-each select="$game/@name">
											<xsl:call-template name="wiki" />
										</xsl:for-each>
									</td>
									<td>
										<xsl:for-each select="$game/@from">
											<xsl:value-of select="." />
										</xsl:for-each>
									</td>
									<td>
										<xsl:for-each select="set:distinct($all/@by)">
											<xsl:sort select="." />
											<xsl:if test="position() &gt; 1">
												<pre>ERROR: INCONSISTENT DATA!</pre>
											</xsl:if>
											<xsl:call-template name="wiki" />
										</xsl:for-each>
									</td>
									<td>
										<xsl:for-each select="set:distinct($all/@on)">
											<xsl:sort select="." />
											<xsl:if test="position() &gt; 1">
												<br />
											</xsl:if>
											<xsl:value-of select="." />

										</xsl:for-each>
									</td>
									<td>
										<ul>
											<xsl:for-each select="$all/..">
												<xsl:sort select="@xml:id" />
												<li>
													<xsl:apply-templates select="." mode="global-link" />
												</li>
											</xsl:for-each>
										</ul>
									</td>
								</tr>
							</xsl:if>
						</xsl:for-each>
					</tbody>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>