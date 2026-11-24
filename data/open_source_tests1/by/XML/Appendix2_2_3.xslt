<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:scripts="urn:scripts">
  <xsl:import href="Service.xslt" />
  <xsl:import href="ImageTabl.xslt" />

  <xsl:template match="paragraph">
    <xsl:call-template name="SetPageWithTablePictures" />
  </xsl:template>

  <xsl:template name="insertPictures">
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 1 and 4 >= position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 5 and 8 >= position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 9 and 11 >= position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 12 and 14 >= position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 15 and 17 >= position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 18 and 21 >= position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() = 22 or 23 = position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() = 24 or 25 = position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 26 and 28 >= position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 29 and 32 >= position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 33 and 37 >= position()]" />
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
