<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:scripts="urn:scripts">
  <xsl:param name="percentImgSizeGlobal" select="100" />
  <xsl:param name="showBorder">false</xsl:param>
  <xsl:param name="tableWidth" select="600" />

  <xsl:template match="insert" name="insert">
    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="@link" />
      </xsl:attribute>
      <xsl:variable name="insertName" select="@name" />
      <xsl:for-each select="ancestor::root/service/*">
        <xsl:if test="current()/@name = $insertName">
          <xsl:apply-templates select="*" />
        </xsl:if>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="content">
    <xsl:for-each select="*">
      <xsl:apply-templates select="." />
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="items">
    <xsl:apply-templates select="node()" />
  </xsl:template>

  <xsl:template match="item">
    <xsl:if test="@hidden != true()">
      <xsl:call-template name="itemText">
        <xsl:with-param name="item" select="." />
        <xsl:with-param name="class">text</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="subitem">
    <xsl:call-template name="itemText">
      <xsl:with-param name="item" select="." />
      <xsl:with-param name="class">text</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="itemText">
    <xsl:param name="item" />
    <xsl:param name="class" />

    <xsl:if test="$item/content/node() != ''">
      <div>
        <xsl:attribute name="class">
          <xsl:value-of select="'pdd-item'" />
        </xsl:attribute>

        <xsl:if test="$item/@data-description != ''">
          <xsl:attribute name="data-description">
            <xsl:value-of select="$item/@data-description" />
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="$item/@data-description" />
          </xsl:attribute>
        </xsl:if>
        
        <xsl:if test="$item/@id != ''">
          <xsl:attribute name="id">
            <xsl:value-of select="$item/@id" />
          </xsl:attribute>
        </xsl:if>
          
        <xsl:if test="$item/@data-audio != ''">
            <xsl:element name="span">
              <xsl:attribute name="class">
                <xsl:value-of select="'audio glyphicon glyphicon-play-circle'" />
              </xsl:attribute>
              <xsl:attribute name="data-audio">
                <xsl:value-of select="$item/@data-audio" />
              </xsl:attribute>
              <xsl:text disable-output-escaping="yes"><![CDATA[&#x200B;]]></xsl:text>
            </xsl:element>
        </xsl:if>
              
        <xsl:if test="$item/content/span/node() != ''">
        <div>
          <xsl:attribute name="class">
            <xsl:value-of select="$class" />
          </xsl:attribute>

          <xsl:if test="$item/@nb != ''">
            <span>
              <xsl:attribute name="class">
                <xsl:value-of select="'pdd-num'" />
              </xsl:attribute>
              <xsl:if test="$item/@hidenb = true()">
                <xsl:attribute name="style">
                  <xsl:value-of select="'display:none'" />
                </xsl:attribute>
              </xsl:if>
              <xsl:value-of disable-output-escaping="yes" select="concat($item/@nb, '.')" />
            </span>
            <xsl:if test="$item/@hidenb != true()">
              <xsl:text>&#160;</xsl:text>
            </xsl:if>
          </xsl:if>

          <xsl:choose>
            <xsl:when test="$item/content/span/@class = 'header'">
              <xsl:copy-of select="$item/content/span/node()" />
            </xsl:when>
            <xsl:otherwise>
              <span>
                <xsl:attribute name="class">
                  <xsl:value-of select="'pdd-text'" />
                </xsl:attribute>
                <xsl:apply-templates select="$item/content/span/node()" />
              </span>
            </xsl:otherwise>
          </xsl:choose>
        </div>
        </xsl:if>
        <xsl:apply-templates select="$item/content/items|$item/itemsPDDSign" />
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="name">
    <xsl:apply-templates select="*|node()" />
  </xsl:template>
  
  <xsl:template match="service">
  </xsl:template>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nbsp">
    <xsl:text>&#160;</xsl:text>
  </xsl:template>

  <xsl:template match="sp">
    <xsl:text>&#160;</xsl:text>
  </xsl:template>

  <xsl:template match="spc">
    <xsl:text>&#32;</xsl:text>
  </xsl:template>

  <xsl:template match="acute">
    <xsl:text disable-output-escaping="yes">&#38;#769;</xsl:text>
  </xsl:template>

  <xsl:template match="nowrap">
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="'nowrap'" />
      </xsl:attribute>
      <xsl:apply-templates select="*|node()" />
    </span>
  </xsl:template>

  <xsl:template name="row">
    <xsl:param name="signGroup" />
    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="'pictures'" />
      </xsl:attribute>
      <xsl:apply-templates select="$signGroup" />
    </div>
  </xsl:template>

  <xsl:template match="itemSignGroup">
    <xsl:variable name="imgs" select="items/itemSign/content/a/img" />
    <xsl:variable name="imgsWidth">
      <xsl:call-template name="imgWidthSum">
        <xsl:with-param name="imgGroup"  select="$imgs" />
      </xsl:call-template>
    </xsl:variable>

    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="'pdd-item'" />
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="@id" />
      </xsl:attribute>

        <xsl:if test="@data-audio != ''">
            <xsl:element name="span">
              <xsl:attribute name="class">
                <xsl:value-of select="'audio glyphicon glyphicon-play-circle'" />
              </xsl:attribute>
              <xsl:attribute name="data-audio">
                <xsl:value-of select="@data-audio" />
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:value-of select="'Воспроизвести/пауза'" />
              </xsl:attribute>
              <xsl:text disable-output-escaping="yes"><![CDATA[&#x200B;]]></xsl:text>
            </xsl:element>
        </xsl:if>

      <div>
        <xsl:attribute name="class">
          <xsl:variable name="large" select="@large" />
          <xsl:choose>
            <xsl:when test="1 >= count(items/itemSign)">
              <xsl:choose>
                <xsl:when test="$large != ''">
                  <xsl:value-of select="concat('sign-groupe sign-large', $large)" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'sign-groupe'" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$large != ''">
                  <xsl:value-of select="concat('sign-groupe sign-multisign sign-large', $large)" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'sign-groupe sign-multisign'" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        
        <xsl:for-each select="items/itemSign">
          <div>
            <xsl:attribute name="class">
              <xsl:value-of select="'sign'" />
            </xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="@id" />
            </xsl:attribute>
            <xsl:apply-templates select="content" />
            <xsl:if test="@nb != ''">
              <span>
                <xsl:attribute name="class">
                  <xsl:value-of select="'caption-sign'" />
                </xsl:attribute>
                <xsl:value-of select="@nb" />
              </span>
            </xsl:if>
          </div>
        </xsl:for-each>

        <xsl:if test="content/node() != ''">
          <span>
            <xsl:attribute name="class">
              <xsl:value-of select="'caption-groupe'" />
            </xsl:attribute>
            <xsl:apply-templates select="content" />
          </span>
        </xsl:if>
      </div>
      <xsl:apply-templates select="signText" />
    </div>
  </xsl:template>

  <xsl:template match="itemsPDDSign">
    <xsl:for-each select=".">
      <xsl:apply-templates select="itemPDDSign/content" />
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="signText">
    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="'text'" />
      </xsl:attribute>
      <span>
        <xsl:attribute name="class">
          <xsl:value-of select="'pdd-text'" />
        </xsl:attribute>
        <xsl:apply-templates select="node()" />
      </span>
    </div>
  </xsl:template>

  <xsl:template match="signTextP">
    <xsl:apply-templates select="node()" />
  </xsl:template>
  
  <xsl:template match="itemSign">
    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="'sign'" />
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="@id" />
      </xsl:attribute>
      <xsl:apply-templates select="content" />
      <xsl:if test="@nb != ''">
        <span>
          <xsl:attribute name="class">
            <xsl:value-of select="'caption'" />
          </xsl:attribute>
          <xsl:value-of select="@nb" />
        </span>
      </xsl:if>

      <span>
        <xsl:attribute name="class">
          <xsl:value-of select="'caption-link'" />
        </xsl:attribute>
        <xsl:apply-templates select="../../content" />
      </span>
    </div>
  </xsl:template>

  <xsl:template name="imgPercent">
    <xsl:param name="img" />
    <xsl:variable name="percent">
      <xsl:choose>
        <xsl:when test="boolean(number($img/@percent)) != boolean(NaN)">
          <xsl:value-of select="number($img/@percent)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number(100)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="number($percent) * number(0.01) * number($percentImgSizeGlobal)" />
  </xsl:template>

  <xsl:template name="imgWidth">
    <xsl:param name="img" />
    <xsl:variable name ="percent">
      <xsl:call-template name="imgPercent">
        <xsl:with-param name="img" select="." />
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="round(number(scripts:getImgWidth($img/@src)) * number($percent) * number(0.01))" />
  </xsl:template>

  <xsl:template name="imgHeight">
    <xsl:param name="img" />
    <xsl:variable name ="percent">
      <xsl:call-template name="imgPercent">
        <xsl:with-param name="img" select="." />
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="round(number(scripts:getImgHeight($img/@src)) * number($percent) * number(0.01))" />
  </xsl:template>

  <xsl:template match="img">
    <xsl:variable name="filePath" select="scripts:getImgURL(@src)" />
    <img>
      <xsl:apply-templates select="@*" />
      <xsl:attribute name="src">
        <xsl:value-of select="$filePath" />
      </xsl:attribute>
    </img>
  </xsl:template>

  <xsl:template name="styleRow">
    <xsl:param name="widthMin" />
    <xsl:param name="height" />
    <xsl:value-of select="concat('min-width:', $widthMin,'px;', 'height:', $height,'px; display:block; text-align:center; clear:both;')" />
    <xsl:if test="$showBorder = 'true'">
      <xsl:value-of select="'border:2px solid #ffffff;'" />      
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="styleCentr">
    <xsl:param name="width" />
    <xsl:param name="height" />
    <xsl:value-of select="concat('width:', $width,'px;', 'height:', $height,'px; display:block; text-align:center; clear:both;')" />
    <xsl:if test="$showBorder = 'true'">
      <xsl:value-of select="'border:2px solid #000000;'" />
    </xsl:if>
  </xsl:template>

  <xsl:template name="styleSignGroup">
    <xsl:param name="width" />
    <xsl:param name="height" />
    <xsl:value-of select="concat('width:', $width,'px;', 'height:', $height,'px; display:block; float:left; ')" />
    <xsl:if test="$showBorder = 'true'">
      <xsl:value-of select="'border:2px solid #ff0000;'" />
    </xsl:if>
  </xsl:template>

  <xsl:template name="styleItemSignGroup">
    <xsl:param name="width" />
    <xsl:param name="height" />
    <xsl:value-of select="concat('width:', $width,'px;', 'height:', $height,'px; display:block; float:left;')" />
    <xsl:if test="$showBorder = 'true'">
      <xsl:value-of select="'border:2px solid #ff0000;'" />
    </xsl:if>
  </xsl:template>

  <xsl:template name="widthSum">
    <xsl:param name="signGroup" />
    <xsl:variable name="ws" select="sum($signGroup/@width)" />
    <xsl:variable name="wb">
      <xsl:choose>
        <xsl:when test="$showBorder = 'true'">
          <xsl:value-of select="count($signGroup) * (4 + 4)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$ws + $wb" />
  </xsl:template>

  <xsl:template name="heightMax">
    <xsl:param name="signGroup" />
    <xsl:call-template name="heightMaxWhile">
      <xsl:with-param name="signGroup" select="$signGroup" />
      <xsl:with-param name="i" select="2" />
      <xsl:with-param name="result" select="$signGroup[1]/@height" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="heightMaxWhile">
    <xsl:param name="signGroup" />
    <xsl:param name="i" />
    <xsl:param name="result" />

    <xsl:choose>
      <xsl:when test="$i &lt; count($signGroup) + 1">
        <xsl:call-template name="heightMaxWhile">
          <xsl:with-param name="signGroup" select="$signGroup" />
          <xsl:with-param name="i" select="$i + 1" />
          <xsl:with-param name="result">
            <xsl:choose>
              <xsl:when test="$result &lt; $signGroup[$i]/@height">
                <xsl:value-of select="$signGroup[$i]/@height" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$result" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$result" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="imgWidthSum">
    <xsl:param name="imgGroup" />
    <xsl:call-template name="imgWidthSumWhile">
      <xsl:with-param name="imgGroup" select="$imgGroup" />
      <xsl:with-param name="i" select="1" />
      <xsl:with-param name="result" select="0" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="imgWidthSumWhile">
    <xsl:param name="imgGroup" />
    <xsl:param name="i" />
    <xsl:param name="result" />
    <xsl:choose>
      <xsl:when test="$i &lt; count($imgGroup) + 1">
        <xsl:call-template name="imgWidthSumWhile">
          <xsl:with-param name="imgGroup" select="$imgGroup" />
          <xsl:with-param name="i" select="$i + 1" />
          <xsl:with-param name="result">
            <xsl:variable name="width">
              <xsl:call-template name="imgWidth">
                <xsl:with-param name="img" select="$imgGroup[$i]" />
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$result + $width" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$result" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="service">
  </xsl:template>
  <xsl:template match="additions">
  </xsl:template>

  <xsl:template match="decree|chapter|appendix|paragraph">
    <div>
      <xsl:attribute name="id">
        <xsl:value-of select="@id" />
      </xsl:attribute>
      
      <xsl:apply-templates select="*" />
    </div>
  </xsl:template>

  <xsl:template match="chapters">
    <xsl:apply-templates select="*" />
  </xsl:template>  

  <xsl:template name="htmlBegin2">
    <xsl:text disable-output-escaping="yes" xml:space="preserve">
      <![CDATA[
      <!DOCTYPE html PUBLIC ' -//W3C//DTD XHTML 1.0 Transitional//EN' 
      'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
      <html>
        <head>
          <style>
            a:link {color:#000020; text-decoration:none;}
            a:visited {color:#000020;text-decoration:none;}
            a:hover {color:#00ffc0;text-decoration:underline;}
            a:active {color:#000020; text-decoration:none;}
            
            a.TableContent:link {color:#000020; text-decoration:none;}
            a.TableContent:visited {color:#000020;text-decoration:none;}
            a.TableContent:hover {color:#00ffc0;text-decoration:underline;}
            a.TableContent:active {color:#000020; text-decoration:none;}
            a.TableContent {font-size:8pt;}
  
            a.CurrentContent:link {color:#00ffc0; text-decoration:none;}
            a.CurrentContent:visited {color:#00ffc0;text-decoration:none;}
            a.CurrentContent:hover {color:#00ffc0;text-decoration:underline;}
            a.CurrentContent:active {color:#00ffc0; text-decoration:none;}
            a.CurrentContent {font-size:8pt;}

            img {border:none;vertical-align:middle;}
            img.cpr {float:none;margin:0 5px 0 0;vertical-align:middle;}

            .head1 {font-family:'Times New Roman'; font-size:16pt; text-align:center;}
            .head2 {font-family:'Times New Roman'; font-size:14pt; font-weight:bold; text-align:center;}
            .signatureLeft {font-weight:bold; vertical-align:bottom; text-align:left;}
            .signatureRight {font-weight:bold; vertical-align:bottom; text-align:right;}
            .text {font-size:12pt; text-align:justify; text-indent:2em;}
            .textToolTip {font-size:10pt; text-align:left; text-indent:2em;}
          </style>
        </head>
      ]]>
    </xsl:text>
  </xsl:template>

  <xsl:template name="htmlBeginBody2">
    <xsl:text disable-output-escaping="yes" xml:space="preserve">
      <![CDATA[
          <body style='background-color:#f0f0ff'>
      ]]>
    </xsl:text>
  </xsl:template>

  <xsl:template name="htmlEnd2">
    <xsl:text disable-output-escaping="yes" xml:space="preserve">
      <![CDATA[
          </body>
        </html>
      ]]>
    </xsl:text>
  </xsl:template>

  <xsl:template name="htmlBeginBodyToolTip2">
    <xsl:text disable-output-escaping="yes" xml:space="preserve">
      <![CDATA[
          <body style='background-color:#ffffe1'>
      ]]>
    </xsl:text>
  </xsl:template>

  <xsl:template name="htmlBegin">
  </xsl:template>

  <xsl:template name="htmlBeginBody">
  </xsl:template>
  
  <xsl:template name="htmlEnd">
  </xsl:template>

  <xsl:template name="htmlBeginBodyToolTip">
  </xsl:template>
</xsl:stylesheet>