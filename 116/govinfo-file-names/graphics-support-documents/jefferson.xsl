<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:uslm="http://xml.house.gov/schemas/uslm/1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:html="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="uslm">

<xsl:output method="html" encoding="utf-8" />

<xsl:key name="s-head" match="uslm:property" use="@idref" />

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
			<link rel="stylesheet" href="graphics-support-documents/jefferson.css" type="text/css"/>
		</head>
		<xsl:apply-templates select="uslm:content"/>
	</html>
</xsl:template>

<xsl:template match="uslm:document/uslm:content">
	<body>
		<xsl:apply-templates />
	</body>
</xsl:template>

<xsl:template match="uslm:section">
	<section class="{local-name()}">
		<xsl:apply-templates select="@*"/>
		<xsl:for-each select="key('s-head', @id)">
			<div class="cut-in-head">
				<xsl:apply-templates/>
			</div>
		</xsl:for-each>
		<div class="heading">
			<xsl:apply-templates select="uslm:num | uslm:heading"/>
		</div>
			<xsl:apply-templates select="*[not(self::uslm:num)][not(self::uslm:heading)]"/>
	</section>
</xsl:template>

<xsl:template match="@name">
	<xsl:attribute name="class">
		<xsl:value-of select="."/>
	</xsl:attribute>
</xsl:template>

<xsl:template match="uslm:num | uslm:heading">
	<span class="{local-name()}">
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template match="uslm:p | uslm:text">
	<p>
		<xsl:apply-templates select="@*"/>
		<xsl:for-each select="key('s-head', @id)">
			<span class="cut-in-head">
				<xsl:apply-templates/>
			</span>
		</xsl:for-each>
		<xsl:apply-templates/>
	</p>
</xsl:template>


<!-- blocks -->

<xsl:template match="uslm:note | uslm:quotedContent | uslm:level | uslm:content | uslm:crossHeading">
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



<!-- defaults -->

<xsl:template match="@*">
	<xsl:copy />
</xsl:template>

<xsl:template match="uslm:i | uslm:sup">
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
