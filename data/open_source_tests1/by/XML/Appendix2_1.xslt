<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:scripts="urn:scripts">

  <xsl:import href="Service.xslt" />

  <xsl:template match="chapter">
    <xsl:call-template name="htmlBegin" />
    <xsl:call-template name="htmlBeginBody" />

    <div>
      <xsl:attribute name="id">
        <xsl:value-of select="@id" />
      </xsl:attribute>
      <xsl:apply-templates select="content/paragraphs/paragraph[1]" />
      <xsl:apply-templates select="content/items" />
    </div> 

    <xsl:call-template name="htmlEnd" />
  </xsl:template>
</xsl:stylesheet>
