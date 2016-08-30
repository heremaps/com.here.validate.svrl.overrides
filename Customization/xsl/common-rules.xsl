<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the Extended DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml"
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 xmlns:saxon="http://saxon.sf.net/"
	 xmlns:java="http://www.java.com/"
	 exclude-result-prefixes="java saxon"
	 version="2.0">


		<!-- Apply Rules which apply to all nodes  -->
	<xsl:template match="*" mode="common-pattern">
		<active-pattern name="common-style-rules" role="style">
			<xsl:apply-templates mode="common-style-rules" select="//*"/>
			<xsl:apply-templates mode="custom-style-rules" select="//*"/>
		</active-pattern>
		<active-pattern name="common-content-rules" role="content">
			<xsl:apply-templates mode="common-content-rules" select="//*[text()]"/>
			<xsl:apply-templates mode="common-comment-rules" select="//*[comment()]"/>
			<xsl:apply-templates mode="common-spelling-rules" select="//*[text()]"/>
		</active-pattern>
		<xsl:if test="//*[@conref]">
			<active-pattern name="common-structure-rules" role="structure">
				<xsl:apply-templates mode="conref-structure-rules" select="//*[@conref]"/>
			</active-pattern>
		</xsl:if>
	</xsl:template>

	<!--
		Custom DITA Style Rules - attribute values
	-->
	<xsl:template match="*" mode="custom-style-rules">
		<xsl:call-template name="fired-rule"/>
		<!--
			CUSTOM RULE - New restriction
			id-blacklisted - No element is allowed to use the id="content"
		-->
		<xsl:if test="@id ='content'">
			 <xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">id-blacklisted</xsl:with-param>
				<xsl:with-param name="test">@id ='content'</xsl:with-param>
			</xsl:call-template>
		</xsl:if>

		<!--
			CUSTOM RULE - New restriction
				element-blacklisted - <concept> is a banned element in our DITA
		-->
		<xsl:if test="name()='concept'">
			 <xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">element-blacklisted</xsl:with-param>
				<xsl:with-param name="test">@id ='content'</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			CUSTOM RULE - New restriction
				element-blacklisted -  <task> is a banned element in our DITA
		-->
		<xsl:if test="name()='task'">
			 <xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">element-blacklisted</xsl:with-param>
				<xsl:with-param name="test">@id ='content'</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
