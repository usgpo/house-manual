<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:uslm="http://xml.house.gov/schemas/uslm/1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:html="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="uslm html dc">

<xsl:output method="html" encoding="utf-8" />

<xsl:key name="s-head" match="uslm:property[@name='s-heading']" use="@idref" />

<xsl:template match="uslm:document">
	<html>
		<head>
			<title>
				<xsl:apply-templates select="uslm:meta/dc:title/text()"/>
			</title>
			<link rel="stylesheet" href="manual.css" type="text/css"/>
		</head>
		<xsl:apply-templates select="uslm:content"/>
	</html>
</xsl:template>

<xsl:template match="uslm:meta"/>

<xsl:template match="uslm:document/uslm:content">
	<body>
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates />
	</body>
</xsl:template>

<xsl:template match="uslm:p">
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

<xsl:template match="uslm:text">
	<p>
		<xsl:call-template name="attributes-generic"/>
		<xsl:for-each select="key('s-head', @id)">
			<span class="cut-in-head">
				<xsl:apply-templates/>
			</span>
		</xsl:for-each>
		<xsl:apply-templates/>
	</p>
</xsl:template>

<xsl:template name="attributes-generic">
	<xsl:choose>
		<xsl:when test="@name">
			<xsl:attribute name="class">
				<xsl:value-of select="@name"/>
				<xsl:if test="@class">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@class"/>
				</xsl:if>
			</xsl:attribute>
		</xsl:when>
		<xsl:when test="@class">
			<xsl:attribute name="class">
				<xsl:value-of select="@class"/>
			</xsl:attribute>
		</xsl:when>
	</xsl:choose>
	<xsl:apply-templates select="@*[not(name()='name')][not(name()='class')]"/>
</xsl:template>

<xsl:template name="attributes">
	<xsl:attribute name="class">
		<xsl:value-of select="local-name()"/>
		<xsl:if test="@name">
			<xsl:text> </xsl:text>
			<xsl:value-of select="@name"/>
		</xsl:if>
		<xsl:if test="@type">
			<xsl:text> </xsl:text>
			<xsl:value-of select="@type"/>
		</xsl:if>
		<xsl:if test="@class">
			<xsl:text> </xsl:text>
			<xsl:value-of select="@class"/>
		</xsl:if>
	</xsl:attribute>
	<xsl:apply-templates select="@*[not(name()='name')][not(name()='type')][not(name()='class')]"/>
</xsl:template>

<!-- sections -->

<xsl:template match="uslm:level">
	<section>
		<xsl:call-template name="attributes-generic"/>
		<xsl:for-each select="key('s-head', @id)">
			<div class="cut-in-head">
				<xsl:apply-templates/>
			</div>
		</xsl:for-each>
		<xsl:apply-templates/>
	</section>
</xsl:template>

<xsl:template match="uslm:preamble | uslm:article | uslm:section | uslm:resolution | uslm:toc" name="section">
	<section>
		<xsl:call-template name="attributes"/>
		<xsl:for-each select="key('s-head', @id)">
			<div class="cut-in-head">
				<xsl:apply-templates/>
			</div>
		</xsl:for-each>
		<xsl:apply-templates/>
	</section>
</xsl:template>

<xsl:template match="uslm:num | uslm:heading">
	<span class="{local-name()}">
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template match="uslm:continuation"> <!-- chapeau is handled by default -->
	<p>
		<xsl:call-template name="attributes"/>
		<xsl:apply-templates/>
	</p>
</xsl:template>


<!-- blocks -->

<xsl:template match="uslm:main | uslm:content | uslm:signatures | uslm:tocItem | uslm:crossHeading" name="div">
	<div>
		<xsl:call-template name="attributes"/>
		<xsl:apply-templates/>
	</div>
</xsl:template>

<xsl:template match="uslm:p/uslm:signature | uslm:p/uslm:signature/uslm:*">
	<xsl:call-template name="span" />
</xsl:template>

<xsl:template match="uslm:note | uslm:quotedContent">
	<div>
		<xsl:call-template name="attributes"/>
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


<!-- horizontal lines -->

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

<xsl:template match="uslm:inline">
	<span>
		<xsl:call-template name="attributes-generic"/>
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template match="uslm:*" name="span">
	<span>
		<xsl:call-template name="attributes"/>
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template match="processing-instruction()"/>


<!-- front -->

<xsl:template match="uslm:content[@id='front']//uslm:heading">
	<header>
		<xsl:apply-templates select="@*|node()"/>
	</header>
</xsl:template>

<xsl:template match="uslm:content[@id='front']//uslm:main/uslm:docTitle">
	<xsl:call-template name="div" />
</xsl:template>

<xsl:template match="uslm:content[@id='front']//uslm:main/uslm:property">
	<xsl:call-template name="div" />
</xsl:template>

<xsl:template match="uslm:content[@id='front']//uslm:main/uslm:date">
	<xsl:call-template name="div" />
</xsl:template>

<xsl:template match="uslm:content[@id='front']//uslm:signature | uslm:content[@id='front']//uslm:name | uslm:content[@id='front']//uslm:role">
	<xsl:call-template name="div" />
</xsl:template>


<!-- jefferson -->

<xsl:template match="uslm:content[@id='jefferson']//uslm:section" priority="1"> <!-- jefferson has no USC -->
	<section>
		<xsl:call-template name="attributes"/>
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


<!-- rules -->

<xsl:template match="uslm:level[@name='rule']/uslm:num | uslm:level[@name='rule']/uslm:heading">
	<xsl:call-template name="div" />
</xsl:template>

<xsl:template match="uslm:level[@name='rule']/uslm:chapeau">
	<p>
		<xsl:call-template name="attributes"/>
		<xsl:apply-templates/>
	</p>
</xsl:template>

<xsl:template match="uslm:clause | uslm:paragraph | uslm:subparagraph | uslm:subdivision | uslm:item | uslm:subitem" name="section-indent-children">
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

<xsl:template match="uslm:title | uslm:quotedContent[contains(@class, 'style3')]//uslm:section" priority="1"> <!-- priority to take precedence over next template -->
	<section>
		<xsl:call-template name="attributes"/>
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

<xsl:template match="uslm:quotedContent//uslm:section">
	<xsl:call-template name="section"/>
</xsl:template>

<xsl:template match="uslm:quotedContent//uslm:subsection | uslm:quotedContent//uslm:paragraph | uslm:quotedContent//uslm:subparagraph | uslm:quotedContent//uslm:clause | uslm:quotedContent//uslm:subclause">
	<xsl:call-template name="section-indent-children"/>
</xsl:template>

</xsl:stylesheet>
