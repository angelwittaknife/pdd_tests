<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:scripts="urn:scripts">

  <xsl:import href="Service.xslt" />

  <xsl:template match="/">
    <xsl:call-template name="htmlBegin"/>
    <xsl:call-template name="htmlBeginBody"/>

    <xsl:for-each select="*">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

    <xsl:call-template name="htmlEnd"/>
  </xsl:template>

</xsl:stylesheet>