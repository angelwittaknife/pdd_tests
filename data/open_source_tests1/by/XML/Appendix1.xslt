<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:scripts="urn:scripts">
  <xsl:import href="Service.xslt" />

  <xsl:template match="appendix">
    <div>
      <xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
      <xsl:apply-templates select="content/header/*" />
      <xsl:call-template name="insertPictures" />
    </div>
  </xsl:template>

  <xsl:template name="insertPictures">
    <div>
      <xsl:attribute name="id"><xsl:value-of select="content/chapters/chapter[1]/@id" /></xsl:attribute>
      <h3><xsl:value-of select="content/chapters/chapter[1]/content/h3" /></h3>
      <xsl:call-template name="row">
        <xsl:with-param name="signGroup" select="content/chapters/chapter[1]/content/items/itemSignGroup[position() >= 1 and 3 >= position()]" />
      </xsl:call-template>
      <xsl:call-template name="row">
        <xsl:with-param name="signGroup" select="content/chapters/chapter[1]/content/items/itemSignGroup[position() >= 4 and 6 >= position()]" />
      </xsl:call-template>
      <xsl:call-template name="row">
        <xsl:with-param name="signGroup" select="content/chapters/chapter[1]/content/items/itemSignGroup[position() >= 7 and 9 >= position()]" />
      </xsl:call-template>
      <xsl:call-template name="row">
        <xsl:with-param name="signGroup" select="content/chapters/chapter[1]/content/items/itemSignGroup[position() >= 10 and 12 >= position()]" />
      </xsl:call-template>
    </div>
    <div>
      <xsl:attribute name="id"><xsl:value-of select="content/chapters/chapter[2]/@id" /></xsl:attribute>
      <h3><xsl:value-of select="content/chapters/chapter[2]/content/h3" /></h3>
      <xsl:call-template name="row">
        <xsl:with-param name="signGroup" select="content/chapters/chapter[2]/content/items/*" />
      </xsl:call-template>
    </div>
    <div>
      <xsl:attribute name="id"><xsl:value-of select="content/chapters/chapter[3]/@id" /></xsl:attribute>
      <h3><xsl:value-of select="content/chapters/chapter[3]/content/h3" /></h3>
      <xsl:call-template name="row">
        <xsl:with-param name="signGroup" select="content/chapters/chapter[3]/content/items/*" />
      </xsl:call-template>
    </div>
  </xsl:template>
</xsl:stylesheet>
