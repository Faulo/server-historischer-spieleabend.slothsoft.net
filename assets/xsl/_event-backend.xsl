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

				<xsl:copy-of select="." />
			</head>
			<body onload="Array.from(document.querySelectorAll('select')).forEach(s => s.dispatchEvent(new Event('change')));">
				<div class="columns">
					<xsl:apply-templates select="$event" />
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="ssh:event">
		<article class="event {substring(@xml:id, 1, 3)}" id="{@xml:id}" data-genre="{substring(@xml:id, 1, 3)}" data-type="{@type}">
			<form method="POST" action=".">
				<p class="date">
					<input type="text" name="event[date]" value="{@date}" placeholder="Datum" />
				</p>
				<xsl:if test="@theme">
					<h2 class="myBody header">
						<xsl:if test="@xml:id">
							<span class="course-id" data-course="{lio:format-name(@xml:id)}" style="text-shadow: none !important">
								<xsl:value-of select="lio:format-name(@xml:id)" />
								<xsl:text>:</xsl:text>
							</span>
						</xsl:if>
						<span class="theme">
							<input type="text" name="event[theme]" value="{@theme}" placeholder="Thema" />
						</span>
					</h2>
					<label>
						Rerun von:
						<xsl:variable name="rerun" select="@rerun" />
						<select name="event[rerun]">
							<option></option>
							<xsl:for-each select="//ssh:track">
								<xsl:variable name="track" select="." />
								<xsl:for-each select="ssh:subtrack">
									<xsl:variable name="subtrack" select="concat($track/@xml:id, position())" />
									<optgroup label="[{$track/@xml:id} {position()}xx] {$track/@name} > {@name}">
										<xsl:for-each select="//ssh:event[starts-with(@xml:id, $subtrack)]">
											<xsl:sort select="@xml:id" />
											<option value="{@xml:id}">
												<xsl:if test="$rerun = @xml:id">
													<xsl:attribute name="selected">selected</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="concat('[', @xml:id, '] ', @theme)" />
											</option>
										</xsl:for-each>
									</optgroup>
								</xsl:for-each>
							</xsl:for-each>
						</select>
					</label>
				</xsl:if>

				<div class="tabled-content">
					<div>
						<select class="icon" name="event[gfx]" onchange="this.nextElementSibling.src = this.options[this.selectedIndex].dataset.src">
							<xsl:variable name="gfx" select="@gfx" />
							<option></option>
							<xsl:for-each select="//sfm:fragment-info[@name = 'gfx']/*">
								<option value="{@name}" data-src="{@href}">
									<xsl:if test="$gfx = @name">
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="@name" />
								</option>
							</xsl:for-each>
						</select>
						<img class="icon" src="/gfx/{@gfx}" />
					</div>
					<div>
						<p class="moderator">
							Moderator*in:
							<input type="text" name="event[moderator]" value="{@moderator}" placeholder="Gilbert" />
						</p>
						<ul class="ludography">
							<xsl:for-each select="ssh:game">
								<li>
									<xsl:if test="@wanted">
										<xsl:attribute name="data-wanted">
                                        <xsl:value-of select="@wanted" />
                                    </xsl:attribute>
									</xsl:if>
									<xsl:apply-templates select="." />
								</li>
							</xsl:for-each>
						</ul>
						<xsl:if test="ssh:read">
							<p class="reading">
								Required reading:
								<xsl:apply-templates select="ssh:read" />
							</p>
						</xsl:if>
					</div>
				</div>
				<button type="submit">Speichern</button>
			</form>
		</article>
	</xsl:template>

	<xsl:template match="ssh:req">
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="link" />
	</xsl:template>

	<xsl:template match="ssh:read">
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="link" />
	</xsl:template>

	<xsl:template match="ssh:game">
		<span class="Z3988-TODO">
			<xsl:attribute name="title">
                <xsl:value-of select="lio:param('ctx_ver', 'Z39.88-2004')" />
                <xsl:text>&amp;</xsl:text>
                <xsl:value-of select="lio:param('rft.title', @name)" />
                <xsl:text>&amp;</xsl:text>
                <xsl:value-of select="lio:param('rft.author', @by)" />
                <xsl:text>&amp;</xsl:text>
                <xsl:value-of select="lio:param('rft.pub', @by)" />
                <xsl:text>&amp;</xsl:text>
                <xsl:value-of select="lio:param('rft.date', @from)" />
                <xsl:text>&amp;</xsl:text>
                <xsl:value-of select="lio:param('rft.genre', 'misc')" />
                <xsl:text>&amp;</xsl:text>
                <xsl:value-of select="lio:param('rft.howpublished', @on)" />
            </xsl:attribute>
		</span>
		<span class="country">
			<xsl:choose>
				<xsl:when test="@country = 'ww'">
					<small>🌎</small>
				</xsl:when>
				<xsl:when test="@country = '?'">
					<small>❓</small>
				</xsl:when>
				<xsl:when test="string-length(@country)">
					<img src="https://cdn.rawgit.com/hjnilsson/country-flags/master/svg/{lio:toLowerCase(@country)}.svg" alt="{lio:toRegionCode(@country)}" />
				</xsl:when>
				<xsl:otherwise>
					<small>❔</small>
				</xsl:otherwise>
			</xsl:choose>
		</span>
		<xsl:text>&#160;</xsl:text>
		<span class="dev">
			<xsl:value-of select="@by" />
		</span>
		<xsl:text>. </xsl:text>
		<span class="year">
			<xsl:text>(</xsl:text>
			<xsl:value-of select="@from" />
			<xsl:text>)</xsl:text>
		</span>
		<xsl:text>. </xsl:text>
		<span class="title">
			<xsl:value-of select="@name" />
		</span>
		<xsl:text>. </xsl:text>
		<xsl:if test="@version">
			<span class="version">
				<xsl:text> V. </xsl:text>
				<xsl:value-of select="@version" />
			</span>
			<xsl:text>. </xsl:text>
		</xsl:if>
		<span class="platform">
			<xsl:text> [</xsl:text>
			<xsl:value-of select="@on" />
			<xsl:text>]</xsl:text>
		</span>
		<xsl:text>. </xsl:text>
	</xsl:template>

	<xsl:template match="ssh:event[disabled]">
		<rect x="0" y="0" width="1920" height="1080" fill="#ccc" />

		<text x="50%" y="0" style="fill:red; font-size: 50px;" text-anchor="middle">
			<xsl:value-of select="@date" />
		</text>

		<text x="50%" y="50" style="fill:red; font-size: 50px;" text-anchor="middle" dominant-baseline="middle">
			<xsl:value-of select="lio:format-name(string(@xml:id))" />
		</text>
		<xsl:if test="ssh:req">
			<p class="prereqs">
				Prereqs:
				<xsl:apply-templates select="ssh:req" />
			</p>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>