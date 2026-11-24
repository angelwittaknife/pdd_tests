<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:scripts="urn:scripts">

  <xsl:import href="Service.xslt" />

  <xsl:template match="appendix">
    <xsl:call-template name="htmlBegin" />
    <xsl:call-template name="htmlBeginBody" />
    <xsl:apply-templates select="content/items/item/chapters/chapter[1]/content/paragraphs/paragraph[1]" />
    <xsl:apply-templates select="content/items/item/chapters/chapter[1]/content/items" />
    <xsl:call-template name="htmlEnd" />
  </xsl:template>

</xsl:stylesheet>
