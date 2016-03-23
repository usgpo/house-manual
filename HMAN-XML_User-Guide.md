# The House Manual in XML
## User Guide and Data Dictionary

Prepared by: 
The House Rules Committee; Legislative Computer Systems, Office of the Clerk, U.S. House of Representatives and Programs, Strategy, and Technology, U.S. Government Publishing Office



### Introduction

At the direction of the Committee on Rules within the United States House of Representatives, the Government Publishing Office (GPO), the House Parliamentarian, and the Clerk of the House are making the House Rules and the House Manual available in XML format through GPO's Federal Digital System (FDsys), govinfo, and Bulk Data repository.

The purpose of this document is to describe the XML now available.

The following publications are now available in XML using the USLM schema:

-The House Manual for the 114th Congress ( [https://www.gpo.gov/fdsys/pkg/HMAN-114/pdf/HMAN-114.pdf](https://www.gpo.gov/fdsys/pkg/HMAN-114/pdf/HMAN-114.pdf))

### USLM Schema

The United States Legislative Markup (USLM) is an XML information model designed to represent legislative documents of the United States Congress. To learn more about the USLM schema refer to the USLM User Guide ( [http://uscode.house.gov/download/resources/USLM-User-Guide.pdf](http://uscode.house.gov/download/resources/USLM-User-Guide.pdf)).

### The Files

The following files are being made available. Note: as part of FDsys processing, the original submitted file names are renamed to the FDsys AccessID (e.g. HMAN-114-pg409) to match the corresponding Text and PDF files that are available on FDsys.

| Section | Original File Name | Description |
| --- | --- | --- |
| Front Matter | front.xml | cover page, preface, table of contents, general and special orders of business |
| Constitution | constitution.xml | The Constitution of the United States |
| Jefferson's Manual | jefferson.xml | Jefferson's Manual of Parliamentary Practice |
| Rules of the House of Representatives | rules.xml | Rules of the House of Representatives, with notes and annotations(Because the text of the annotated rules is quite large, there are also individual XML files for each Rule, e.g., rule1.xml, rule2.xml, and so forth) |
| Provisions of the Legislative Reorganization Acts | organization.xml | provisions of the Legislative Reorganization Acts, joint and select committees, House and Congressional offices |
| Congressional Budget Act Laws | budget.xml | miscellaneous provisions of Congressional budget laws |
| Legislative Procedures | procedures.xml | legislative procedures enacted in law |
| Index | index.xml | the index, with links to § references throughout |

Each file has its own CSS stylesheet, named rules.css, constitution.css, etc., and each has a similarly-named XSL stylesheet for transforming the XML for proper display in the browser, including clickable links to cross-references.

In addition to the USLM User Guide, the following information may be helpful when looking at the XML files.

#### References throughout the document

- The House Manual contains many numbered references denoted by the § character, and index entries are keyed to these numbers. Because the numbering of these § references is unrelated to the hierarchical numbering of the component parts of each document, the § references are represented as `<property>` elements within each document's metadata block. Each `<property>` element contains an `@idref` attribute, which points to the `@id` attribute of the structural element to which the § reference refers. For example, §621, "Journal; Speaker's approval," which accompanies clause 1 of Rule I, is represented as `<property name="s-heading" idref="rule-I-1">`§621. Journal; Speaker's approval.`</property>`.

#### Variations from the print and online version

- The print version of the House Manual contains several footnotes, which appear at the bottom of a page and which are distinct from the inline annotations. Because the online version in XML format is not paginated, footnotes appear within the text, and therefore more closely resemble the inline annotations. Footnotes are always preceded by a number.
- In one case, this "inlining" of footnotes has caused a § reference to appear out of order. §284 and §286 fall within the same footnote in Jefferson's Manual, a footnote that spans a page break. §285 falls within the main text and appears between them in the printed version. Because footnotes are never split in the online version, §284 and §286 appear together, followed by §285.

### Data Set

In general, there are no restrictions on re-use of information these documents because U.S. Government works are not subject to copyright protection and are in the public domain. GPO and its legislative branch data partners do not restrict downstream uses of these documents, except that independent providers should be aware that only GPO and its legislative branch data partners are entitled to represent that they are the providers of official documents.

These files can be manipulated and enriched to operate in the various applications that users may devise. GPO and its legislative branch data partners cannot vouch for the authenticity of data that is not under GPO's control. GPO does not endorse third party applications, and does not evaluate how the original content is displayed on other sites. Consumers should form their own conclusions as to whether the downloaded data can be relied upon within an application or its enriched results that were not necessarily the original reason for producing the raw source data.

### Resources Directory

The resources directory at [https://www.gpo.gov/fdsys/bulkdata/HMAN/resources](https://www.gpo.gov/fdsys/bulkdata/HMAN/resources) contains the User Guide for HMAN Bulk Data along with the CSS and XSLT files.