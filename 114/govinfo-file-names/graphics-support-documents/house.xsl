<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:uslm="http://xml.house.gov/schemas/uslm/1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:html="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="uslm dc html">

<xsl:output method="html" encoding="utf-8" />

<xsl:template match="uslm:document">
	<html>
		<xsl:apply-templates/>
	</html>
</xsl:template>

<xsl:template match="uslm:document/uslm:meta">
	<head>
		<xsl:apply-templates select="dc:title"/>
		<xsl:for-each select="/processing-instruction('xml-stylesheet')[contains(., 'type=&quot;text/css')]">
			<link rel="stylesheet" href="{substring-before(substring-after(., 'href=&quot;'), '&quot;')}" type="text/css"/>
		</xsl:for-each>
	</head>
</xsl:template>

<xsl:template match="dc:title">
	<title>
		<xsl:apply-templates/>
	</title>
</xsl:template>

<xsl:template match="uslm:document/uslm:content">
	<body>
		<xsl:apply-templates/>
	</body>
</xsl:template>


<!-- sections -->

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
		<xsl:apply-templates/>
	</section>
</xsl:template>

<xsl:template match="uslm:title | uslm:subtitle | uslm:part">
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
			<xsl:apply-templates select="uslm:num | uslm:heading"/>
		</header>
		<xsl:apply-templates select="node()[not(self::uslm:num)][not(self::uslm:heading)]"/>
	</section>
</xsl:template>

<xsl:template name="no-heading">
	<xsl:choose>
		<xsl:when test="self::uslm:section">
			<xsl:if test="not(uslm:heading) and not(uslm:chapeau)">
				<xsl:text> no-heading</xsl:text>
			</xsl:if>
		</xsl:when>
		<xsl:when test="self::uslm:subsection and not(uslm:chapeau)">
			<xsl:if test="not(uslm:chapeau)">
				<xsl:text> no-heading</xsl:text>
			</xsl:if>
		</xsl:when>
		<xsl:when test="self::uslm:paragraph">
			<xsl:if test="not(uslm:heading) and not(uslm:chapeau)">
				<xsl:text> no-heading</xsl:text>
			</xsl:if>
		</xsl:when>
		<xsl:when test="self::uslm:subparagraph">
			<xsl:if test="not(uslm:heading) and not(uslm:chapeau)">
				<xsl:text> no-heading</xsl:text>
			</xsl:if>
		</xsl:when>
		<xsl:when test="self::uslm:clause">
			<xsl:if test="not(uslm:heading) and not(uslm:chapeau)">
				<xsl:text> no-heading</xsl:text>
			</xsl:if>
		</xsl:when>
		<xsl:when test="self::uslm:subclause">
			<xsl:if test="not(uslm:heading) and not(uslm:chapeau)">
				<xsl:text> no-heading</xsl:text>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise/>
	</xsl:choose>
</xsl:template>

<xsl:template match="uslm:section | uslm:subsection | uslm:paragraph | uslm:subparagraph | uslm:clause | uslm:subclause | uslm:item">
	<section>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
<!-- 		this needs to be different for differnt types of elements	 -->
			<xsl:if test="not(uslm:heading) and not(uslm:chapeau)">	<!--   -->
				<xsl:text> no-heading</xsl:text>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='class')]"/>
		<xsl:call-template name="cut-in-head"/>
		<xsl:apply-templates/>
	</section>
</xsl:template>

<xsl:template match="uslm:*[@class = 'style2' or @class = 'style3']//uslm:section">
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
			<xsl:if test="uslm:num and uslm:heading">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:apply-templates select="uslm:heading"/>
		</header>
		<xsl:apply-templates select="node()[not(self::uslm:num)][not(self::uslm:heading)]"/>
	</section>
</xsl:template>


<!-- blocks -->

<xsl:template match="uslm:prelimiary | uslm:continuation | uslm:proviso">
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

<xsl:template match="uslm:level/uslm:heading | uslm:crossHeading">
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

<xsl:template match="uslm:note">
	<div>
		<xsl:attribute name="class">
			<xsl:value-of select="local-name()"/>
			<xsl:if test="@type">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@type"/>
			</xsl:if>
			<xsl:if test="@class">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:if>
		</xsl:attribute>
		<xsl:apply-templates select="@*[not(name()='type')][not(name()='class')]"/>
		<xsl:apply-templates/>
	</div>
</xsl:template>


<!-- paragraphs -->

<xsl:template match="uslm:text | uslm:p">
	<p>
		<xsl:apply-templates select="@*"/>
		<xsl:call-template name="cut-in-head"/>
		<xsl:apply-templates/>
	</p>
</xsl:template>


<!-- Cut in Head -->

<xsl:key name="s-head" match="uslm:property" use="@idref" />

<xsl:template name="cut-in-head">
	<xsl:for-each select="key('s-head', @id)">
		<span class="cut-in-head">
			<xsl:apply-templates/>
		</span>
	</xsl:for-each>
</xsl:template>


<!-- tables -->

<xsl:template match="uslm:layout">
	<table>
		<xsl:apply-templates select="@*|node()"/>
	</table>
</xsl:template>

<xsl:template match="uslm:row">
	<tr>
		<xsl:apply-templates select="@*|node()"/>
	</tr>
</xsl:template>

<xsl:template match="uslm:column">
	<td>
		<xsl:apply-templates select="@*|node()"/>
	</td>
</xsl:template>



<xsl:template match="uslm:ref">
	<a>
		<xsl:attribute name="href">
			<xsl:choose>
				<xsl:when test="@idref">
					<xsl:text>#</xsl:text>
					<xsl:value-of select="@idref"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@href"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:apply-templates select="@class"/>
		<xsl:apply-templates/>
	</a>
</xsl:template>

<xsl:template match="uslm:i | uslm:sup | uslm:img">
	<xsl:element name="{local-name()}">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:element>
</xsl:template>

<xsl:template match="uslm:inline">
	<span>
		<xsl:if test="@name | @class">
			<xsl:attribute name="class">
				<xsl:value-of select="@name"/>
				<xsl:if test="@name and @class">
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="@class"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates select="@*[not(name='name')][not(name='class')]"/>
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template match="uslm:marker[@name='horizontal']">
	<hr class="{@class}"/>
</xsl:template>


<xsl:template match="uslm:*">
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

<xsl:template match="html:*">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="@*">
	<xsl:copy />
</xsl:template>

</xsl:stylesheet>
