<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:scripts="urn:scripts">
  <xsl:import href="Service.xslt" />
  <xsl:import href="ImageTabl.xslt" />

  <xsl:template match="paragraph">
    <xsl:call-template name="SetPageWithTablePictures" />
  </xsl:template>

  <xsl:template name="insertPictures">
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position()>=1 and 4>=position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position()>=5 and 8>=position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position()>=9 and 12>=position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position()>=13 and 16>=position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position()=17 or 18=position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position()>=19 and 22>=position()]" />
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
