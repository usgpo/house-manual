<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:uslm="http://xml.house.gov/schemas/uslm/1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="uslm dc">

<xsl:output method="html" encoding="utf-8" />

<xsl:key name="s-head" match="uslm:property" use="@idref" />

<xsl:template match="processing-instruction()"/>

<xsl:template match="uslm:document">
	<html>
		<head>
			<title>
				<xsl:value-of select="uslm:meta/dc:title"/>
			</title>
			<link rel="stylesheet" href="graphics-support-documents/rules.css" type="text/css"/>
		</head>
		<xsl:apply-templates select="uslm:content"/>
	</html>
</xsl:template>

<xsl:template match="uslm:document/uslm:content">
	<body>
		<xsl:apply-templates select="@*|node()"/>
	</body>
</xsl:template>

<xsl:template match="uslm:level">
	<section>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@name">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
			</xsl:if>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='name')][not(name()='class')]"/>
		<xsl:apply-templates />
	</section>
</xsl:template>

<xsl:template match="uslm:level[@name='rule']/uslm:num | uslm:level[@name='rule']/uslm:heading">
	<div class="{local-name()}">
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates/>
	</div>
</xsl:template>

<xsl:template match="uslm:level[@name='rule']/uslm:chapeau | uslm:continuation">
	<p>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='class')]"/>
		<xsl:apply-templates select="node()"/>
	</p>
</xsl:template>

<xsl:template match="uslm:p">
	<p>
		<xsl:apply-templates select="@*"/>
		<xsl:for-each select="key('s-head', @id)">
			<div class="cut-in-head">
				<xsl:apply-templates/>
			</div>
		</xsl:for-each>
		<xsl:apply-templates/>
	</p>
</xsl:template>


<!-- blocks -->

<xsl:template match="uslm:note | uslm:quotedContent | uslm:crossHeading | uslm:text">
	<div>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='class')]"/>
		<xsl:for-each select="key('s-head', @id)">
			<div class="cut-in-head">
				<xsl:apply-templates/>
			</div>
		</xsl:for-each>
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


<!-- indentation -->

<xsl:template match="uslm:clause | uslm:paragraph | uslm:subparagraph | uslm:subdivision | uslm:item | uslm:subitem |
		uslm:section | uslm:subsection | uslm:subclause">
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


<!-- USC -->

<!-- priority to take precedence over next template -->
<xsl:template match="uslm:title | uslm:quotedContent[contains(@class, 'style3')]//uslm:section" priority="1">
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
			<xsl:value-of select="uslm:num"/>
			<xsl:if test="uslm:num and uslm:heading and not(substring(uslm:num, string-length(uslm:num)) = '—')">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:value-of select="uslm:heading"/>
		</header>
		<xsl:apply-templates select="*[not(self::uslm:num)][not(self::uslm:heading)]"/>
	</section>
</xsl:template>

<!-- the purpose of this is simply to prevent @class='indent-children' -->
<xsl:template match="uslm:quotedContent[contains(@class, 'usc')]//uslm:section">
	<section>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='class')]"/>
		<xsl:apply-templates/>
	</section>
</xsl:template>


<!-- horizontal line -->

<xsl:template match="uslm:marker[@name='horizontal']">
	<hr class="{@class}"/>
</xsl:template>


<!-- defaults -->

<xsl:template match="@*">
	<xsl:copy />
</xsl:template>

<xsl:template match="uslm:i">
	<xsl:element name="{local-name()}">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:element>
</xsl:template>

<xsl:template match="*">
	<span>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@name">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
			</xsl:if>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='name')][not(name()='class')]"/>
		<xsl:apply-templates />
	</span>
</xsl:template>

</xsl:stylesheet>
