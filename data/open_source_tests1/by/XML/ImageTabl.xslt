<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:scripts="urn:scripts">

  <xsl:template match="items">
  </xsl:template>

  <xsl:template name="SetPageWithTablePictures">
    <div>
      <xsl:attribute name="id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:apply-templates select="*" />
      <xsl:call-template name="insertPictures" />
    </div>
  </xsl:template>
</xsl:stylesheet>
