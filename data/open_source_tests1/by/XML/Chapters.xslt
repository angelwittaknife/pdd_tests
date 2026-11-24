<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:scripts="urn:scripts">

  <xsl:import href="Service.xslt" />

  <xsl:param name="subChapter"/>

  <xsl:template match="/">

    <xsl:call-template name="htmlBegin" />
    <xsl:call-template name="htmlBeginBody" />

    <xsl:apply-templates select="*"/>

    <h4>
      <xsl:value-of select="content/subName"/>
      <xsl:choose>
        <xsl:when test="$subChapter= 'ch1_1'">
          <xsl:value-of select="' (дорожное движение и его участники)'"/>
        </xsl:when>
        <xsl:when test="$subChapter= 'ch1_2'">
          <xsl:value-of select="' (дорожные условия)'"/>
        </xsl:when>
        <xsl:when test="$subChapter= 'ch1_3'">
          <xsl:value-of select="' (транспортные средства)'"/>
        </xsl:when>
        <xsl:when test="$subChapter= 'ch1_4'">
          <xsl:value-of select="' (управление транспортным средством)'"/>
        </xsl:when>
      </xsl:choose>
    </h4>

    <xsl:apply-templates select="content/items" />

    <xsl:call-template name="htmlEnd" />

  </xsl:template>


  <xsl:template match="items">
    <xsl:choose>
      <!---->
      <xsl:when test="$subChapter= 'ch1_1'">
        <xsl:for-each select="item">
          <xsl:sort select="@ch1_1"/>
          <xsl:if test="boolean(@ch1_1) != boolean(NaN)">
            <xsl:apply-templates select="." />
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <!---->
      <xsl:when test="$subChapter= 'ch1_2'">
        <xsl:for-each select="item">
          <xsl:sort select="@ch1_2"/>
          <xsl:if test="boolean(@ch1_2) != boolean(NaN)">
            <xsl:apply-templates select="." />
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <!---->
      <xsl:when test="$subChapter= 'ch1_3'">
        <xsl:for-each select="item">
          <xsl:sort select="@ch1_3"/>
          <xsl:if test="boolean(@ch1_3) != boolean(NaN)">
            <xsl:apply-templates select="." />
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <!---->
      <xsl:when test="$subChapter= 'ch1_4'">
        <xsl:for-each select="item">
          <xsl:sort select="@ch1_4"/>
          <xsl:if test="boolean(@ch1_4) != boolean(NaN)">
            <xsl:apply-templates select="." />
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="node()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!--<xsl:template match="items">
    <xsl:choose>
      <xsl:when test="boolean($subChapter) != boolean(NaN)">
        <xsl:for-each select="item">
          <xsl:sort select="$value"/>

          <xsl:variable name="value">
            <xsl:for-each select="@*">
              <xsl:if test="string(name()) = string($subChapter)">
                <xsl:value-of select="." />
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>         
          

          <xsl:variable name="iss">
            <xsl:for-each select="@*">
              <xsl:if test="string(name()) = string($subChapter)">
                <xsl:value-of select="'true'" />
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>



          <xsl:if test="$iss = 'true'">
            <xsl:value-of select="$value" />
            <xsl:apply-templates select="." />
          </xsl:if>

        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="node()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->

</xsl:stylesheet>