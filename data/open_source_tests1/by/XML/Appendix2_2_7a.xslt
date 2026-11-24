<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:scripts="urn:scripts">
  <xsl:import href="Service.xslt" />
  <xsl:import href="ImageTabl.xslt" />

  <xsl:template match="paragraph">
    <xsl:call-template name="SetPageWithTablePictures" />
  </xsl:template>

  <xsl:template name="insertPictures">
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[1]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[2]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[3]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[4]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position()>=5 and 7>=position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position()>=8 and 10>=position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[11]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position()>=12 and 14>=position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[15]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position()>=16 and 20>=position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position()>=21 and 25>=position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position()>=26 and 30>=position()]" />
    </xsl:call-template>
    <xsl:call-template name="row">
      <xsl:with-param name="signGroup" select="content/items/itemSignGroup[position()>=31 and 33>=position()]" />
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
