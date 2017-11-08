<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:uslm="http://xml.house.gov/schemas/uslm/1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:html="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="uslm">

<xsl:output method="html" encoding="utf-8" />

<xsl:template match="uslm:document">
	<html>
		<head>
			<title>
				<xsl:apply-templates select="uslm:meta/dc:title/text()"/>
			</title>
			<link rel="stylesheet" href="front.css" type="text/css"/>
		</head>
		<xsl:apply-templates select="uslm:content"/>
	</html>
</xsl:template>

<xsl:template match="uslm:document/uslm:content">
	<body>
		<xsl:apply-templates />
	</body>
</xsl:template>

<xsl:template match="uslm:p | uslm:text">
	<p>
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates/>
	</p>
</xsl:template>


<!-- sections -->

<xsl:template match="uslm:level | uslm:resolution | uslm:toc">
	<section>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
			<xsl:if test="@name">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='class')][not(name()='name')]"/>
		<xsl:apply-templates/>
	</section>
</xsl:template>

<xsl:template match="uslm:heading">
	<header><xsl:apply-templates select="@*|node()"/></header>
</xsl:template>


<!-- blocks -->

<xsl:template match="uslm:docTitle | uslm:property[@name='chamber'] | uslm:content | uslm:date | uslm:signatures | uslm:signature | uslm:name | uslm:role | uslm:tocItem">
	<div>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
			<xsl:if test="@name">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='class')][not(name()='name')]"/>
		<xsl:apply-templates/>
	</div>
</xsl:template>


<!-- links -->

<xsl:template match="uslm:ref">
	<a>
		<xsl:apply-templates select="@*|node()"/>
	</a>
</xsl:template>

<xsl:template match="@idref">
	<xsl:attribute name="href">
		<xsl:text>#</xsl:text>
		<xsl:value-of select="."/>
	</xsl:attribute>
</xsl:template>


<!-- tables -->

<xsl:template match="uslm:layout">
	<table><xsl:apply-templates /></table>
</xsl:template>
<xsl:template match="uslm:row">
	<tr><xsl:apply-templates /></tr>
</xsl:template>
<xsl:template match="uslm:column">
	<td><xsl:apply-templates /></td>
</xsl:template>


<xsl:template match="uslm:marker[@name='horizontal']">
	<hr class="{@class}"/>
</xsl:template>


<!-- defaults -->

<xsl:template match="@*">
	<xsl:copy />
</xsl:template>

<xsl:template match="uslm:i | uslm:sup | uslm:img">
	<xsl:element name="{local-name()}">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:element>
</xsl:template>

<xsl:template match="html:*">
	<xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="uslm:*">
	<span class="{local-name()}">
		<xsl:apply-templates select="@*|node()"/>
	</span>
</xsl:template>

</xsl:stylesheet>
