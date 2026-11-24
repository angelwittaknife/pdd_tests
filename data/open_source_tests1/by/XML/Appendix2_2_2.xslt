<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:scripts="urn:scripts">
  <xsl:import href="Service.xslt" />
  <xsl:import href="ImageTabl.xslt" />

  <xsl:template match="paragraph">
    <xsl:call-template name="SetPageWithTablePictures" />
  </xsl:template>

  <xsl:template name="insertPictures">
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() = 1 or 2 = position()]"/>
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 3 and 5 >= position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() = 6 or 7 = position()]"/>
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 8 and 10 >= position()]" />
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
