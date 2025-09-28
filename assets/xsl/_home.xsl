<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:sfs="http://schema.slothsoft.net/farah/sitemap" xmlns:sfd="http://schema.slothsoft.net/farah/dictionary"
	xmlns:sfm="http://schema.slothsoft.net/farah/module" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl" xmlns:lio="http://slothsoft.net"
	xmlns:func="http://exslt.org/functions" extension-element-prefixes="func" xmlns:ssh="http://schema.slothsoft.net/schema/historical-games-night">

	<xsl:import href="farah://slothsoft@historischer-spieleabend.slothsoft.net/xsl/functions" />

	<xsl:template match="/*">
		<html>
			<head>
				<title data-dict="">title</title>
				<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=yes" />
				<link rel="icon" href="/favicon.ico" />
				<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css" integrity="sha384-GJzZqFGwb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS"
					crossorigin="anonymous" />

				<xsl:apply-templates select="//ssh:tracks" mode="style" />

				<!-- <xsl:copy-of select="." /> -->
			</head>
			<xsl:apply-templates select="." mode="body" />
		</html>
	</xsl:template>

	<xsl:template match="*" mode="body">
		<body>
			<xsl:apply-templates select="//ssh:tracks" mode="attributes" />
			<xsl:apply-templates select="//ssh:tracks" mode="form" />
			<xsl:for-each select="//ssh:present/ssh:event">
				<xsl:comment>
					<xsl:text>
Liebe Computerspielwissenschaftler\*innen! <![CDATA[<@&1039888687762243584>]]>
:joystick:~</xsl:text>
					<xsl:value-of select="position() + count(//ssh:past/ssh:event)" />
					<xsl:text>. Historische Spieleabend~:joystick:

Wann? Am </xsl:text>
					<xsl:value-of select="@date" />
					<xsl:text>-24:00 (s.t.)
Wo? Im Games Innovation Lab im Zapf
Wer? @</xsl:text>
					<xsl:value-of select="@moderator" />
					<xsl:text> moderiert!
Was? </xsl:text>
					<xsl:value-of select="@theme" />
					<xsl:text>
Wir spielen:
</xsl:text>
					<xsl:for-each select="ssh:game">
						<xsl:text>- **</xsl:text>
						<xsl:value-of select="@name" />
						<xsl:text>** (</xsl:text>
						<xsl:value-of select="@by" />
						<xsl:text>, </xsl:text>
						<xsl:value-of select="@from" />
						<xsl:text>)
</xsl:text>
					</xsl:for-each>
					<xsl:text>
Ihr seid alle herzlich eingeladen, aber lasst bitte ein :joystick: hier, wenn ihr kommen möchtet! :reblob:

Zukünftige Themen: </xsl:text>
					<xsl:value-of select="//sfs:domain/@url" />
					<xsl:text>?d
Zukünftigen Termine: https://calendar.google.com/calendar?cid=aGhrc3FxNDFsamlqYTJmYnZiZHVkcHEyOG9AZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ

</xsl:text>
				</xsl:comment>
			</xsl:for-each>

			<xsl:for-each select="//ssh:present/ssh:event">
				<div class="print poster">
					<h1>Historischer Spieleabend</h1>
					<h4>
						<xsl:value-of select="@theme" />
					</h4>
					<img class="logo" src="/logo-small.svg" />
					<h2>
						<xsl:value-of select="@date" />
						im GIL
					</h2>
					<xsl:if test="@gfx">
						<div class="event-left">
							<img class="icon" src="/gfx/{@gfx}" />
						</div>
					</xsl:if>
					<div class="event-right">
						<ul class="ludography">
							<xsl:for-each select="ssh:game">
								<li>
									<span class="title">
										<xsl:value-of select="@name" />
									</span>
									<xsl:text> </xsl:text>
									<span class="year">
										<xsl:text>(</xsl:text>
										<xsl:value-of select="@from" />
										<xsl:text>)</xsl:text>
									</span>
								</li>
							</xsl:for-each>
						</ul>
					</div>
					<img class="gil" src="/logo-gil.png" />
					<h3>
						<span class="box">
							<span>
								<large>2G</large>
								<small>(geimpft/genesen)</small>
							</span>
						</span>
					</h3>
				</div>
			</xsl:for-each>
			<div class="noprint">
				<h1 class="myBody" data-dict="">title</h1>
				<div class="h3">
					<a href="/events/">Themenliste</a>
					<xsl:text> | </xsl:text>
					<a href="/games/">Spieleliste</a>
				</div>
				<hr />
				<details class="present" open="open">
					<summary class="h2">
						Nächster Termin
					</summary>
					<div class="columns">
						<xsl:apply-templates select="//ssh:present/ssh:event" />
					</div>
				</details>
				<hr />
				<details class="future" open="open">
					<summary class="h2">
						Potentielle Themen
					</summary>
					<div class="flex">
						<xsl:apply-templates select="//ssh:future/ssh:event">
							<xsl:sort select="@xml:id" />
						</xsl:apply-templates>
					</div>
				</details>
				<hr />
				<details class="unfinished">
					<summary class="h2">
						Unfertige Themen
					</summary>
					<div class="flex">
						<xsl:apply-templates select="//ssh:unfinished/ssh:event">
							<xsl:sort select="@xml:id" />
						</xsl:apply-templates>
					</div>
				</details>
				<hr />
				<details>
					<summary class="h2">
						Noch nicht einsortierte Spiele
					</summary>
					<div class="flex">
						<xsl:apply-templates select="//ssh:unsorted/ssh:event">
							<xsl:sort select="@xml:id" />
						</xsl:apply-templates>
					</div>
				</details>
				<hr />
				<details>
					<summary class="h2">
						Dynamische Listen
					</summary>
					<div class="flex">
						<xsl:apply-templates select="//ssh:events/ssh:event">
							<xsl:sort select="@xml:id" />
						</xsl:apply-templates>
					</div>
				</details>
				<hr />
				<details class="past">
					<summary class="h2">
						Vergangene Themen
					</summary>
					<div class="flex">
						<xsl:apply-templates select="//ssh:past/ssh:event">
							<xsl:sort select="position()" order="ascending" data-type="number" />
						</xsl:apply-templates>
					</div>
				</details>
			</div>
		</body>
	</xsl:template>

	<xsl:template match="ssh:tracks" mode="style">
		<style type="text/css">
			<xsl:for-each select="ssh:track">
				<xsl:value-of select="concat('.event.', @xml:id, ' { background-color: #', @color, '; }
')" />

				<xsl:variable name="sum" select="100 div (@action + @adventure + @strategy)" />
				<xsl:variable name="t1" select="@action * $sum" />
				<xsl:variable name="t2" select="(@action + @adventure) * $sum" />
				<xsl:text>body[data-</xsl:text>
				<xsl:value-of select="@xml:id" />
				<xsl:text>="0"] article[id^="</xsl:text>
				<xsl:value-of select="@xml:id" />
				<xsl:text>"] { display: none; } </xsl:text>
			</xsl:for-each>
		</style>
	</xsl:template>

	<xsl:template match="ssh:tracks" mode="attributes">
		<xsl:for-each select="ssh:track">
			<xsl:attribute name="data-{@xml:id}">1</xsl:attribute>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="ssh:tracks" mode="form">
		<details class="tracks noprint">
			<summary>Verfügbare Kurse</summary>
			<small>(Doppelklicken um alle zu markieren)</small>
			<xsl:for-each select="ssh:track">
				<xsl:sort select="@name" />
				<div>
					<label
						ondblclick="
                            var c = !this.querySelector('input').checked;
                            document.querySelectorAll('input').forEach(i => i.checked = c);
                            document.querySelectorAll('input').forEach(i => i.onchange());
                        ">
						<input type="checkbox" name="{@xml:id}" checked="checked" onchange="document.body.setAttribute('data-' + this.name, this.checked ? '1' : '0')" />
						<span class="id">
							<xsl:value-of select="@xml:id" />
						</span>
						<xsl:text> </xsl:text>
						<xsl:value-of select="@name" />
					</label>
					<ul class="subtracks">
						<xsl:for-each select="ssh:subtrack">
							<li>
								<span class="id">
									<xsl:value-of select="concat(../@xml:id, position(), 'xx')" />
								</span>
								<xsl:text> </xsl:text>
								<xsl:value-of select="@name" />
							</li>
						</xsl:for-each>
					</ul>
				</div>
			</xsl:for-each>
		</details>
	</xsl:template>

	<xsl:template match="ssh:event">
		<article class="event {substring(@xml:id, 1, 3)}" id="{@xml:id}" data-genre="{substring(@xml:id, 1, 3)}" data-type="{@type}">
			<xsl:if test="@todo">
				<xsl:attribute name="data-todo" />
			</xsl:if>
			<xsl:if test="@todo">
				<xsl:attribute name="data-unavailable" />
			</xsl:if>
			<xsl:if test="@xml:id">
				<span style="float: left;">
					<xsl:text>[</xsl:text>
					<xsl:value-of select="@xml:id" />
					<xsl:text>]</xsl:text>
				</span>
			</xsl:if>
			<xsl:if test="@date != ''">
				<p class="date">
					<xsl:value-of select="@date" />
				</p>
			</xsl:if>
			<xsl:if test="@theme">
				<h2 class="myBody header">
					<xsl:if test="@xml:id">
						<span class="course-id" data-course="{lio:format-name(@xml:id)}">
							<xsl:apply-templates select="." mode="link" />
						</span>
					</xsl:if>
					<span class="theme">
						<xsl:value-of select="@theme" />
					</span>
					<xsl:if test="@rerun">
						<a href="#{@rerun}" class="rerun" title="{id(@rerun)/@date}">
							(RERUN)
						</a>
					</xsl:if>
					<xsl:if test="@twitter">
						<a href="https://twitter.com/{@twitter}" target="_blank">
							🕊️
						</a>
					</xsl:if>
				</h2>
			</xsl:if>

			<div class="tabled-content">
				<xsl:if test="@gfx">
					<div>
						<img class="icon" src="/gfx/{@gfx}" />
					</div>
				</xsl:if>
				<div>
					<xsl:if test="@moderator">
						<p class="moderator" data-moderator="{@moderator}">
							Moderator*in:
							<xsl:value-of select="@moderator" />
						</p>
					</xsl:if>
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
		<xsl:comment>
			@misc{
			<xsl:value-of select="@by" />
			.
			<xsl:value-of select="@from" />
			,
			author = {{
			<xsl:value-of select="@by" />
			}},
			year = {
			<xsl:value-of select="@from" />
			},
			title = {
			<xsl:value-of select="@name" />
			},
			organization = {
			<xsl:value-of select="@pub" />
			},
			howpublished = {
			<xsl:value-of select="@on" />
			}
			}
		</xsl:comment>
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
			<xsl:call-template name="wiki">
				<xsl:with-param name="term" select="@name" />
			</xsl:call-template>
		</span>
		<xsl:text>. </xsl:text>
		<xsl:if test="@version">
			<span class="version">
				<xsl:text> V. </xsl:text>
				<xsl:value-of select="@version" />
			</span>
			<xsl:text>. </xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="@href">
				<a href="{@href}" target="_blank" rel="external">
					<span class="platform">
						<xsl:text> [</xsl:text>
						<xsl:value-of select="@on" />
						<xsl:text>]</xsl:text>
					</span>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<span class="platform">
					<xsl:text> [</xsl:text>
					<xsl:value-of select="@on" />
					<xsl:text>]</xsl:text>
				</span>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>. </xsl:text>
		<xsl:if test="string-length(@manual)">
			<a class="manual" href="/manuals/{@manual}" target="_blank">📕</a>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
