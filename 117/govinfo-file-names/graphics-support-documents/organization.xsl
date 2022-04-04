<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:uslm="http://xml.house.gov/schemas/uslm/1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="uslm">

<xsl:output method="html" encoding="utf-8" />


<xsl:key name="s-head" match="uslm:property" use="@idref" />

<xsl:template match="processing-instruction()"/>

<xsl:template match="uslm:document">
	<html>
		<xsl:apply-templates/>
	</html>
</xsl:template>

<xsl:template match="uslm:document/uslm:meta">
	<head>
		<xsl:apply-templates select="dc:title"/>
		<link rel="stylesheet" href="graphics-support-documents/back.css" type="text/css"/>
	</head>
</xsl:template>

<xsl:template match="dc:title">
	<title>
		<xsl:apply-templates/>
	</title>
</xsl:template>

<xsl:template match="uslm:document/uslm:content">
	<body>
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates/>
	</body>
</xsl:template>


<xsl:template name="cut-in-head">
	<xsl:param name="e-name" select="'div'" />
	<xsl:for-each select="key('s-head', @id)">
		<xsl:element name="{$e-name}">
			<xsl:attribute name="class">
				<xsl:text>cut-in-head</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:for-each>
</xsl:template>


<!-- structure -->

<xsl:template match="uslm:level | uslm:section | uslm:subsection | uslm:paragraph | uslm:subparagraph">
	<section>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
			<xsl:if test="not(uslm:heading) and not(uslm:chapeau)">
				<xsl:text> no-heading</xsl:text>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='class')]"/>
		<xsl:call-template name="cut-in-head"/>
		<xsl:apply-templates/>
	</section>
</xsl:template>


<!-- blocks -->

<xsl:template match="uslm:note | uslm:quotedContent | uslm:content | uslm:section/uslm:heading| uslm:level/uslm:heading | uslm:subheading | uslm:crossHeading">
	<div>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
			<xsl:if test="@type">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@type"/>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='class')][not(name()='type')]"/>
		<xsl:apply-templates/>
	</div>
</xsl:template>


<!-- paragraphs -->

<xsl:template match="uslm:text | uslm:p">
	<p>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='class')]"/>
		<xsl:call-template name="cut-in-head">
			<xsl:with-param name="e-name" select="'span'" />
		</xsl:call-template>
		<xsl:apply-templates/>
	</p>
</xsl:template>

<xsl:template match="uslm:marker[@name='horizontal']">
	<hr class="{@class}"/>
</xsl:template>


<!-- defaults -->

<xsl:template match="@*">
	<xsl:copy />
</xsl:template>

<xsl:template match="uslm:i | uslm:sup">
	<xsl:element name="{local-name()}">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:element>
</xsl:template>

<xsl:template match="*">
	<span class="{local-name()}">
		<xsl:apply-templates select="@*|node()"/>
	</span>
</xsl:template>

</xsl:stylesheet>
