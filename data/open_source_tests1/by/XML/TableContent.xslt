<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:scripts="urn:scripts">
  <xsl:import href="Service.xslt" />

  <xsl:template match="/">
    <xsl:call-template name="htmlBegin" />
    <xsl:call-template name="htmlBeginBody" />
    <ul>
      <xsl:for-each select="root/decrees">
        <xsl:apply-templates select="decree/service/tableContent"/>
      </xsl:for-each>
      <xsl:for-each select="root/chapters">
        <xsl:apply-templates select="chapter/service/tableContent"/>
      </xsl:for-each>
      <xsl:for-each select="root/appendixes">
        <xsl:apply-templates select="appendix"/>
      </xsl:for-each>
      <xsl:for-each select="root/roadsafety">
        <xsl:apply-templates select="chapters/chapter/service/tableContent"/>
      </xsl:for-each>
      <xsl:for-each select="root/bez">
        <xsl:apply-templates select="chapters/chapter/service/tableContent"/>
      </xsl:for-each>
      <xsl:for-each select="root/med">
        <xsl:apply-templates select="chapters/chapter/service/tableContent"/>
      </xsl:for-each>
      <xsl:for-each select="root/pr">
        <xsl:apply-templates select="chapters/chapter/service/tableContent"/>
      </xsl:for-each>
    </ul>
    <xsl:call-template name="htmlEnd" />
  </xsl:template>

  <xsl:template match="appendix">
    <xsl:apply-templates select="service/tableContent"/>
    <xsl:for-each select="content/groups/group">
      <xsl:apply-templates select="service/tableContent"/>
    </xsl:for-each>
    <xsl:for-each select="content/items/item/chapters/chapter">
      <xsl:apply-templates select="service/tableContent"/>
      <xsl:for-each select="content/paragraphs/paragraph">
        <xsl:apply-templates select="service/tableContent"/>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tableContent">
    <li>
      <xsl:attribute name="class">
        <xsl:text>TableContent</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="rel">
        <xsl:value-of select="@rel" />
      </xsl:attribute>
      <a><xsl:attribute name="href"><xsl:text>#</xsl:text><xsl:value-of select="../../@id" /></xsl:attribute><xsl:value-of select="."/></a>
    </li>
  </xsl:template>
</xsl:stylesheet>
