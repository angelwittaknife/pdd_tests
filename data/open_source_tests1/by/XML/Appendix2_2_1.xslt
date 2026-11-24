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
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 5 and 7 >= position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 8 and 11 >= position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() = 12 or 13 = position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 14 and 17 >= position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() = 18 or 19 = position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[20]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 21 and 24 >= position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 25 and 28 >= position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 29 and 32 >= position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[33]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 34 and 37 >= position()]" />
    </xsl:call-template>
    <xsl:if test="content/items/itemSignGroup[position() >= 38]">
      <xsl:call-template name="row">
        <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position() >= 38 and 41 >= position()]" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
