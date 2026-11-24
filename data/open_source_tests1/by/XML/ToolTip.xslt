<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:scripts="urn:scripts">

  <xsl:import href="Service.xslt" />

  <xsl:param name="subChapter" />

  <xsl:template match="/">
    <xsl:call-template name="htmlBegin" />
    <xsl:call-template name="htmlBeginBodyToolTip" />
    <xsl:apply-templates select="*" />
    <xsl:call-template name="htmlEnd" />
  </xsl:template>
  
  <xsl:template match="item">
    <xsl:call-template name="itemText">
      <xsl:with-param name="item" select="." />
      <xsl:with-param name="class">textToolTip</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="subitem">
    <xsl:call-template name="itemText">
      <xsl:with-param name="item" select="content" />
      <xsl:with-param name="class">textToolTip</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="itemRoadmark">
    <div class="textToolTip">
      <xsl:attribute name="id">
        <xsl:value-of select="@id" />
      </xsl:attribute>
      <xsl:apply-templates select="content" />
    </div>
  </xsl:template>

  <xsl:template match="p">
    <div class="textToolTip"><xsl:apply-templates select="*" /></div>
  </xsl:template>

  <xsl:template match="toolTip">
    <div>
      <xsl:attribute name="class" >
        <xsl:value-of select="'pdd-tooltip'" />
      </xsl:attribute>
      <xsl:attribute name="data-title" >
        <xsl:value-of select="'insertTitle'" />
      </xsl:attribute>
      <xsl:apply-templates select="*" />
    </div>
  </xsl:template>

  <xsl:template match="items">
    <xsl:choose>
      
      <xsl:when test="$subChapter= 'ch1_1'">
        <xsl:for-each select="item">
          <xsl:sort select="@ch1_1" />
          <xsl:if test="boolean(@ch1_1) != boolean(NaN)">
            <xsl:apply-templates select="." />
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      
      <xsl:when test="$subChapter= 'ch1_2'">
        <xsl:for-each select="item">
          <xsl:sort select="@ch1_2" />
          <xsl:if test="boolean(@ch1_2) != boolean(NaN)">
            <xsl:apply-templates select="." />
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      
      <xsl:when test="$subChapter= 'ch1_3'">
        <xsl:for-each select="item">
          <xsl:sort select="@ch1_3" />
          <xsl:if test="boolean(@ch1_3) != boolean(NaN)">
            <xsl:apply-templates select="." />
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      
      <xsl:when test="$subChapter= 'ch1_4'">
        <xsl:for-each select="item">
          <xsl:sort select="@ch1_4" />
          <xsl:if test="boolean(@ch1_4) != boolean(NaN)">
            <xsl:apply-templates select="." />
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="node()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="insert">
  </xsl:template>
  
</xsl:stylesheet>