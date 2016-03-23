<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:uslm="http://xml.house.gov/schemas/uslm/1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:html="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="uslm dc html">

<xsl:output method="html" encoding="utf-8" />

<xsl:include href="house.xsl"/>

<xsl:template match="uslm:toc">
	<header>
		<xsl:apply-templates select="uslm:heading"/>
	</header>
	<ol>
		<xsl:apply-templates select="uslm:tocItem"/>
	</ol>
</xsl:template>

<xsl:template match="uslm:tocItem[not(uslm:heading)]">
	<li>
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates select="uslm:content/*[not(@name='number')]"/>
	</li>
</xsl:template>

<xsl:template match="uslm:tocItem[uslm:heading]">
	<li>
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates select="uslm:heading/*[not(@name='number')]"/>
		<ol>
			<xsl:apply-templates select="*[not(self::uslm:heading)]"/>
		</ol>
	</li>
</xsl:template>


<xsl:template match="uslm:document/uslm:content/uslm:level/uslm:level[not(@name = 'toc')]">
	<section>
		<xsl:apply-templates select="@*"/>
		<header>
			<xsl:apply-templates select="uslm:heading/@*"/>
			<xsl:apply-templates select="uslm:num"/>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="uslm:heading"/>
		</header>
		<xsl:apply-templates select="node()[not(self::uslm:num)][not(self::uslm:heading)]"/>
	</section>
</xsl:template>

<xsl:template match="uslm:document/uslm:content/uslm:level/uslm:level[not(@name = 'toc')]/uslm:heading">
	<span>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name() = 'class')]|node()"/>
	</span>
</xsl:template>

<xsl:template name="class">
	<xsl:attribute name="class">
		<xsl:value-of select="local-name()"/>
		<xsl:if test="@class">
			<xsl:text> </xsl:text>
			<xsl:value-of select="@class"/>
		</xsl:if>
	</xsl:attribute>
	<xsl:apply-templates select="@*[not(name() = 'class')]"/>
</xsl:template>

<xsl:template match="uslm:level/uslm:heading">
	<div>
		<xsl:call-template name="class"/>
		<xsl:apply-templates/>
	</div>
</xsl:template>

<xsl:template match="uslm:level[uslm:num]/uslm:heading">
	<span>
		<xsl:call-template name="class"/>
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template name="header">
	<xsl:param name="with-space" select="false()"/>
	<header>
		<xsl:apply-templates select="uslm:heading/@*"/>
		<xsl:apply-templates select="uslm:num"/>
		<xsl:if test="$with-space and uslm:num and uslm:heading">
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:apply-templates select="uslm:heading"/>
	</header>
	<xsl:apply-templates select="node()[not(self::uslm:num)][not(self::uslm:heading)]"/>
</xsl:template>

<xsl:template match="uslm:document/uslm:content/uslm:level/uslm:level[not(@name = 'toc')]/uslm:level">
	<section>
		<xsl:call-template name="class"/>
		<xsl:call-template name="header">
			<xsl:with-param name="with-space" select="true()"/>
		</xsl:call-template>
	</section>
</xsl:template>

<xsl:template match="uslm:section/uslm:chapeau">
	<p class="chapeau">
		<xsl:apply-templates select="@*"/>
		<xsl:call-template name="cut-in-head"/>
		<xsl:apply-templates/>
	</p>
</xsl:template>

</xsl:stylesheet>
