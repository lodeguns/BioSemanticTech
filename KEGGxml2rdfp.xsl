<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version = '1.0'
     xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
     xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
     xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
     xmlns="http://www.w3.org/2005/02/13-KEGG/#"
     xmlns:k="http://www.w3.org/2005/02/13-KEGG/#">

  <!-- xsl:import href="../../../2002/03/11-RDF-XSL/xml-to-string.xsl"/ -->

  <xsl:param name="NS_rn" select="'http://www.w3.org/2005/02/13-KEGG/rn#'"/>
  <xsl:param name="NS_path" select="'http://www.w3.org/2005/02/13-KEGG/path#'"/>
  <xsl:param name="NS_aae" select="'http://www.w3.org/2005/02/13-KEGG/aae#'"/>
  <xsl:param name="NS_ec" select="'http://www.w3.org/2005/02/13-KEGG/ec#'"/>
  <xsl:param name="NS_cpd" select="'http://www.w3.org/2005/02/13-KEGG/cpd#'"/>


  <xsl:template match="pathway">
<rdf:RDF>

    <!-- start a new Pathway -->
    <xsl:text>
</xsl:text>
<k:Pathway>
    <xsl:attribute name="k:org"><xsl:value-of select="@org"/></xsl:attribute>
    <xsl:attribute name="k:number"><xsl:value-of select="@number"/></xsl:attribute>
    <xsl:attribute name="k:title"><xsl:value-of select="@title"/></xsl:attribute>

    <xsl:call-template name="KEGGname">
      <xsl:with-param name="name" select="@name"/>
    </xsl:call-template>

<xsl:text>
    </xsl:text>

    <k:image><xsl:attribute name="rdf:resource"><xsl:value-of select="@image"/></xsl:attribute></k:image>

<xsl:text>
    </xsl:text>
    <k:link><xsl:attribute name="rdf:resource"><xsl:value-of select="@link"/></xsl:attribute></k:link>

<xsl:text>
</xsl:text>
    <xsl:apply-templates mode="entry"/>

    <xsl:apply-templates mode="relation"/>

    <xsl:apply-templates mode="reaction"/>

    <!-- close the Pathway -->
</k:Pathway>
<xsl:text>
</xsl:text>
</rdf:RDF>
  </xsl:template>

  <xsl:template mode="entry" match="entry">
    <!-- get a class name with an initial capitol letter -->
    <xsl:param name="type" select="
	concat(translate(substring(@type, 1, 1), 
			 'abcdefghijklmnopqrstuvwxyz', 
			 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), 
	       substring(@type, 2))" />
<k:entry><xsl:element name="{$type}">
    <xsl:attribute name="rdf:nodeID"><xsl:value-of select="concat('_', @id)"/></xsl:attribute>

    <xsl:call-template name="KEGGname">
      <xsl:with-param name="name" select="@name"/>
    </xsl:call-template>

    <xsl:call-template name="reaction">
      <xsl:with-param name="reaction" select="@reaction"/>
    </xsl:call-template>

    <xsl:if test="@link">
<xsl:text>
      </xsl:text>
    <k:link>
      <xsl:attribute name="rdf:resource"><xsl:value-of select="@link"/></xsl:attribute>
    </k:link>
    </xsl:if>

    <xsl:apply-templates mode="graphics"/>

    <!-- close the entry -->
<xsl:text>
    </xsl:text>
</xsl:element></k:entry>
  </xsl:template>

  <xsl:template name="KEGGname">
    <xsl:param name="name"/>
    <xsl:if test="$name">
       <xsl:text>
      </xsl:text>
	<k:name>
	<xsl:choose>
	  <xsl:when test="substring-before($name, ' ')">
	    <xsl:call-template name="KEGGname-singleName">
	      <xsl:with-param name="attrName" select="'rdf:resource'"/>
	      <xsl:with-param name="KEGGname" select="substring-before($name, ' ')"/>
	    </xsl:call-template>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:call-template name="KEGGname-singleName">
	      <xsl:with-param name="attrName" select="'rdf:resource'"/>
	      <xsl:with-param name="KEGGname" select="$name"/>
	    </xsl:call-template>
	  </xsl:otherwise>
	</xsl:choose>
      </k:name>
      <xsl:call-template name="KEGGname">
        <xsl:with-param name="name" select="substring-after($name, ' ')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="KEGGname-singleName">
    <xsl:param name="attrName"/>
    <xsl:param name="KEGGname"/>
    <xsl:attribute name="{$attrName}">
      <xsl:choose>
	<xsl:when test="substring-before($KEGGname, ':') = 'rn'">
	  <xsl:value-of select="concat($NS_rn, substring-after($KEGGname, ':'))"/>
	</xsl:when>
	<xsl:when test="substring-before($KEGGname, ':') = 'path'">
	  <xsl:value-of select="concat($NS_path, substring-after($KEGGname, ':'))"/>
	</xsl:when>
	<xsl:when test="substring-before($KEGGname, ':') = 'aae'">
	  <xsl:value-of select="concat($NS_aae, substring-after($KEGGname, ':'))"/>
	</xsl:when>
	<xsl:when test="substring-before($KEGGname, ':') = 'ec'">
	  <xsl:value-of select="concat($NS_ec, substring-after($KEGGname, ':'))"/>
	</xsl:when>
	<xsl:when test="substring-before($KEGGname, ':') = 'cpd'">
	  <xsl:value-of select="concat($NS_cpd, substring-after($KEGGname, ':'))"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="error">
	    <xsl:with-param name="wierd" select="substring-before($KEGGname, ':')"/>
	  </xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="reaction">
    <xsl:param name="reaction"/>
      <xsl:if test="$reaction">
        <xsl:param name="thisReaction"/>  !--- ?? ma dove ?
<xsl:text>
      </xsl:text>
      <k:reaction>
	<xsl:choose>
	  <xsl:when test="substring-before($reaction, ' ')">
	    <xsl:call-template name="KEGGname-singleName">
	      <xsl:with-param name="attrName" select="'rdf:resource'"/>
	      <xsl:with-param name="KEGGname" select="substring-before($reaction, ' ')"/>
	    </xsl:call-template>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:call-template name="KEGGname-singleName">
	      <xsl:with-param name="attrName" select="'rdf:resource'"/>
	      <xsl:with-param name="KEGGname" select="$reaction"/>
	    </xsl:call-template>
	  </xsl:otherwise>
	</xsl:choose>
      </k:reaction>
      <xsl:call-template name="reaction">
        <xsl:with-param name="reaction" select="substring-after($reaction, ' ')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="graphics" match="graphics">
    <!-- get a class name with an initial capitol letter -->
    <xsl:param name="type" select="
	concat(translate(substring(@type, 1, 1), 
			 'abcdefghijklmnopqrstuvwxyz', 
			 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), 
	       substring(@type, 2))" />
<k:graphics><xsl:element name="{$type}">
    <xsl:attribute name="k:name"><xsl:value-of select="@name"/></xsl:attribute>
    <xsl:attribute name="k:fgcolor"><xsl:value-of select="@fgcolor"/></xsl:attribute>
    <xsl:attribute name="k:bgcolor"><xsl:value-of select="@bgcolor"/></xsl:attribute>
    <xsl:attribute name="k:x"><xsl:value-of select="@x"/></xsl:attribute>
    <xsl:attribute name="k:y"><xsl:value-of select="@y"/></xsl:attribute>
    <xsl:attribute name="k:width"><xsl:value-of select="@width"/></xsl:attribute>
    <xsl:attribute name="k:height"><xsl:value-of select="@height"/></xsl:attribute>
</xsl:element></k:graphics>
  </xsl:template>

  <xsl:template mode="relation" match="relation">
    <k:relation><xsl:element name="{@type}">

      <k:entry1><xsl:attribute name="rdf:resource"><xsl:value-of select="concat('_', @entry1)"/></xsl:attribute></k:entry1>

      <k:entry2><xsl:attribute name="rdf:resource"><xsl:value-of select="concat('_', @entry2)"/></xsl:attribute></k:entry2>

      <xsl:element name="{subtype/@name}"><xsl:attribute name="rdf:resource"><xsl:value-of select="concat('_', subtype/@value)"/></xsl:attribute></xsl:element>

    </xsl:element></k:relation>
  </xsl:template>

  <xsl:template mode="reaction" match="reaction">
    <k:reaction>
      <xsl:choose>
	<xsl:when test="@type='reversible'">
	  <xsl:attribute name="reversible" select="1"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:attribute name="reversible" select="0"/>
	</xsl:otherwise>
      </xsl:choose>

      <xsl:call-template name="KEGGname-singleName">
	<xsl:with-param name="attrName" select="'rdf:about'"/>
	<xsl:with-param name="KEGGname" select="@name"/>
      </xsl:call-template>

      <k:substrate>
	<xsl:call-template name="KEGGname-singleName">
	  <xsl:with-param name="attrName" select="'rdf:resource'"/>
	  <xsl:with-param name="KEGGname" select="substrate/@name"/>
	</xsl:call-template>
      </k:substrate>

      <k:product>
	<xsl:call-template name="KEGGname-singleName">
	  <xsl:with-param name="attrName" select="'rdf:resource'"/>
	  <xsl:with-param name="KEGGname" select="product/@name"/>
	</xsl:call-template>
      </k:product>

    </k:reaction>
  </xsl:template>

  <xsl:template name="error">
    <xsl:param name="wierd"/>
    <xsl:message terminate="yes">
      <xsl:for-each select=".">
	<xsl:value-of select="concat('unknown namespace ', $wierd, ' on attribute ', name(), '!')"/>
      </xsl:for-each>
    </xsl:message>
  </xsl:template>

</xsl:stylesheet>
