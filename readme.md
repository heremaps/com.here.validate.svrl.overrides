

Extended DITA Validator for DITA-OT
===================================

Copyright (c) 2018 HERE Europe B.V.

See the [LICENSE](LICENSE) file in the root of this project for license details.

[![DITA-OT 3.0](https://img.shields.io/badge/DITA--OT-3.0-blue.svg)](http://www.dita-ot.org/3.0/)
[![Build Status](https://travis-ci.org/jason-fox/com.here.validate.svrl.overrides.svg?branch=master)](https://travis-ci.org/jason-fox/com.here.validate.svrl.overrides)
[![license](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)


The [DITA Validator](https://github.com/jason-fox/com.here.validate.svrl) plug-in is a structure, style and content checker for DITA documents. The base [DITA Validator](https://github.com/jason-fox/com.here.validate.svrl) returns information about the compliance of the document against a modifiable series of validator rules. The plug-in also supports standard XML validation.

This plug-in is an  **extension**  of the base [DITA Validator](https://github.com/jason-fox/com.here.validate.svrl), and shows how to add, remove or extend the ruleset of the base [DITA Validator](https://github.com/jason-fox/com.here.validate.svrl). Developers should examine the files structure within the plug-in to see how to do this.


The **Extended** Validator plug-in is a demonstration module. It is assumed that developers will modify the supplied ruleset to suit their individual business case. Like the base [DITA Validator](https://github.com/jason-fox/com.here.validate.svrl), it supports two transtypes - it can either echo results to the command line or return a report in Schematron Validation Report Language (SVRL) format. More information about SVRL can be found at [www.schematron.com](http://www.schematron.com/validators.html)

Contents
========

- [Introduction](#introduction)
  * [What Is Valid XML?](#what-is-valid-xml)
  * [Validator compliant DITA](#validator-compliant-dita)
- [Prerequisites](#prerequisites)
  * [Installing DITA-OT](#installing-dita-ot)
  * [Installing the Base Validator Plug-in](#installing-the-base-validator-plug-in)
  * [Installation the Extended Validator Plug-in](#installation-the-extended-validator-plug-in)
- [Usage](#usage)
  * [Validating a document from the Command line](#validating-a-document-from-the-command-line)
    + [Creating an SVRL file](#creating-an-svrl-file)
    + [Echoing results to the command line](#echoing-results-to-the-command-line)
    + [Parameter Reference](#parameter-reference)
  * [Validating a document using Ant](#validating-a-document-using-ant)
- [Customizing the Validator](#customizing-the-validator)
  * [Adding New Validator Rules](#adding-new-validator-rules)
    + [Internationalization](#internationalization)
  * [Ignoring Validator Rules](#ignoring-validator-rules)
    + [Removing validator rules globally](#removing-validator-rules-globally)
    + [Ignoring a validator rule throughout a document](#ignoring-a-validator-rule-throughout-a-document)
    + [Ignoring a specific instance of a validator rule](#ignoring-a-specific-instance-of-a-validator-rule)
- [Sample Document](#sample-document)
- [Validator Error Messages](#validator-error-messages)
  * [Content Validation](#content-validation)
  * [Style Validation](#style-validation)
  * [Structure Validation](#structure-validation)


Introduction
============

What Is Valid XML?
------------------

For any DITA publication to build successfully, all its files must contain valid DITA markup.

General XML validation rules require that:

-	Documents are well formed.
-	Documents contain only correctly encoded legal Unicode characters.
-	None of the special syntax characters such as "<" and "&" appear except as markup delineators.
-	The beginning and end tags must match exactly.
-	A single root element contains all the other elements.
-	Each `<topic>` within document must conform to the `topic.dtd` Document Type Defintion

Validator compliant DITA
------------------------

The DITA Validator extends the concept of XML validation to run a series of compliance rules.	Sample rules include:


-	Whether the source files for	`<image>` and `<codeblock>` elements exist
-	Whether `conref` attributes are linking to missing elements
-	Whether every	`<section>` or `<fig>` element in the document has a meaningful `id`
-	Whether every `<section>` element has a title
-	If an `<xref>` refers to a location on the web, both the `scope="external"` and `format="html"` attributes must be set
-	Whether all `id` attributes are lower case and dash separated
-	Whether any blacklisted words are found within the document.
-	Whether the document will be unable as PDF render due to empty `<table>` elements


The extended plug-in shows how to add additional rules, and includes some extra rules which may or may not be applicable to  your documentation set.



Prerequisites
=============

The  Extended validator has been tested against DITA-OT 3.0.x.  It is recommended that you upgrade to the latest version. Running the validator plug-in against DITA-OT 1.8.5 or earlier versions of DITA-OT will not work as it uses the newer `getVariable` template. To work with DITA-OT 1.8.5 this would need to be refactored to use `getMessage`. The validator can be run safely against DITA-OT 2.x if the diagnostic messages are removed and a `conductor.xml` is added to replace the `ant.import` statements in the `plugin.xml` - it also does not need to specially invoke the older Saxon XSLT processor.

Installing DITA-OT
------------------

The Extended Validator is a plug-in for the DITA open toolkit. Futhermore, it is not a stand alone plug-in as it extends the base validator plug-in.

-  install the DITA-OT distribution JAR file dependencies by running `gradle install` from your clone of the [DITA-OT repository](https://github.com/dita-ot/dita-ot).

The required dependencies are installed to a local Maven repository in your home directory under `.m2/repository/org/dita-ot/dost/`.

-  Run the Gradle distribution task to generate the plug-in distribution package:

```console
./gradlew dist
```

The distribution ZIP file is generated under `build/distributions`.

Installing the Base Validator Plug-in
--------------------------------------

-  Run the plug-in installation command:

```console
dita -install https://github.com/jason-fox/com.here.validate.svrl/archive/master.zip
```


Installation the Extended Validator Plug-in
-------------------------------------------

-  Run the plug-in installation command:

```console
dita -install https://github.com/jason-fox/com.here.validate.svrl.overrides/archive/master.zip
```

The `dita` command line tool requires no additional configuration.


Usage
=====

Validating a document from the Command line
-------------------------------------------

A test document can be found within the plug-in at `dita_docs/dita_ot/plugins/com.here.validate.svrl.overrides/sample`

### Creating an SVRL file

To create an SVRL file with this **extended** plug-in (where the results will include overriden rules) use the `overrides` transform. This transform is an override of the base SVRL file creation (`svrl`) transform.

-  From a terminal prompt move to the directory holding the document to validate

-  SVRL file creation can be run like any other DITA-OT transform:

```
PATH_TO_DITA_OT/bin/dita -f overrides -o out -i document.ditamap
```

Once the command has run, an SVRL file is created

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<svrl:schematron-output>
	<active-pattern name="common-content-rules" role="content">
		<fired-rule context="title"/>
		<fired-rule context="p"/>
		<fired-rule context="section[id=&#34;good&#34;]"/>
		<fired-rule context="title"/>
		<fired-rule context="section[id=&#34;bad&#34;]"/>
		<fired-rule context="title"/>
		<failed-assert location="/topics/comment-fixme.dita" role="warning">
			<diagnostic-reference diagnostic="comment-fixme">Line 15: section[id="bad"] - [comment-fixme]
				Found 'FIXME' comments within the &lt;section&gt; element - fix as requested and delete the comment.
				FIXME 61) This comment requires action
			</diagnostic-reference>
		</failed-assert>
	</active-pattern>
</svrl:schematron-output>
```

### Echoing results to the command line

To echo results to the command line with this **extended** plug-in (where the results will include overriden rules) use the `overrides-echo` transform. This transform is an override of the base DITA document validation (`svrl-echo`) transform.


```console
rm -rf ./out
```

-  Extended Document validation (`overrides-echo`) can be run like any other DITA-OT transform:

```console
PATH_TO_DITA_OT/bin/dita -f overrides-echo -i document.ditamap
```

Once the command has run, all errors and warnings are echoed to the command line

```console
[echo] [WARN]	 [/out/temp/dita/topics/comment-fixme.dita]
[echo]	 Line 15: section[id="bad"] - [comment-fixme]
[echo] Found 'FIXME' comments within the <section> element - fix as requested and delete the comment.
[echo]
[echo]	FIXME 61) This comment requires action
[echo]
[echo] Found 0 Errors 1 Warnings
```
Additionally, if an error occurs, the command will fail

```console
[echo] [ERROR]	[/document.ditamap]
[echo]	 Line 89: topicref - [href-not-lower-case]
[echo] The value provided in href="topics/FILE-NOT-LOWER-CASE.dita" is invalid, allowed characters are: lowercase, a-z only, words separated by hyphens.
[echo]
[echo] Found 1 Errors 0 Warnings
Error: Errors detected during validation
```


### Parameter Reference

- `args.validate.ignore.rules` - Comma separated list of rules not to be enforced
- `args.validate.blacklist` - Comma separated list of words not to be present in the running text
- `args.validate.check.case` - Comma separated list of words which have a specified capitalization
- `args.validate.mode` - Validation reporting mode. The following values are supported:
	- `strict`	- Outputs both warnings and errors. Fails on errors and warnings.
	- `default` - Outputs both warnings and errors. Fails on errors only
	- `lax`		- Ignores all warnings and outputs errors only. Fails on Errors only
- `svrl.customization.dir` - Specifies the customization directory
- `svrl.filter.file` - Specifies the location of the XSL file used to filter the echo output


Validating a document using Ant
-------------------------------

An Ant build file is supplied in the same directory as the sample document. The main target can be seen below:

```xml
<dirname property="dita.dir" file="PATH_TO_DITA_OT"/>
<property name="dita.exec" value="${dita.dir}/bin/dita"/>
<property name="args.input" value="PATH_TO_DITA_DOCUMENT/document.ditamap"/>

<target name="validate" description="validate a document">
	<exec executable="${dita.exec}" osfamily="unix" failonerror="true">
		<arg value="-input"/>
		<arg value="${args.input}"/>
		<arg value="-output"/>
		<arg value="${dita.dir}/out/svrl"/>
		<arg value="-format"/>
		<arg value="overrides-echo"/>
		<!-- validation transform specific parameters -->
		<arg value="-Dargs.validate.blacklist=(kilo)?metre|colour|teh|seperate"/>
		<arg value="-Dargs.validate.check.case=Bluetooth|HTTP[S]? |IoT|JSON|Java|Javadoc|JavaScript|XML"/>
		<arg value="-Dargs.validate.color=true"/>
	</exec>
	<!-- For Windows run from a DOS command -->
	<exec dir="${dita.dir}/bin" executable="cmd" osfamily="windows" failonerror="true">
		<arg value="/C"/>
		<arg value="dita -input ${args.input} -output ${dita.dir}/out/svrl -format svrl-echo -Dargs.validate.blacklist=&quot;(kilo)?metre|colour|teh|seperate&quot; -Dargs.validate.check.case=&quot;Bluetooth|HTTP[S]? |IoT|JSON|Java|Javadoc|JavaScript|XML&quot;"/>
	</exec>	
</target>
```


Customizing the Validator
=========================

Adding New Validator Rules
--------------------------

The file `dita2svrl.xsl` within the `com.here.validate.svrl.overrides` overrides the base-rule set, and uses its own Customizations:

```xml
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:xs="http://www.w3.org/2001/XMLSchema"
     xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
     version="2.0">

    <xsl:import href="plugin:com.here.validate.svrl:xsl/dita2svrl.xsl"/>
    <xsl:import href="../Customization/xsl/common-rules.xsl"/>
    <!--xsl:import href="../Customization/xsl/fop-rules.xsl"/-->
    <!--xsl:import href="../Customization/xsl/codeblock.xsl"/-->
    <xsl:import href="../Customization/xsl/image.xsl"/>
    <!--xsl:import href="../Customization/xsl/section.xsl"/-->
    <xsl:import href="../Customization/xsl/topic.xsl"/>
    <!--xsl:import href="../Customization/xsl/xref.xsl"/-->
</xsl:stylesheet>
```

If an `xsl:import` is commented out, this means that the base validator ruleset has not been customized. Most customization transforms are usually named after the DITA element they are run against.

Let us assume that we want to add a rule to validate `<section>` elements: validation must fail if a `<section>` has no `id` attribute.
To add the rule, you need to uncomment the line `<xsl:import href="../Customization/xsl/section.xsl"/>` and in this case copy over the existing `section.xsl` file from  the com.here.validate.svrl  plugin.

This transform consists of two separate templates, the active-pattern template at the head of the file which fire style, structure and content rules-sets

```xml
<!-- Apply Rules which   apply to section nodes only -->
<xsl:template match="section" mode="section-pattern">
    <active-pattern name="section-rules" role="style">
        <xsl:call-template name="section-style-rules" />
    </active-pattern>
</xsl:template>
```

and a series of rules fired from within that active-pattern :

```xml
<xsl:template name="section-style-rules">
    <xsl:call-template name="fired-rule"/>
    <!-- For all non-conref'd sections -->
    <xsl:if test="not(@conref)">
        <!--
            section-title-missing - section must have a title
        -->
        <xsl:if test="not(title)">
            <xsl:call-template name="failed-assert">
                    <xsl:with-param name="rule-id">section-title-missing</xsl:with-param>
                    <xsl:with-param name="test">not(title)</xsl:with-param>
                </xsl:call-template>
        </xsl:if>
    </xsl:if>
</xsl:template>
```

To add an additional rule, add a new `<xsl:if>` block containing a call to failed-assert as shown:
New Rule

```xml
<!--
    section-id-missing - section must have an id attribute
-->
<xsl:if test="not(@id)">
    <xsl:call-template name="failed-assert">
        <xsl:with-param name="rule-id">section-id-missing</xsl:with-param>
        <xsl:with-param name="test">not(title)</xsl:with-param>
        <xsl:with-param name="human-text">id attribute is mandatory </xsl:with-param>
    </xsl:call-template>
</xsl:if>
```

The new rule must have a unique id and readable text.
When a validation rule is not satisfied, the Validator prints out an error message. Here is an example:

```console
[echo]      [xslt] [ERROR][map_tile/dev_guide/topics/example-basemap.dita:17]
[echo]      [xslt] A {section} requires an 'id' attribute is mandatory
```

### Internationalization

To internationalize your error messages, remove the `human-text` parameter from the test above:

```xml
<!--
    section-id-missing - section must have an id attribute
-->
<xsl:if test="not(@id)">
    <xsl:call-template name="failed-assert">
        <xsl:with-param name="rule-id">section-id-missing</xsl:with-param>
        <xsl:with-param name="test">not(title)</xsl:with-param>
    </xsl:call-template>
</xsl:if>
```

Now add the messages into language files found within the `cfg/common/vars` directory:

```xml
<vars>
  <variable id="element-blacklisted">Das &lt;@NAME&gt; Element entspricht nicht dem DITA Dokumentationsstandard. Weitere Informationen finden Sie im Documentation Platform User Guide.</variable>
  <variable id="id-blacklisted">ID-Werte dürfen nicht das Wort 'content' enthalten. Ändern Sie den iD-Wert.</variable>
...etc

  <variable id="section-id-missing">Geben Sie in &lt;@NAME&gt; Elementen immer einen ID-Wert an.</variable>

</vars>
```


Ignoring Validator Rules
------------------------

### Removing validator rules globally

This DITA-OT plug-in is an extension of the [base DITA validator](https://github.com/jason-fox/com.here.validate.svrl) and includes an example within its XSL files to show how to remove rules globally. Please examine the code to see how to do this.

### Ignoring a validator rule throughout a document

Individual rules can be ignored by adding the `args.validate.ignore.rules` parameter to the command line. The value of the parameter should be a comma-delimited list of each `rule-id` to ignore.

For example to ignore the `table-id-missing` validation rule within a document you would run:

```console
/path-to-dita-ot/dita -f svrl-echo -i document.ditamap -Dargs.validate.ignore.rules=table-id-missing
```


### Ignoring a specific instance of a validator rule

Specific instances of a rule can be ignored by adding a comment within the `*.dita` file. The comment should start with `ignore-rule`, and needs to be added at the location where the error is flagged.

```xml
<!--
	This is just an empty table for adding space in the PDF only,
	it doesn't need an id since it won't appear in HTML
-->
<table platform="pdfonly" frame="none" >
	<!-- ignore-rule:table-id-missing -->
	<tgroup cols="1">
		<colspec colname="c1" colnum="1" colwidth="336pt"/>
		<tbody>
			<row>
				<entry>&#xA0;</entry>
			</row>
		</tbody>
	</tgroup>
</table>
```

Some rules such as FIXME and TODO in the running text need to be double escaped as shown below:

 - Add a comment line with the text `ignore-rule:running-text-*` to ignore the issue flagged in the text below (no FIXMEs allowed in the running text)
 - Add the `comment-*` to the list of ignored rules	to ignore the fact that the comment itself fails an addition rule (no FIXMEs allowed in the comments)

```xml
<!--
	We want to display the text below which would usually
	result in a warning
-->
<p>
	<!-- ignore-rule:running-text-fixme,comment-fixme -->
	FIXME is usually banned in the running text.
</p>
```



Sample Document
===============

A sample document can be found within the plug-in which can used to test validator rules. The document covers with positive and negative test cases. The sample document contains broken DITA which cannot be built as a PDF document - please use the `html` transform to read the contents or examine the `*.dita` files directly.

A complete list of rules covered by the DITA validator can be found below. The final `<chapters>` of the sample document contain a set of test DITA `<topics>`, each demonstrating a broken validation rule.

The `<topic>` files are sorted as follows:

-	 The [base plug-in](https://github.com/jason-fox/com.here.validate.svrl.overrides)  \(`com.here.validate.svrl`\) – this `<chapter>` contains a set of common validator rules from the base DITA validator applicable to all users. The rules are grouped thematically according to the name of the associated `<active-pattern>` within the XSL stylesheets of the plug-in and then are listed alphabetically by `rule-id` within the group. The following types of validation rules are supported:
	-	 `style` – Style rules enforce a standardized look and feel across DITA elements and ensure a better SEO and consistency. Alteration or removal of these rules should not affect ability of DITA-OT to create a valid document.
	-	 `structure` – Structure rules offer an error reporting mechanism against fatal changes which would result in an invalid DITA document. If these rules are altered or removed, errors will not be caught up-front and DITA-OT will not be able to build a valid document. Examples include a `conref` link to a non-existent topic or an attempt to create a `table` containing no `row` elements.
	-	 `content` – These rules check the text within the DITA elements themselves, for example spelling and grammatical errors.
-	 The [extended plug-in](https://github.com/jason-fox/com.here.validate.svrl.overrides) \(`com.here.validate.svrl.overrides`\) – This `<chapter>` shows how to modify, relax or remove existing validator rules and create additional custom validator rules. The custom rules are listed alphabetically by `rule-id`.

Note that **extended** rules will only be detected if the `overrides` transform from this plug-in is used.



Validator Error Messages
========================

The following tables list the validator error messages by type and message ID. Existing [Base DITA Validator](https://github.com/jason-fox/com.here.validate.svrl) are in normal text. Rules in **bold** are only be detected if the `overrides` transform from the [Extended DITA Validator](https://github.com/jason-fox/com.here.validate.svrl.overrides) is used.

Content Validation
------------------

|Message ID|Message|Corrective Action/Comment|
|----------|-------|-------------------------|
|comment-fixme|Found 'FIXME' comments within the <\{name\}\> element - fix as requested and delete the comment.|Replace the draft content with the correct information.|
|comment-todo|Found 'TODO' within the following text of the <\{name\}\> element - fix as requested and delete the comment.|Replace the draft content with the correct information.|
|incorrect-spelling|The word '\{word\}' is a spelling mistake in the following text:|The indicated word is not spelled correctly. Fix the spelling. It is assumed that documentation follows US English spelling conventions. |
|incorrect-capitalization|The word '\{word\}' is incorrectly capitalized in the following text:|The indicated word is not capitalized correctly. Fix the capitalization.|
|running-text-fixme|Found 'FIXME' comments in the following text in this <\{name\}\> element - fix as requested and delete the comment.|Replace the draft content with the correct information.|
|running-text-lorem-ipsum|Found dummy text in this <\{name\}\> element, remove or replace with valid content.|Replace the standard lorem ipsum filler text with the correct information.|
|running-text-todo|Found 'TODO' comments in the following text in this <\{name\}\> element - fix as requested and delete the comment.|Replace the draft content with the correct information.|



Style Validation
----------------

|Message ID|Message|Corrective Action/Comment|
|----------|-------|-------------------------|
|codeblock-outputclass-missing|Always provide an outputclass attribute in `<codeblock>` elements \(for example, add outputclass="language-javascript"\).|This `outputclass` attribute is used for decorating the HTML output to make code easier to read. If the content in the `<codeblock>` element is JSON use the key value pair `outputclass="language-javascript"`. For more information on the `<codeblock>` element, see [codeblock](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/codeblock.html).|
|codeblock-scale-missing|Always provide a scale attribute in `<codeblock>` elements \(for example, add `scale="80"`\).|This `scale` attribute reduces the size of the code text in the output to make it easier to read \(the values are percent\). We recommend you set the scale to 80 percent. For more information on the `<codeblock>` element, see [codeblock](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/codeblock.html).|
|conref-not-lower-case|The specification of `conref="..."` is invalid, allowed characters are: lower case, a-z only, words separated by hyphens.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the source file specified in the `conref` attribute references a file with an invalid name. For instance, if you define the `conref` attribute as follows `<p conref="<InvalidFileName>#invalid-file-name/submission-note">` the file name does not comply with the file naming guidelines. - Only use lower case letters in a file name. - If a file name contains multiple words, use a hyphen to separate them, for example, `overview-map.dita` or `request-map-report.dita`. - The file type \(and file extension\) for all DITA XML files in the repository must be *.dita* or *.ditamap*. - Base the file name on the main topic title. If the title is `Naming Conventions` then the topic `id` should be `naming-conventions` and the file name should be `naming-conventions.dita`. - Do not include arbitrary strings to indicate the contents of the chapter, topic type, etc. - Do not include computer-generated text such as `topic-2` or `GUID-1234-5678-1234`. - Do not use non-standard acronyms, for instance, `border-xing` instead of `border-crossing`.  |
|**element-blacklisted**|**The `<name>` element is not compliant with our subset of DITA documentation standards.**|**Custom Rule**: While the DITA open standard supports a large number of elements, the extended validator only supports a subset of these elements in order to make the documents more consistent. Replace the rejected element with a supported element.|
|fig-id-invalid|`id` values must start with `'fig-'` in all `<fig>` elements.|In order to assist with search engine optimization \(SEO\) of content, all [figure](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/fig.html) elements must have an `id`.|
|fig-id-missing|Always provide an `id` value in `<fig>` elements.|In order to assist with search engine optimization \(SEO\) of content, all [figure](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/fig.html) elements must have an `id`.|
|file-not-lower-case|Found file `'...'` with invalid name, allowed characters in file names are: lowercase, a-z only, words separated by hyphens.|In order to assist with search engine optimization \(SEO\) of content, file names must be lower case. Fix the name as appropriate.|
|href-not-lower-case|The value provided in `href="..."` is invalid, allowed characters are: lowercase, a-z only, words separated by hyphens.|The file specified in the `href` attribute does not comply with the file naming conventions. Fix the name as appropriate.|
|**id-blacklisted**|**`id` attribute values must not use the word `'content'`. Change the `id` value.**| **Custom Rule**: Some delivery channels used to deliver content to customers may be configured to already use certain `id` values. Change the word content to another `id`. For more information on `id` attributes, see [id](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/id.html).|
|id-not-lower-case|The id value in `id="..."` is invalid, allowed characters are: lowercase, a-z only, words separated by hyphens.|In order to assist with search engine optimization \(SEO\) of content, `id` attributes must comply with the `id` conventions. Fix the name as appropriate. - Only use lower case letters in a file name. - If a file name contains multiple words, use a hyphen to separate them, for example, `overview-map.dita` or `request-map-report.dita`. - The file type \(and file extension\) for all DITA XML files in the repository must be *.dita* or *.ditamap*. - Base the file name on the main topic title. If the title is `Naming Conventions` then the topic id should be `naming-conventions` and the file name should be `naming-conventions.dita`. - Do not include arbitrary strings to indicate the contents of the chapter, topic type, etc. - Do not include computer-generated text such as `topic-2` or `GUID-1234-5678-1234`. For more information on `id` atrributes, see [id](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/id.html).|
|image-file-type-not-supported|The value provided in `href="..."` specifies an unsupported file format \(only \*.jpg, \*.jpeg or \*.png are allowed\). Change the format of the linked file.|The validator ensures that only \*.jpg, \*.jpeg or \*.png format files are used in online HTML documents. Convert the image format to the correct format.|
|section-id-missing|Always provide an `id` attribute in `<section>` elements.|In order to assist with search engine optimization \(SEO\), all [section](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/section.html) elements must have an `id`.||table-id-invalid|`id` values must start with 'table-' in `<table>` elements.|If you add an `id` to a table, start the `id` with the word 'table-'. For more information on tables, see [table](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/table.html).|
|table-id-missing|Always provide an `id` attribute in `<table>` elements.|In order to assist with search engine optimization \(SEO\), add an `id` to `<table>` elements. For more information on tables, see [table](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/table.html).|
|topic-file-mismatch|The value specified in id="\{name\}" does not match the file name: \{file\_name\}. Make sure the `id` value and the file name are the same.|In order to assist with search engine optimization \(SEO\) of content, the `id` for `<topic>` elements must be the same as the file name, which also ends up by the name of the HTML file. For more information on topics, see [topic](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/topic.html). For more information on element 'id`s', see [id](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/id.html).|
|xref-no-format|Always provide a format attribute in `<xref>` elements, \(for example, format="dita" or format="html"\).|Specify a value for the `format` attribute for `<xref>` elements. Examples of valid values include `dita`, `html`, and `pdf`. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|

Structure Validation
--------------------

|Message ID|Message|Corrective Action/Comment|
|----------|-------|-------------------------|
|chapter-href-missing|Always provide an href attribute in `<chapter>` elements.|When you add a `<chapter>` element to a `ditamap`, you must specify a `href="{file_name}"` key/value pair that defines the content that appears on the chapter page in the PDF \(and on the chapter landing page in HTML\). Alternatively, you can define the following two attributes: `navtitle="..." lockitle="yes"`. This approach has the effect of adding a title but not content on the chapter page/node. For more information on the `<chapter>` element, see [chapter](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/chapter.html).|
|coderef-href-ref-file-not-found|The linked source file does not exist. Check the related folder for the missing file and make sure the file name is correct.|The `<coderef>` element is generally used for importing a source file when the validator builds the document. When you get this error, the reference cannot be resolved. Note that DITA does not allow you to reference files outside the root folder of the document. By default, these files should be in the `source` folder under the document root folder. For more information on the `<coderef>` element, see [codeblock](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/codeblock.html).|
|colspec-colnum-not-unique|The key/value pair `colnum="..."` is not unique. Make sure there are no duplicates.|In order for the validator to render table content properly, these key/value pairs must be unique. For instance, the following codeblock illustrates well-formated DITA that complies with this requirement. `<colspec colnum="1"/><colspec colnum="2"/><colspec colnum="3"/>` For more information on the `<table>` element, see [table](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/table.html).|
|conref-external-file-not-found|The linked file does not exist. Check the related folder for the missing file and make sure the file name is correct.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the referenced file cannot be resolved. Note that DITA does not allow you to reference files outside the root folder of the document. By default, this kind of content should be in the `includes.dita` file. |
|conref-external-id-mismatch|The conref source `<{name}>` and the destination `<{name}>` are not the same type. Check to make sure the referenced elements are the same.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the referenced `id` in the source file specified in the `conref` attribute is an `id` for an element that is of a different type than the element with the `conref` attribute. DITA requires that `conref` attributes point at the same kind of element. For instance, `<p conref="includes.dita#includes/submission-note">` needs to reference an element in the `includes.dita` file that is formatted as follows `<p id="submission-note">CONTENT</p>`. |
|conref-external-id-not-found|The referenced `id` does not exist in the source file. Make sure the id value specified is correct.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the referenced `id` in the source file specified in the `conref` attribute cannot be resolved. For instance, if you define the `conref` attribute as follows `<p conref="includes.dita#includes/submission-note">` and you get this error, then the `includes.dita` file does not have a `<p>` whose `id` is set to `id="submission-note"`. |
|conref-external-path-not-found|The referenced path does not exist. Make sure the path is correct.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the source file specified in the `conref` attribute cannot be resolved. For instance, if you define the `conref` attribute as follows `<p conref="includes.dita#includes/submission-note">` and you get this error, then the validator cannot find the `includes.dita` file. Note that DITA does not allow you to reference files outside the root folder of the document. |
|conref-external-path-mismatch|The conref source <\{name\}\> and the destination <\{name\}\> are not the same type. Make sure the path is correct.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the referenced `id` in the source file specified in the `conref` attribute is an `id` for an element that is of a different type than the element with the `conref` attribute. DITA requires that `conref` attributes point at the same kind of element. For instance, `<p conref="includes.dita#includes/submission-note">` needs to reference an element in the `includes.dita` file that is formatted as follows `<p id="submission-note">CONTENT</p>`. |
|conref-internal-id-not-found|The referenced `id` does not exist in this file. Make sure the `id` value specified is correct.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the referenced `id` specified in the `conref` attribute cannot be resolved. For instance, if you define the `conref` attribute as follows `<p conref="submission-note">` and you get this error, then the source file does not have a `<p>` whose `id` is set to `id="submission-note"`. |
|conref-internal-path-mismatch|The conref source <\{name\}\> and the destination <\{name\}\> are not the same type. Make sure the path is correct.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the referenced `id` specified in the `conref` attribute is an ID for an element that is of a different type than the element with the `conref` attribute. DITA requires that `conref` attributes point at the same kind of element. For instance, `<p conref="submission-note">` needs to reference an element that is formatted as follows `<p id="submission-note">CONTENT</p>`. |
|conref-internal-path-not-found|The referenced path does not exist in this file. Make sure the path is correct.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the value specified in the `conref` attribute cannot be resolved. For instance, if you define the `conref` attribute as follows `<p conref="<file_name>#submission-note">` and you get this error, then the validator cannot resolve the path. |
|href-file-not-found|The file specified in `href="..."` does not exist. Check the related folder for the missing file and make sure the file name is correct.|The validator cannot find the file specified in the `href` attribute. Make sure the file is in the indicated path. Note that DITA does not allow you to reference files outside the root folder of the document.|
|id-not-unique|Found a duplicate 'id' with value '\{name\}', `id` values must be unique within a file. Change the `id` value.|DITA requires that all `id`s within a file must be unique. Change the `id` value. For more information on `id` attributes, see [id](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/id.html).|
|image-href-ref-file-not-found|The linked image file does not exist. Check the graphics folder for the missing file and make sure the link and file name specified are correct.|The validator cannot find the file specified in the `href` attribute. Check the path to ensure the file is there.|
|**image-product-filtered-not-included**|**Found `<image product="...">`. This results in an empty `<fig>` for other variants. Add additional `product` attributes for the missing ditaval filters.**|**Custom Rule**: When skinning a document for various customers it is necessary to filter the images used. By placing all images in a single conref'd file it is easier to ensure that all images will be present for all customers. see [ditavals](http://docs.oasis-open.org/dita/v1.2/os/spec/common/about-ditaval.html).|
|list-all-li-filtered|Found only `<li product="...">` elements in `<ul>`. This results in an empty `<ul>` for other variants. Either add additional `product` attributes for the ditaval filters or add `<ul product="..."\>` to the appropriate list elements.|The specified variant creation attributes result in a variant with a list without list items. Specify an additional variant attribute to ensure the list has items in all variants or remove the list entirely by specifiying the appropriate attributes. For more information on creating variants, see [ditavals](http://docs.oasis-open.org/dita/v1.2/os/spec/common/about-ditaval.html). For information on list items, see [li](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/li.html).|
|table-all-rows-filtered| Found only `<row product="..."\>` elements in `<tbody\>`. This results in an empty `<tbody>` for other variants. Either add additional product attributes for the missing variants or add `<table product="..."\>` to the appropriate elements. The specified variant creation attributes result in a variant with a table without rows, which results in a broken PDF build. | Specify an additional variant attribute to ensure the table has rows in all variants or remove the table entirely by specifiying the appropriate attributes. For more information on creating variants, see [ditavals](http://docs.oasis-open.org/dita/v1.2/os/spec/common/about-ditaval.html). For more information on tables, see [table](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/table.html).|
|tgroup-cols-colspec-mismatch|The number of \{name\} `<colspec>` elements defined do not match the parent `<tgroup cols="..."\>` attribute. Make sure the number of `<colspec>` elements corresponds with the cols value.|In order to generate PDFs correctly, the number of `<colspec>` elements must match the number in the `<tgroup cols="...">` attribute. For more information on tables, see [table](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/table.html).|
|tgroup-cols-entry-mismatch|The number of \{name\} `<entry>` elements found do not match the parent `<tgroup cols="..."\>` attribute. Make sure the number of `<entry>` elements corresponds with the cols value.|In order to generate PDFs correctly, the number of `<entry>` elements in a `<row>` element must match the number in the `<tgroup cols="...">` attribute. For more information on tables, see [table](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/table.html).|
|topicref-href-missing|Always provide an `href` attribute in `<topicref>` elements.|DITA uses the `href` attribute to specify connections between [topicref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/topicref.html) elements and a file. Add an `href` attribute to the element and specify the appropriate value. For more information on `<topicref>` elements, see [topicref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/topicref.html).|
|xref-external-file-not-found|The file specified in `<xref href="...">` does not exist. Check the related folder for the missing file and make sure the link and file name specified are correct.|When you get this error, the referenced file cannot be resolved. Note that DITA does not allow you to reference files outside the root folder of the document. Make sure the path exists. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|
|xref-external-id-not-found|The referenced `id` in `<xref href="...">` does not exist. Make sure the `id` value specified is correct.|When you get this error, the validator cannot resolve the `id` in the target file. Note that DITA does not allow you to reference files outside the root folder of the document. Make sure the file exists and contains the `id`. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|
|xref-external-path-not-found|The referenced path in `<xref href="...">` does not exist. Make sure the path specified is correct.|When you get this error, the validator cannot resolve the `id` in the target file. Note that DITA does not allow you to reference files outside the root folder of the document. Make sure the file exists and contains the `id`. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|
|xref-internal-id-not-found|The referenced id in `<xref href="...">` does not exist. Make sure the `id` value specified is correct.|When you get this error, the validator cannot resolve the `id` in the file. Make sure the file contains the `id`. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|
|xref-internal-path-not-found|The referenced path in `<xref href="...">` does not exist. Make sure the path is correct.|When you get this error, the validator cannot resolve the provided path in the file. Make sure the file contains the path. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|
|xref-www-format-invalid|`<xref href="..." format="dita">` The specified value points to an external file and cannot have the attribute key/value pair format="dita". Change the format value as appropriate \(for example, format="html"\).|Specify a value for the `format` attribute for `<xref>` elements. Examples of valid values include `dita`, `html`, and `pdf`. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|
|xref-www-scope-invalid|`<xref href="...">` The specified value points to an external file. Specify the attribute key/value pair scope="external".|The `href` attribute specifies a web page or similar target, which means the `scope` attribute must have the value `external`. Change the value as required. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|
