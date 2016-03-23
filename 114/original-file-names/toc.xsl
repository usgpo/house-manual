<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:uslm="http://xml.house.gov/schemas/uslm/1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="uslm">

<xsl:output method="html" encoding="utf-8" />

<xsl:template match="processing-instruction()"/>

<xsl:template match="/">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="uslm:document">
	<html>
		<head>
			<title>
				<xsl:apply-templates select="uslm:meta/dc:title/text()"/>
			</title>
			<link rel="stylesheet" href="toc.css" type="text/css"/>
		</head>
		<xsl:apply-templates select="uslm:content"/>
	</html>
</xsl:template>

<xsl:template match="uslm:document/uslm:content">
	<body>
		<xsl:apply-templates />
	</body>
</xsl:template>

<xsl:template match="uslm:document/uslm:content/uslm:heading">
	<h1>
		<xsl:apply-templates />
	</h1>
</xsl:template>

<xsl:template match="uslm:document/uslm:content/uslm:subheading">
	<h2>
		<xsl:apply-templates />
	</h2>
</xsl:template>

<xsl:template match="uslm:toc">
	<section>
		<xsl:apply-templates select="uslm:heading" />
		<ol>
			<xsl:apply-templates select="uslm:tocItem" />
		</ol>
	</section>
</xsl:template>

<xsl:template match="uslm:toc/uslm:heading">
	<h3>
		<a href="{../@identifier}">
			<xsl:apply-templates />
		</a>
	</h3>
</xsl:template>

<xsl:template match="uslm:tocItem">
	<li>
		<a>
			<xsl:attribute name="href">
				<xsl:choose>
					<xsl:when test="@identifier">
						<xsl:value-of select="@identifier"/>
					</xsl:when>
					<xsl:when test="@id">
						<xsl:value-of select="../@identifier"/>
						<xsl:text>#</xsl:text>
						<xsl:value-of select="@id"/>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates />
		</a>
	</li>
</xsl:template>

<xsl:template match="uslm:tocItem/uslm:heading">
	<span class="num">
		<xsl:apply-templates select="@*" />
		<xsl:apply-templates />
	</span>
</xsl:template>

<xsl:template match="uslm:tocItem/uslm:subheading">
	<span class="heading">
		<xsl:apply-templates />
	</span>
</xsl:template>

<xsl:template match="uslm:p">
	<div>
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates />
	</div>
</xsl:template>

<xsl:template match="@*">
	<xsl:copy />
</xsl:template>

</xsl:stylesheet>
