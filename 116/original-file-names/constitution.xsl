<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:uslm="http://xml.house.gov/schemas/uslm/1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
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
			<link rel="stylesheet" href="constitution.css" type="text/css"/>
		</head>
		<xsl:apply-templates select="uslm:content"/>
	</html>
</xsl:template>

<xsl:template match="uslm:document/uslm:content">
	<body>
		<xsl:apply-templates />
	</body>
</xsl:template>

<xsl:template match="uslm:preamble | uslm:article | uslm:section | uslm:clause | uslm:level[@name]">
	<section class="{local-name()}">
		<xsl:apply-templates select="@*"/>
		<xsl:for-each select="key('s-head', @id)">
			<div class="cut-in-head">
				<xsl:value-of select="."/>
			</div>
		</xsl:for-each>
		<xsl:apply-templates/>
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
				<xsl:value-of select="."/>
			</span>
		</xsl:for-each>
		<xsl:apply-templates/>
	</p>
</xsl:template>


<!-- blocks -->

<xsl:template match="uslm:note | uslm:quotedContent">
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
			<xsl:if test="@name">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='class')][not(name()='type')][not(name()='name')]"/>
		<xsl:apply-templates/>
	</div>
</xsl:template>


<!-- tables -->

<xsl:template match="uslm:layout">
	<table>
		<xsl:apply-templates select="@*|node()"/>
	</table>
</xsl:template>

<xsl:template match="uslm:header | uslm:row">
	<tr>
		<xsl:apply-templates select="@*|node()"/>
	</tr>
</xsl:template>

<xsl:template match="uslm:column">
	<td>
		<xsl:apply-templates select="@*|node()"/>
	</td>
</xsl:template>

<xsl:template match="uslm:header/uslm:column">
	<th>
		<xsl:apply-templates select="@*|node()"/>
	</th>
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



<!-- USC -->

<xsl:template match="uslm:quotedContent//uslm:subsection | uslm:quotedContent//uslm:paragraph | uslm:quotedContent//uslm:subparagraph | uslm:quotedContent//uslm:clause | uslm:quotedContent//uslm:subclause">
	<section>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
			<xsl:if test="uslm:heading | uslm:chapeau">
				<xsl:text> </xsl:text>
				<xsl:text>indent-children</xsl:text>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='class')]"/>
		<xsl:for-each select="key('s-head', @id)">
			<div class="cut-in-head">
				<xsl:apply-templates/>
			</div>
		</xsl:for-each>
		<xsl:apply-templates/>
	</section>
</xsl:template>


<xsl:template match="uslm:quotedContent//uslm:section">
	<section>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='class')]"/>
		<header>
			<xsl:apply-templates select="uslm:num"/>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="uslm:heading"/>
		</header>
		<xsl:apply-templates select="*[not(self::uslm:num)][not(self::uslm:heading)]"/>
	</section>
</xsl:template>

<xsl:template match="uslm:subsection | uslm:paragraph">
	<section class="{local-name()}">
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates />
	</section>
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
