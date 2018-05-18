<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the Extended DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Apply Rules which apply to all nodes  -->
	<xsl:template match="*" mode="common-pattern">

		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">common</xsl:with-param>
			<xsl:with-param name="role">content</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates mode="common-content-rules" select="//*[text()]"/>
		<xsl:apply-templates mode="common-comment-rules" select="//*[comment()]"/>
		<xsl:apply-templates mode="common-textual-rules" select="//*[text()]"/>


		<xsl:apply-templates mode="custom-style-rules" select="//*"/>

		<!-- structure rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">common</xsl:with-param>
			<xsl:with-param name="role">structure</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates mode="conref-structure-rules" select="//*[@conref]"/>
		
		<!-- style rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">common</xsl:with-param>
			<xsl:with-param name="role">style</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates mode="colsep-style-rules" select="//*[@colsep]"/>
		<xsl:apply-templates mode="conref-style-rules" select="//*[@conref]"/>
		<xsl:apply-templates mode="href-style-rules" select="//*[@href]"/>
		<xsl:apply-templates mode="id-style-rules" select="//*"/>
		<xsl:apply-templates mode="rowsep-style-rules" select="//*[@rowsep]"/>
		
	</xsl:template>
	<!--
		Custom DITA Style Rules - attribute values
	-->
	<xsl:template match="*" mode="custom-style-rules">

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
				element-blacklisted - <concept>is a banned element in our DITA
		-->
		<xsl:if test="name()='concept'">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">element-blacklisted</xsl:with-param>
				<xsl:with-param name="test">@id ='content'</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			CUSTOM RULE - New restriction
				element-blacklisted -  <task>is a banned element in our DITA
		-->
		<xsl:if test="name()='task'">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">element-blacklisted</xsl:with-param>
				<xsl:with-param name="test">@id ='content'</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>