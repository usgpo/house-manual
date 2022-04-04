<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:uslm="http://xml.house.gov/schemas/uslm/1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:html="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="uslm dc html">

<xsl:output method="html" encoding="utf-8" />

<xsl:include href="back.xsl"/>

<xsl:template match="uslm:content">
	<div>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='class')]"/>
		<xsl:apply-templates/>
	</div>
</xsl:template>

<xsl:template match="uslm:block">
	<xsl:apply-templates select="*"/>
</xsl:template>

<xsl:template match="uslm:heading">
	<tr class="{parent::*/@class}">
		<xsl:if test="parent::uslm:block/@class = 'entry'">
			<xsl:copy-of select="parent::*/@id"/>
		</xsl:if>
		<th>
			<xsl:apply-templates/>
		</th>
	</tr>
</xsl:template>

<xsl:template match="uslm:header">
	<tr class="{parent::*/@class}">
		<xsl:apply-templates/>
	</tr>
</xsl:template>

<xsl:template match="uslm:header/uslm:column">
	<th class="{parent::*/@class}">
		<xsl:apply-templates select="@*|node()"/>
	</th>
</xsl:template>

<xsl:template match="uslm:row">
	<tr>
		<xsl:apply-templates select="@*|node()"/>
	</tr>
</xsl:template>
<xsl:template match="uslm:row[not(@class)]">
	<tr>
		<xsl:attribute name="class">
			<xsl:choose>
				<xsl:when test="../@class = 'entry'">subentry</xsl:when>
				<xsl:when test="../@class = 'subentry'">subsubentry</xsl:when>
				<xsl:when test="../@class = 'subsubentry'">subsubsubentry</xsl:when>
			</xsl:choose>
		</xsl:attribute>
		<xsl:apply-templates select="@*|node()"/>
	</tr>
</xsl:template>

<xsl:template match="uslm:block[@class='entry'][uslm:block[@class='subentry']]/uslm:row[@class='subentry']/uslm:column[1]">
	<td>
		<xsl:apply-templates select="@*"/>
		<xsl:attribute name="class">
			<xsl:if test="@class">
				<xsl:value-of select="@class" />
				<xsl:text></xsl:text>
			</xsl:if>
			<xsl:text>italic</xsl:text>
		</xsl:attribute>
		<xsl:apply-templates select="node()"/>
	</td>
</xsl:template>

<xsl:template match="uslm:block[@class='subentry']/uslm:header/uslm:column[1]">
	<th>
		<xsl:apply-templates select="@*"/>
		<xsl:attribute name="class">
			<xsl:if test="@class">
				<xsl:value-of select="@class" />
				<xsl:text></xsl:text>
			</xsl:if>
			<xsl:text>normal</xsl:text>
		</xsl:attribute>
		<xsl:apply-templates select="node()"/>
	</th>
</xsl:template>


</xsl:stylesheet>
