<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="utf-8" media-type="text/html" omit-xml-declaration="yes" />
    <xsl:param name="chapter"></xsl:param>
    <xsl:variable name="chaps" select="root/ul/li"></xsl:variable>
    <xsl:template match="/">
        <xsl:apply-templates select='root/branch' />
    </xsl:template>
    <xsl:template match="branch">
        <li>
            <label>
                <xsl:element name='a'>
                    <xsl:attribute name='href'>#</xsl:attribute>
                    <xsl:attribute name='class'>ajaxlink</xsl:attribute>
                    <xsl:attribute name='title'>
                        <xsl:value-of select='@tooltip'></xsl:value-of>
                    </xsl:attribute>
                    <xsl:value-of select='@text'></xsl:value-of>
                </xsl:element>
                <xsl:element name='ul'>
                    <xsl:attribute name='rel'>0</xsl:attribute>
                    <xsl:attribute name='class'>themesEnum</xsl:attribute>
                    <xsl:attribute name='data-code'>
                        <xsl:value-of select='@code'></xsl:value-of>
                    </xsl:attribute>
                    <xsl:apply-templates select='branch' />
                    <xsl:apply-templates select='$chaps' >
                        <xsl:with-param name='rel' select='@code'></xsl:with-param>
                    </xsl:apply-templates>
                </xsl:element>
            </label>
        </li>
    </xsl:template>
    <xsl:template match="li">
        <xsl:param name="rel" />
        <xsl:if test='@rel = $rel'>
            <li>
                <xsl:apply-templates select='a'/>
            </li>
        </xsl:if>
    </xsl:template>
    <xsl:template match="a">
        <xsl:element name='a'>
            <xsl:choose>
                <xsl:when test='@href != $chapter'>
                    <xsl:attribute name='href'>
                        <xsl:value-of select='@href'></xsl:value-of>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name='class'>currchapter</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select='.'></xsl:value-of>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>