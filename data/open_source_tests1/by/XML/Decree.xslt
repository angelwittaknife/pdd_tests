<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:scripts="urn:scripts">

  <xsl:import href="Service.xslt" />
  
  <xsl:template match="/">
    
    <xsl:call-template name="htmlBegin" />
    <xsl:call-template name="htmlBeginBody" />

    <xsl:for-each select="content/items">
      <xsl:apply-templates select="item"/>
    </xsl:for-each>

    <br/>
   
    <p class="signatureLeft"><xsl:value-of select="content/signatureLeft"/></p>
    <p class="signatureRight"><xsl:value-of select="content/signatureRight"/></p>

    <xsl:call-template name="htmlEnd" />

  </xsl:template>

  <xsl:template match="signatureLeft">
    <p class="signatureLeft">
      <xsl:value-of select="."/>
    </p>
  </xsl:template>

  <xsl:template match="signatureRight">
    <p class="signatureRight">
      <xsl:value-of select="."/>
    </p>
  </xsl:template>
  
</xsl:stylesheet>