<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl" xmlns:lio="http://slothsoft.net"
	xmlns:func="http://exslt.org/functions" xmlns:date="http://exslt.org/dates-and-times" extension-element-prefixes="func date" xmlns:ssh="http://schema.slothsoft.net/schema/historical-games-night"
	xmlns:sfd="http://schema.slothsoft.net/farah/dictionary">

	<xsl:import href="farah://slothsoft@farah/xsl/dictionary" />

	<xsl:variable name="LETTERS_LOWERCASE" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="LETTERS_UPPERCASE" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<xsl:variable name="LETTERS_REGION" select="'🇦🇧🇨🇩🇪🇫🇬🇭🇮🇯🇰🇱🇲🇳🇴🇵🇶🇷🇸🇹🇺🇻🇼🇽🇾🇿'" />

	<func:function name="lio:toRegionCode">
		<xsl:param name="region" />
		<func:result select="translate($region, $LETTERS_UPPERCASE, $LETTERS_REGION)" />
	</func:function>

	<func:function name="lio:toLowerCase">
		<xsl:param name="region" />
		<func:result select="translate($region, $LETTERS_UPPERCASE, $LETTERS_LOWERCASE)" />
	</func:function>

	<func:function name="lio:protectSpace">
		<xsl:param name="string" />
		<func:result select="translate($string, ' ', '&#xA0;')" />
	</func:function>

	<func:function name="lio:event-id">
		<xsl:param name="event" select="." />
		<xsl:variable name="subtrackId" select="$event/@track" />
		<xsl:variable name="timestamp" select="lio:timestamp($event/@date)" />
		<xsl:variable name="subtrack" select="//ssh:subtrack[@id = $subtrackId]" />
		<xsl:variable name="track" select="$subtrack/.." />
		<xsl:variable name="subtrackNumber" select="count($subtrack/preceding-sibling::ssh:subtrack) + 1" />
		<xsl:variable name="eventNumber" select="count(//ssh:event[@track = $subtrackId][lio:timestamp(@date) &lt; $timestamp] | preceding::ssh:event[@track = $subtrackId]) + 1" />

		<func:result select="concat($track/@id, $subtrackNumber, format-number($eventNumber, '00'))" />
	</func:function>

	<func:function name="lio:event-track">
		<xsl:param name="event" select="." />
		<xsl:variable name="subtrackId" select="$event/@track" />
		<xsl:variable name="timestamp" select="lio:timestamp($event/@date)" />
		<xsl:variable name="subtrack" select="//ssh:subtrack[@id = $subtrackId]" />
		<xsl:variable name="track" select="$subtrack/.." />
		<xsl:variable name="subtrackNumber" select="count($subtrack/preceding-sibling::ssh:subtrack) + 1" />
		<xsl:variable name="eventNumber" select="count(//ssh:event[@track = $subtrackId][lio:timestamp(@date) &lt; $timestamp] | preceding::ssh:event[@track = $subtrackId]) + 1" />

		<func:result select="concat($track/@name, ' ', $subtrackNumber, format-number($eventNumber, '00'), ' (', lio:protectSpace($subtrack/@name), ')')" />
	</func:function>

	<func:function name="lio:timestamp">
		<xsl:param name="date" />
		<xsl:choose>
			<xsl:when test="contains($date, '-')">
				<xsl:variable name="year" select="number(substring($date,1,4))" />
				<xsl:variable name="month" select="number(substring($date,6,2))" />
				<xsl:variable name="day" select="number(substring($date,9,2))" />
				<func:result select="365 * $year + 31 * $month + $day" />
			</xsl:when>
			<xsl:otherwise>
				<func:result select="0" />
			</xsl:otherwise>
		</xsl:choose>
	</func:function>

	<func:function name="lio:platform">
		<xsl:param name="id" select="." />
		<func:result select="//ssh:platform[@id = $id]" />
	</func:function>

	<func:function name="lio:subtrack">
		<xsl:param name="id" select="." />
		<func:result select="//ssh:subtrack[@id = $id]" />
	</func:function>

	<func:function name="lio:subtrack-name">
		<xsl:param name="id" select="." />
		<xsl:variable name="subtrack" select="//ssh:subtrack[@id = $id]" />
		<func:result select="concat($subtrack/../@name, ' - ', $subtrack/@name)" />
	</func:function>

	<func:function name="lio:event-datetime">
		<xsl:param name="event" select="." />

		<xsl:variable name="date" select="string($event/@date)" />

		<xsl:choose>
			<xsl:when test="contains($date, '-')">
				<xsl:variable name="year" select="number(substring($date,1,4))" />
				<xsl:variable name="month" select="number(substring($date,6,2))" />
				<xsl:variable name="day" select="number(substring($date,9,2))" />
				<func:result select="concat(sfd:lookup-text(date:day-name($date)), ', ', $day, '.', $month, '.', $year, ' ', $event/@time)" />
			</xsl:when>
			<xsl:otherwise>
				<func:result select="''" />
			</xsl:otherwise>
		</xsl:choose>
	</func:function>

	<xsl:variable name="action" select="'#ffa793'" />
	<xsl:variable name="adventure" select="'#fff293'" />
	<xsl:variable name="strategy" select="'#a5d0d4'" />
	<xsl:variable name="transition" select="7" />

	<func:function name="lio:toBackgroundColor">
		<xsl:param name="red" />
		<xsl:param name="green" />
		<xsl:param name="blue" />
		<func:result select="concat(lio:toBackgorundColorCode($red), ', ', lio:toBackgorundColorCode($green), ', ', lio:toBackgorundColorCode($blue))" />
	</func:function>
	<func:function name="lio:toBackgorundColorCode">
		<xsl:param name="likert" />
		<func:result select="128 + $likert * 24" />
	</func:function>

	<func:function name="lio:toFontColor">
		<xsl:param name="red" />
		<xsl:param name="green" />
		<xsl:param name="blue" />
		<func:result select="'250, 250, 255'" />
	</func:function>
	<func:function name="lio:toFontColorCode">
		<xsl:param name="likert" />
		<func:result select="$likert * 48" />
	</func:function>

	<xsl:template match="ssh:event" mode="link" />

	<xsl:template match="ssh:event[@track]" mode="link">
		<xsl:variable name="ref" select="lio:event-id()" />
		<a href="#{$ref}" class="id">
			<xsl:value-of select="lio:event-track()" />
			<xsl:text>:</xsl:text>
		</a>
	</xsl:template>

	<xsl:template match="ssh:event" mode="global-link" />

	<xsl:template match="ssh:event[@xml:id]" mode="global-link">
		<xsl:variable name="ref" select="string(@xml:id)" />
		<a href="/events/{$ref}" class="id" title="{lio:lookup-name($ref)}">
			<xsl:value-of select="concat('[', lio:format-id($ref), '] ')" />
			<xsl:value-of select="lio:lookup-name($ref)" />
		</a>
	</xsl:template>

	<xsl:template match="ssh:req" mode="link">
		<xsl:variable name="ref" select="string(@ref)" />
		<a href="#{$ref}" class="id" title="{lio:lookup-name($ref)}" onclick="document.querySelectorAll('h1 ~ details').forEach(d => d.open = true)">
			<xsl:attribute name="data-prereq">
                <xsl:if test="id($ref)/parent::ssh:future">missing</xsl:if>
            </xsl:attribute>
			<xsl:value-of select="lio:lookup-name($ref)" />
		</a>
	</xsl:template>

	<xsl:template match="ssh:read" mode="link">
		<a href="{@href}" target="_blank" rel="external">
			<xsl:value-of select="concat(@title, ' (', @author, ', ', @year, ')')" />
		</a>
	</xsl:template>

	<func:function name="lio:format-id">
		<xsl:param name="ref" />
		<xsl:variable name="id" select="substring($ref, 1, 3)" />
		<xsl:variable name="no" select="substring($ref, 4, 3)" />
		<xsl:variable name="name" select="//ssh:track[@xml:id=$id]/@name" />

		<func:result>
			<xsl:value-of select="$id" />
			<xsl:text>&#160;</xsl:text>
			<xsl:value-of select="$no" />
		</func:result>
	</func:function>

	<func:function name="lio:format-name">
		<xsl:param name="ref" />
		<xsl:variable name="id" select="substring($ref, 1, 3)" />
		<xsl:variable name="no" select="substring($ref, 4, 3)" />
		<xsl:variable name="track" select="//ssh:track[@xml:id=$id]" />
		<xsl:variable name="subtrack" select="$track/ssh:subtrack[position() = substring($no, 1, 1)]" />
		<func:result>
			<xsl:value-of select="$track/@name" />
			<xsl:text>&#160;</xsl:text>
			<xsl:value-of select="$no" />
			<xsl:if test="$subtrack">
				<xsl:text> (</xsl:text>
				<xsl:value-of select="$subtrack/@name" />
				<xsl:text>)</xsl:text>
			</xsl:if>
		</func:result>
	</func:function>

	<func:function name="lio:lookup-name">
		<xsl:param name="ref" />
		<xsl:variable name="id" select="substring($ref, 1, 3)" />
		<xsl:variable name="no" select="substring($ref, 4, 3)" />

		<func:result>
			<xsl:value-of select="lio:format-name($ref)" />
			<xsl:text>: </xsl:text>
			<xsl:value-of select="id($ref)/@theme" />
		</func:result>
	</func:function>

	<func:function name="lio:wiki">
		<xsl:param name="term" select="." />
		<func:result>
			<xsl:text>https://en.wikipedia.org/w/index.php?title=Special:Search&amp;search=</xsl:text>
			<xsl:value-of select="php:functionString('urlencode', normalize-space($term))" />
		</func:result>
	</func:function>

	<func:function name="lio:param">
		<xsl:param name="key" />
		<xsl:param name="val" />
		<func:result select="concat(php:functionString('urlencode', normalize-space($key)), '=', php:functionString('urlencode', normalize-space($val)))" />
	</func:function>

	<xsl:template name="wiki">
		<xsl:param name="term" select="." />
		<a href="{lio:wiki($term)}" target="_blank" rel="external">
			<xsl:value-of select="$term" />
		</a>
	</xsl:template>
</xsl:stylesheet>