<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the Extended DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Apply Rules which	apply to image nodes only -->
	<xsl:template match="image" mode="image-pattern">
		<!-- style rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">image</xsl:with-param>
			<xsl:with-param name="role">style</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="image-style-rules"/>
		<xsl:call-template name="custom-image-style-rules"/>
		<!-- structure rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">image</xsl:with-param>
			<xsl:with-param name="role">structure</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="image-structure-rules"/>
	</xsl:template>
	<!--
		Special Style Rules for <image>elements
	-->
	<xsl:template name="custom-image-style-rules">

		<!--
			CUSTOM RULE : image-product-filtered-not-included  <image>-   Images filtered by product should be placed in an includes file
		-->
		<xsl:if test="./@product and not(./@product='') and not(ancestor::*/@id='includes')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">image-product-filtered-not-included</xsl:with-param>
				<xsl:with-param name="test">./@product and not(./@product='') and not(ancestor::*/@id='includes')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="./@product"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>