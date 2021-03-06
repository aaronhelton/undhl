
<!--
    Rendering specific to the item display page.

    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
    Author: Alexey Maslov

-->

<xsl:stylesheet
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:dri="http://di.tamu.edu/DRI/1.0/"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
    xmlns:xlink="http://www.w3.org/TR/xlink/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:ore="http://www.openarchives.org/ore/terms/"
    xmlns:oreatom="http://www.openarchives.org/ore/atom/"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:encoder="xalan://java.net.URLEncoder"
    xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
    xmlns:jstring="java.lang.String"
    xmlns:rights="http://cosimo.stanford.edu/sdr/metsrights/"
    xmlns:confman="org.dspace.core.ConfigurationManager"
    exclude-result-prefixes="xalan encoder i18n dri mets dim xlink xsl util jstring rights confman">

    <xsl:output indent="yes"/>

    <xsl:template name="itemSummaryView-DIM">
        <!-- Generate the info about the item from the metadata section -->
        <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
        mode="itemSummaryView-DIM"/>

        <xsl:copy-of select="$SFXLink" />

        <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default)-->
        <xsl:if test="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']">
            <div class="license-info table">
                <p>
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.license-text</i18n:text>
                </p>
                <ul class="list-unstyled">
                    <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']" mode="simple"/>
                </ul>
            </div>
        </xsl:if>


    </xsl:template>

    <!-- An item rendered in the detailView pattern, the "full item record" view of a DSpace item in Manakin. -->
    <xsl:template name="itemDetailView-DIM">
        <!-- Output all of the metadata about the item from the metadata section -->
        <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
                             mode="itemDetailView-DIM"/>

        <!-- Generate the bitstream information from the file section -->
        <xsl:choose>
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE']/mets:file">
                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h3>
                <div class="file-list">
                    <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE' or @USE='CC-LICENSE']">
                        <xsl:with-param name="context" select="."/>
                        <xsl:with-param name="primaryBitstream" select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"/>
                    </xsl:apply-templates>
                </div>
            </xsl:when>
            <!-- Special case for handling ORE resource maps stored as DSpace bitstreams -->
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='ORE']">
                <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='ORE']"/>
            </xsl:when>
            <xsl:otherwise>
                <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
                <table class="ds-table file-list">
                    <tr class="ds-table-header-row">
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-view</i18n:text></th>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <p><i18n:text>xmlui.dri2xhtml.METS-1.0.item-no-files</i18n:text></p>
                        </td>
                    </tr>
                </table>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">

	<div class="row">
		<div class="col-md-9">


        		<div class="item-summary-view-metadata">
                            <xsl:call-template name="itemSummaryView-DIM-rights"/>
                            <!-- 
			    <xsl:call-template name="itemSummaryView-DIM-identifier-uri"/>	
                            -->
			    <xsl:call-template name="itemSummaryView-DIM-symbol"/>
			    <xsl:call-template name="itemSummaryView-Embed"/>
                            <div class="row">
                              <div class="col-xs-2 pull-left">
                                <xsl:call-template name="itemSummaryView-DIM-thumbnail"/>
                              </div>
                              <div class="col-xs-10 pull-left">
                                <xsl:call-template name="itemSummaryView-DIM-title"/>
                              </div>
                            </div>
			    <!-- <xsl:call-template name="itemSummaryView-DIM-alt-title"/> -->
			    <xsl:call-template name="itemSummaryView-DIM-abstract"/>	
			    <xsl:call-template name="itemSummaryView-DIM-authors"/>
			    <xsl:call-template name="itemSummaryView-DIM-date"/>
			    <xsl:call-template name="itemSummaryView-DIM-agenda"/>	
			    <xsl:call-template name="itemSummaryView-DIM-subjects"/>
			    <xsl:call-template name="itemSummaryView-DIM-series"/>	
			    <xsl:call-template name="itemSummaryView-DIM-type"/>	
		            <xsl:if test="$ds_item_view_toggle_url != ''">
		            	<xsl:call-template name="itemSummaryView-show-full"/>
		            </xsl:if>
			    <xsl:call-template name="itemSummaryView-DIM-relation"/>
                            <xsl:call-template name="itemSummaryView-collections"/>

			    
	
<!--
            <div class="row">
                <div class="col-sm-4">
                    <div class="row">
                        <div class="col-xs-6 col-sm-12">
                            <xsl:call-template name="itemSummaryView-DIM-thumbnail"/>
                        </div>
                        <div class="col-xs-6 col-sm-12">
                            <xsl:call-template name="itemSummaryView-DIM-file-section"/>
                        </div>
                    </div>
                    <xsl:call-template name="itemSummaryView-DIM-date"/>
                    <xsl:call-template name="itemSummaryView-DIM-authors"/>
                    <xsl:if test="$ds_item_view_toggle_url != ''">
                        <xsl:call-template name="itemSummaryView-show-full"/>
                    </xsl:if>
                </div>
                <div class="col-sm-8">
                    <xsl:call-template name="itemSummaryView-DIM-abstract"/>
                    <xsl:call-template name="itemSummaryView-DIM-URI"/>
                    <xsl:call-template name="itemSummaryView-collections"/>
                </div>
            </div>
-->
        		</div>

		</div>

		<div class="col-md-3">

			<xsl:call-template name="itemSummaryView-DIM-files"/>

		</div>
                <div class="col-md-3">
                        <xsl:call-template name="itemSummaryView-DIM-Context"/>
                </div>
	</div>


    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-rights">
      <div class="row">
        <xsl:if test="dim:field[@element='rights']">
          <div class="col-md-12 alert alert-danger">
            <xsl:value-of select="dim:field[@element='rights']/node()"/>
            <xsl:if test="dim:field[@element='rights' and @qualifier='uri']">
              <p>
                <a>
                  <xsl:attribute name="href"><xsl:value-of select="dim:field[@element='rights' and @qualifier='uri']"/></xsl:attribute>
                  <xsl:value-of select="dim:field[@element='rights' and @qualifier='uri']"/>
                </a>
              </p>
            </xsl:if>
          </div>
        </xsl:if>
      </div>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-symbol">
	<div class="row">
		<div class="col-md-12">
                  <xsl:if test="dim:field[@qualifier='symbol']">
			Document symbol:
			<xsl:value-of select="dim:field[@qualifier='symbol']/node()"/>
                  </xsl:if>
		</div>
	</div>
    </xsl:template>

    <xsl:template name="itemSummaryView-Embed">
      <div class="row">
        <div class="col-md-12">
          <a href="#" id="oeToggle" class="btn btn-primary" data-toggle="modal" data-target="#oeModal">Embed</a>
        </div>
      </div>

      <div id="oeModal" class="modal fade" data-backdrop="false">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Embed this Item</h4>
            </div>
            <div class="modal-body" id="oeModalStep1">
              <div class="row">
                <div class="col-md-12">
                  <p>This widget generates an embed code for this item that you can use in your own web pages. Simply copy the embed code below and paste it where you want it to appear on your web page.</p>
                </div>
              </div>
              <hr/>
              <div class="row">
                <div class="col-md-12">
                  <label>Embed Code:</label>
                  <textarea class="form-control" id="oeCode"></textarea>
                </div>
              </div>
              <hr/>
              <div class="row">
                <div class="col-md-12">
                  <label>Preview:</label>
                  <div class="col-md-12" id="oePreview">
                    _
                  </div>
                </div>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
          </div>
        </div>
      </div>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-identifier-uri">
        <div class="row">
		<div class="col-md-12">	
			Citable URL: 
			<xsl:text disable-output-escaping="yes">&lt;a href="</xsl:text><xsl:value-of select="dim:field[@qualifier='uri']/node()"/><xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
				<xsl:value-of select="dim:field[@qualifier='uri']/node()"/>
			<xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>
		</div>
        </div>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-alt-title">
        <div>
             	alt title [need example to figure out path] 
        </div>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-type">
	<xsl:if test="dim:field[@element='type']">
		<div class="row">
			<div class="col-md-2">
				Content type
			</div>	
			<div class="col-md-10">
				<xsl:choose>
					<xsl:when test="dim:field[@element='type']">	
						<xsl:for-each select="dim:field[@element='type']">
							<a>
								<xsl:attribute name="href">/discover?filtertype=contentType&amp;filter_relational_operator=equals&amp;filter=<xsl:copy-of select="node()"/></xsl:attribute>
								<xsl:copy-of select="node()"/>
							</a>
				 			<xsl:if test="position() != last()">
								-
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
				</xsl:choose>
			</div>
        	</div>
	</xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-files">
        <xsl:if test="/mets:METS/mets:fileSec/mets:fileGrp[@USE='CONTENT']">
		<div class="item_landing_page_left_sidebar">
			<h4>Full Text</h4>
			<!-- <h4>Full Text</h4> -->
			<h4><i18n:text>xmlui.ArtifactBrowser.ItemViewer.fulltext</i18n:text></h4>

			<ul>
			<xsl:for-each select="/mets:METS/mets:fileSec/mets:fileGrp[@USE='CONTENT']/mets:file">
				<li>
					<xsl:text disable-output-escaping="yes">&lt;a href="</xsl:text><xsl:value-of select="mets:FLocat/@xlink:href"/><xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
                                                <xsl:choose>
                                                  <xsl:when test="@MIMETYPE='application/pdf'">
                                                    <i aria-hidden="true" class="glyphicon glyphicon-file"></i>
                                                  </xsl:when>
                                                  <xsl:when test="@MIMETYPE='application/octet-stream'">
                                                    <i aria-hidden="true" class="glyphicon glyphicon-headphones"></i>
                                                  </xsl:when>
                                                </xsl:choose>
                                                <xsl:value-of select="mets:FLocat/@xlink:label"/>
                                                (<xsl:value-of select="round(@SIZE div 1000)"/>Kb)
					<xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>
				</li>
			</xsl:for-each>
			</ul>
		</div>
        </xsl:if>

<!--
        <xsl:choose>
            <xsl:when test="count(dim:field[@element='language']) &gt; 0">
		    <h5>Full Text</h5>	
                    <ul>
                        <xsl:for-each select="dim:field[@element='language']">
				<li>
                                	<xsl:value-of select="./node()"/>
				</li>
                        </xsl:for-each>
                    </ul>
            </xsl:when>
            <xsl:otherwise>
                    <h5>Full Text not available</h5>
            </xsl:otherwise>
        </xsl:choose>
-->
    </xsl:template>


    <xsl:template name="itemSummaryView-DIM-Context">
      <xsl:if test="$thisUserMeta/@authenticated = 'yes'">
        <xsl:variable name="thisUserEmail" select="$thisUserMeta/dri:metadata[@element='identifier' and @qualifier='email']"/>
        <xsl:variable name="thisItemProvenance" select="dim:field[@element='description' and @qualifier='provenance']"/>
        <xsl:if test="contains($thisItemProvenance,$thisUserEmail)">
          <xsl:apply-templates select="$document//dri:list[@id='aspect.viewArtifacts.Navigation.list.context']"/>
        </xsl:if>
      </xsl:if>
    </xsl:template>


    <xsl:template name="itemSummaryView-DIM-title">
        <xsl:choose>
            <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                <h2 class="page-header first-page-header">
                    <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                </h2>
                <div class="simple-item-view-other">
                    <p class="lead">
                        <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                            <xsl:if test="not(position() = 1)">
                                <xsl:value-of select="./node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                    <xsl:text>; </xsl:text>
                                    <br/>
                                </xsl:if>
                            </xsl:if>

                        </xsl:for-each>
                    </p>
                </div>
            </xsl:when>
            <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                <h2 class="page-header first-page-header">
                    <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                </h2>
            </xsl:when>
            <xsl:otherwise>
                <h2 class="page-header first-page-header">
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                </h2>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-thumbnail">
        <div class="thumbnail">
            <xsl:choose>
                <xsl:when test="//mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']">
                    <xsl:variable name="src">
                        <xsl:choose>
                            <xsl:when test="/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file//@xlink:label='thumbnail'">
                              <xsl:value-of select="/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file/mets:FLocat/@xlink:href"/>
                            </xsl:when>
                            <xsl:when test="/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=../../mets:fileGrp[@USE='CONTENT']/mets:file[@GROUPID=../../mets:fileGrp[@USE='THUMBNAIL']/mets:file/@GROUPID][1]/@GROUPID]">
                                <xsl:value-of
                                        select="/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=../../mets:fileGrp[@USE='CONTENT']/mets:file[@GROUPID=../../mets:fileGrp[@USE='THUMBNAIL']/mets:file/@GROUPID][1]/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                        select="//mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <img alt="Thumbnail">
                        <xsl:attribute name="src">
                            <xsl:value-of select="$src"/>
                        </xsl:attribute>
                    </img>
                </xsl:when>
                <xsl:otherwise>
                    <!--<i class="glyphicon glyphicon-file" aria-hidden="true"/>-->

                    <img alt="Thumbnail">
                        <xsl:attribute name="data-src">
                            <xsl:text>holder.js/100%x</xsl:text>
                            <xsl:value-of select="$thumbnail.maxheight"/>
                            <xsl:text>/text:No Thumbnail</xsl:text>
                        </xsl:attribute>
                    </img>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-abstract">
        <xsl:if test="dim:field[@element='identifier'][@qualifier='other']">
        <div class="alert-danger table">
              <h4>
                <xsl:text>
                  This item is a UN Sales Publication and is available for purchase
                </xsl:text>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="dim:field[@element='identifier'][@qualifier='other']"/>
                    </xsl:attribute>
                    <xsl:attribute name="target">_blank</xsl:attribute>
                    <xsl:text>here</xsl:text>
                </xsl:element>
              </h4>
        </div>
        </xsl:if>
        <xsl:if test="dim:field[@element='description' and @qualifier='statementofresponsibility']">
          <div class="simple-item-view-description item-page-field-wrapper table">
            <div>
              <xsl:for-each select="dim:field[@element='description' and @qualifier='statementofresponsibility']">
                <xsl:choose>
                  <xsl:when test="node()">
                    <xsl:choose>
                      <xsl:when test="contains(node(),'&lt;br&gt;')">
                        <p>
                          <xsl:value-of select="substring-before(node(),'&lt;br&gt;')"/>
                        </p>
                        <p>
                          <xsl:value-of select="substring-after(node(),'&lt;br&gt;')"/>
                        </p>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:copy-of select="node()"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>&#160;</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </div>
          </div>
        </xsl:if>
        <xsl:if test="dim:field[@element='description' and @qualifier='abstract']">
            <div class="simple-item-view-description item-page-field-wrapper table">
                <h5 class="visible-xs"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text></h5>
                <div>
                    <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                              <!-- The following renders line breaks in the abtract, but only if they contain <br> tags at appropriate locations -->
                              <xsl:choose>
                                <xsl:when test="contains(node(),'&lt;br&gt;')">
                                  <p>
                                  <xsl:value-of select="substring-before(node(),'&lt;br&gt;')"/>
                                  </p>
                                  <p>
                                  <xsl:value-of select="substring-after(node(),'&lt;br&gt;')"/>
                                  </p>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:copy-of select="node()"/>
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                            <div class="spacer">&#160;</div>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                        <div class="spacer">&#160;</div>
                    </xsl:if>
                </div>
            </div>
        </xsl:if>
    </xsl:template>


<!-- agenda -->
    <xsl:template name="itemSummaryView-DIM-agenda">
        <xsl:if test="dim:field[@element='subject' and @qualifier='agenda']">
                <div class="row">
                        <div class="col-md-2">
                               	Agenda 
                        </div>
                        <div class="col-md-10">
                                <xsl:choose>
                                    <xsl:when test="dim:field[@element='subject' and @qualifier='agenda']">
                                        <xsl:for-each select="dim:field[@element='subject' and @qualifier='agenda']">
                                            <a>
                                                <xsl:attribute name="href">/discover?filtertype=agenda&amp;filter_relational_operator=equals&amp;filter=<xsl:copy-of select="node()"/></xsl:attribute>
                                                <xsl:copy-of select="node()"/>
                                            </a>
                                             <xsl:if test="position() != last()">
                                                -
                                             </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-agenda</i18n:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                        </div>
                </div>
        </xsl:if>
    </xsl:template>


<!-- subjects -->
    <xsl:template name="itemSummaryView-DIM-subjects">
        <xsl:if test="dim:field[@element='subject']">
		<div class="row">	
			<div class="col-md-2">
                		<i18n:text>xmlui.dri2xhtml.METS-1.0.item-subject</i18n:text>
			</div>
			<div class="col-md-10">
                		<xsl:choose>
                		    <xsl:when test="dim:field[@element='subject']">
                        		<xsl:for-each select="dim:field[@element='subject' and not(@qualifier='agenda') and not (@qualifier='keywords')]">
                        			    <a>
							<xsl:attribute name="href">/discover?filtertype=subject&amp;filter_relational_operator=equals&amp;filter=<xsl:copy-of select="node()"/></xsl:attribute>
							<xsl:copy-of select="node()"/> 
                        			    </a>
						     <xsl:if test="position() != last()">	 
						    	- 
						     </xsl:if>	
                        		</xsl:for-each>
		                    </xsl:when>
		                    <xsl:otherwise>
		                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-subject</i18n:text>
		                    </xsl:otherwise>
		                </xsl:choose>
	                </div>
		</div>	
        </xsl:if>
    </xsl:template>

<!-- series -->
    <xsl:template name="itemSummaryView-DIM-series">
        <xsl:if test="dim:field[@element='series']">
                <div class="row">
                        <div class="col-md-2">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-series</i18n:text>
                        </div>
                        <div class="col-md-10">
                                <xsl:choose>
                                    <xsl:when test="dim:field[@element='series']">
                                        <xsl:for-each select="dim:field[@element='series']">
                                            <div>
                                                <xsl:copy-of select="node()"/>
                                            </div>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-series</i18n:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                        </div>
                </div>
        </xsl:if>
    </xsl:template>


<!-- relation -->
    <xsl:template name="itemSummaryView-DIM-relation">
        <!-- The following test excludes ispartof and haspart relations -->
        <xsl:if test="dim:field[@element='relation'][@qualifier='addendum'] or dim:field[@element='relation'][@qualifier='agenda'] or dim:field[@element='relation'][@qualifier='corrigendum'] or dim:field[@element='relation'][@qualifier='draft'] or dim:field[@element='relation'][@qualifier='meeting'] or dim:field[@element='relation'][@qualifier='original'] or dim:field[@element='relation'][@qualifier='report'] or dim:field[@element='relation'][@qualifier='resolution'] or dim:field[@element='relation'][@qualifier='resumption'] or dim:field[@element='relation'][@qualifier='revision'] or dim:field[@element='relation'][@qualifier='statement']">

	   <div class="related_items_box"> 

		<h4>Related items</h4>

		<!-- forced to hardcode values because dSpace doesn't support xsl v2 -->

                <xsl:if test="dim:field[@element='relation'][@qualifier='addendum']">
                  <div class="row">
                    <div class="col-md-2">
			<!-- To do: internationalize this and other labels here -->
                      Addendum
                    </div>
                    <div class="col-md-10">
                      <xsl:for-each select="dim:field[@element='relation'][@qualifier='addendum']">
                        <a>
                          <xsl:attribute name="href">/services/symbol/<xsl:copy-of select="node()"/></xsl:attribute>
                          <xsl:copy-of select="node()"/>
                        </a>
                        <xsl:if test="position() != last()"> - </xsl:if>
                      </xsl:for-each>
                                </div>
                        </div>
                </xsl:if>
                <xsl:if test="dim:field[@element='relation'][@qualifier='agenda']">
                    <div class="row">
                      <div class="col-md-2">
                                                <!-- To do: internationalize this and other labels here -->
                        Agenda
                      </div>
                      <div class="col-md-10">
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='agenda']">
                          <a>
                            <xsl:attribute name="href">/services/symbol/<xsl:copy-of select="node()"/></xsl:attribute>
                            <xsl:copy-of select="node()"/>
                          </a>
                          <xsl:if test="position() != last()"> - </xsl:if>
                        </xsl:for-each>
                      </div>
                    </div>
                </xsl:if>
                <xsl:if test="dim:field[@element='relation'][@qualifier='corrigendum']">
                    <div class="row">
                      <div class="col-md-2">
                                                <!-- To do: internationalize this and other labels here -->
                        Corrigendum
                      </div>
                      <div class="col-md-10">
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='corrigendum']">
                          <a>
                            <xsl:attribute name="href">/services/symbol/<xsl:copy-of select="node()"/></xsl:attribute>
                            <xsl:copy-of select="node()"/>
                          </a>
                          <xsl:if test="position() != last()"> - </xsl:if>
                        </xsl:for-each>
                      </div>
                    </div>
                </xsl:if>
                <xsl:if test="dim:field[@element='relation'][@qualifier='draft']">
                    <div class="row">
                      <div class="col-md-2">
                                                <!-- To do: internationalize this and other labels here -->
                        Draft
                      </div>
                      <div class="col-md-10">
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='draft']">
                          <a>
                            <xsl:attribute name="href">/services/symbol/<xsl:copy-of select="node()"/></xsl:attribute>
                            <xsl:copy-of select="node()"/>
                          </a>
                          <xsl:if test="position() != last()"> - </xsl:if>
                        </xsl:for-each>
                      </div>
                    </div>
                </xsl:if>
<!-- Hiding haspart and ispartof in favor of a forthcoming replacement -->
                <!--
                <xsl:if test="dim:field[@element='relation'][@qualifier='haspart']">
                        <div class="row">
                                <div class="col-md-2">
					Has part
                                </div>
                                <div class="col-md-10">
                                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='haspart']">
                                                <a>
                                                        <xsl:attribute name="href">/discover?filtertype=symbol&amp;filter_relational_operator=equals&amp;filter=<xsl:copy-of select="node()"/></xsl:attribute>
                                                        <xsl:copy-of select="node()"/>
                                                </a>
						<xsl:if test="position() != last()"> - </xsl:if>	
                                        </xsl:for-each>
                                </div>
                        </div>
                </xsl:if>
                <xsl:if test="dim:field[@element='relation'][@qualifier='ispartof']">
                        <div class="row">
                                <div class="col-md-2">
					Is part of
                                </div>
                                <div class="col-md-10">
                                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='ispartof']">
                                                <a>
                                                        <xsl:attribute name="href">/discover?filtertype=symbol&amp;filter_relational_operator=equals&amp;filter=<xsl:copy-of select="node()"/></xsl:attribute>
                                                        <xsl:copy-of select="node()"/>
                                                </a>
						<xsl:if test="position() != last()"> - </xsl:if>
                                        </xsl:for-each>
                                </div>
                        </div>
                </xsl:if>
-->
		<xsl:if test="dim:field[@element='relation'][@qualifier='meeting']">
                    <div class="row">
                      <div class="col-md-2">
  						<!-- To do: internationalize this and other labels here -->
                        Meeting
                      </div>
                      <div class="col-md-10">
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='meeting']">
                          <a>
                            <xsl:attribute name="href">/services/symbol/<xsl:copy-of select="node()"/></xsl:attribute>
                            <xsl:copy-of select="node()"/>
                          </a>
                          <xsl:if test="position() != last()"> - </xsl:if>
                        </xsl:for-each>
                      </div>
                    </div>
		</xsl:if>
		<xsl:if test="dim:field[@element='relation'][@qualifier='original']">
                    <div class="row">
                      <div class="col-md-2">
  						<!-- To do: internationalize this and other labels here -->
                        Original
                      </div>
                      <div class="col-md-10">
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='original']">
                          <a>
                            <xsl:attribute name="href">/services/symbol/<xsl:copy-of select="node()"/></xsl:attribute>
                            <xsl:copy-of select="node()"/>
                          </a>
                          <xsl:if test="position() != last()"> - </xsl:if>
                        </xsl:for-each>
                      </div>
                    </div>
                </xsl:if>
		<xsl:if test="dim:field[@element='relation'][@qualifier='report']">
                    <div class="row">
                      <div class="col-md-2">
  						<!-- To do: internationalize this and other labels here -->
                        Report
                      </div>
                      <div class="col-md-10">
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='report']">
                          <a>
                            <xsl:attribute name="href">/services/symbol/<xsl:copy-of select="node()"/></xsl:attribute>
                            <xsl:copy-of select="node()"/>
                          </a>
                          <xsl:if test="position() != last()"> - </xsl:if>
                        </xsl:for-each>
                      </div>
                    </div>
		</xsl:if>
		<xsl:if test="dim:field[@element='relation'][@qualifier='resolution']">
                    <div class="row">
                      <div class="col-md-2">
  						<!-- To do: internationalize this and other labels here -->
                        Resolution
                      </div>
                      <div class="col-md-10">
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='resolution']">
                          <a>
                            <xsl:attribute name="href">/services/symbol/<xsl:copy-of select="node()"/></xsl:attribute>
                            <xsl:copy-of select="node()"/>
                          </a>
                          <xsl:if test="position() != last()"> - </xsl:if>
                        </xsl:for-each>
                      </div>
                    </div>
		</xsl:if>
		<xsl:if test="dim:field[@element='relation'][@qualifier='resumption']">
                    <div class="row">
                      <div class="col-md-2">
  						<!-- To do: internationalize this and other labels here -->
                        Resumption
                      </div>
                      <div class="col-md-10">
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='resumption']">
                          <a>
                            <xsl:attribute name="href">/services/symbol/<xsl:copy-of select="node()"/></xsl:attribute>
                            <xsl:copy-of select="node()"/>
                          </a>
                          <xsl:if test="position() != last()"> - </xsl:if>
                        </xsl:for-each>
                      </div>
                    </div>
		</xsl:if>
		<xsl:if test="dim:field[@element='relation'][@qualifier='revision']">
                    <div class="row">
                      <div class="col-md-2">
  						<!-- To do: internationalize this and other labels here -->
                        Revision
                      </div>
                      <div class="col-md-10">
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='revision']">
                          <a>
                            <xsl:attribute name="href">/services/symbol/<xsl:copy-of select="node()"/></xsl:attribute>
                            <xsl:copy-of select="node()"/>
                          </a>
                          <xsl:if test="position() != last()"> - </xsl:if>
                        </xsl:for-each>
                      </div>
                    </div>
		</xsl:if>
		<xsl:if test="dim:field[@element='relation'][@qualifier='statement']">
                    <div class="row">
                      <div class="col-md-2">
  						<!-- To do: internationalize this and other labels here -->
                        Statement
                      </div>
                      <div class="col-md-10">
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='statement']">
                          <a>
                            <xsl:attribute name="href">/services/symbol/<xsl:copy-of select="node()"/></xsl:attribute>
                            <xsl:copy-of select="node()"/>
                          </a>
                          <xsl:if test="position() != last()"> - </xsl:if>
                        </xsl:for-each>
                      </div>
                    </div>
		</xsl:if>
	  </div>
        </xsl:if>
        <!-- Now the series information -->
        <xsl:if test="dim:field[@element='relation'][@qualifier='ispartof']">
          <div class="related_items_box">
          <div class="row">
            <div class="col-md-2">
              <!-- todo: internationalize this -->
              <h4>
              <xsl:text>Series</xsl:text>
              </h4>
            </div>
            <div class="col-md-10">
              <xsl:value-of select="dim:field[@element='relation'][@qualifier='ispartof']"/>
              <xsl:if test="dim:field[@element='series'][@qualifier='numbering']">
                <xsl:text>&#59;&#32;</xsl:text>
                <xsl:value-of select="dim:field[@element='series'][@qualifier='numbering']"/>
              </xsl:if>
              <xsl:if test="dim:field[@element='series'][@qualifier='year']">
                <xsl:text>&#44;&#32;</xsl:text>
                <xsl:value-of select="dim:field[@element='series'][@qualifier='year']"/>
              </xsl:if>
            </div>
          </div>
          </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="dim:dim[@dspaceType='ITEM']">


<!--
	<xsl:for-each-group select="dim:field[@element='relation']" group-by="@qualifier">
		<xsl value-of select="current-grouping-key" />
	</xsl:for-each-group>
-->
    </xsl:template>


<!-- authors -->
    <xsl:template name="itemSummaryView-DIM-authors">
        <xsl:if test="dim:field[@element='contributor'][@qualifier='author' and descendant::text()] or dim:field[@element='creator' and descendant::text()] or dim:field[@element='contributor' and descendant::text()]">

	    <div class="row">	

            <!-- <div class="simple-item-view-authors item-page-field-wrapper table"> -->
		<div class="col-md-2">
                	<i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text>
		</div>

		<div class="col-md-10">
                	<xsl:choose>
                	    <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                	        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                	            <div>
                	                <xsl:if test="@authority">
                	                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                	                </xsl:if>
                	                <xsl:copy-of select="node()"/>
                	            </div>
                	        </xsl:for-each>
                	    </xsl:when>
                	    <xsl:when test="dim:field[@element='creator']">
                	        <xsl:for-each select="dim:field[@element='creator']">
                	            <xsl:copy-of select="node()"/>
                	            <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
                	                <xsl:text>; </xsl:text>
                	            </xsl:if>
                	        </xsl:for-each>
                	    </xsl:when>
                	    <xsl:when test="dim:field[@element='contributor']">
                	        <xsl:for-each select="dim:field[@element='contributor']">
					<a>
						<xsl:attribute name="href">/discover?filtertype=author&amp;filter_relational_operator=equals&amp;filter=<xsl:copy-of select="node()"/></xsl:attribute>
						<xsl:copy-of select="node()"/>                	           	 
                	                </a>
					<xsl:if test="position() != last()">
						-
					</xsl:if>	
                        	</xsl:for-each>
                    	    </xsl:when>
                    	    <xsl:otherwise>
                        	<i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                    	    </xsl:otherwise>
                	</xsl:choose>
		</div>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-URI">
        <xsl:if test="dim:field[@element='identifier' and @qualifier='uri' and descendant::text()]">
            <div class="simple-item-view-uri item-page-field-wrapper table">
                <h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text></h5>
                <span>
                    <xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:copy-of select="./node()"/>
                            </xsl:attribute>
                            <xsl:copy-of select="./node()"/>
                        </a>
                        <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
                            <br/>
                        </xsl:if>
                    </xsl:for-each>
                </span>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-date">
        <xsl:if test="dim:field[@element='date' and @qualifier='issued' and descendant::text()]">
		<div class="row">
			<div class="col-md-2">
                    		<i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>
			</div>
			<div class="col-md-10">
                		<xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
                    			<xsl:copy-of select="substring(./node(),1,10)"/>
                    			<xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
                        			<br/>
                    			</xsl:if>
                		</xsl:for-each>
			</div>
            	</div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-show-full">
	<div class="row itemSummaryView-show-full">
		<div class="col-md-12">  	
            		<a>
            		    <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
            		    <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
            		</a>
		</div>
        </div>
    </xsl:template>

<!--
    <xsl:template name="itemSummaryView-collections">
        <xsl:if test="$document//dri:referenceSet[@id='aspect.artifactbrowser.ItemViewer.referenceSet.collection-viewer']">
            <div class="simple-item-view-collections item-page-field-wrapper table">
                <h5>
                    <xsl:text>Collections</xsl:text>
                </h5>
                <xsl:apply-templates select="$document//dri:referenceSet[@id='aspect.artifactbrowser.ItemViewer.referenceSet.collection-viewer']/dri:reference"/>
            </div>
        </xsl:if>
    </xsl:template>
-->

    <xsl:template name="itemSummaryView-collections">
      <xsl:if test="$document//dri:referenceSet[@id='aspect.artifactbrowser.ItemViewer.referenceSet.collection-viewer']">
        <div class="row simple-item-view-collections item-page-field-wrapper table">
          <div class="col-md-12">
            <hr/>
            <i18n:text>xmlui.ArtifactBrowser.ItemViewer.head_parent_collections</i18n:text>
          <!-- </div> -->
          <!-- <div class="col-md-8"> -->
            <xsl:apply-templates select="$document//dri:referenceSet[@id='aspect.artifactbrowser.ItemViewer.referenceSet.collection-viewer']/dri:reference"/>
          </div>
        </div>
      </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-file-section">
        <xsl:if test="//mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE']/mets:file">
            <div class="item-page-field-wrapper table">
                <h5>
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
                </h5>

                <xsl:variable name="label-1">
                        <xsl:choose>
                            <xsl:when test="confman:getProperty('mirage2','item-view.bitstream.href.label.1')">
                                <xsl:value-of select="confman:getProperty('mirage2','item-view.bitstream.href.label.1')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>label</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>

                <xsl:variable name="label-2">
                        <xsl:choose>
                            <xsl:when test="confman:getProperty('mirage2','item-view.bitstream.href.label.2')">
                                <xsl:value-of select="confman:getProperty('mirage2','item-view.bitstream.href.label.2')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>title</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>

                <xsl:for-each select="//mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE']/mets:file">
                    <div>
                    <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                    </xsl:attribute>
                    <xsl:call-template name="getFileIcon">
                        <xsl:with-param name="mimetype">
                            <xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="substring-after(@MIMETYPE,'/')"/>
                        </xsl:with-param>
                    </xsl:call-template>
                                    <xsl:choose>
                                        <xsl:when test="contains($label-1, 'label') and mets:FLocat[@LOCTYPE='URL']/@xlink:label">
                                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/>
                                        </xsl:when>
                                        <xsl:when test="contains($label-1, 'title') and mets:FLocat[@LOCTYPE='URL']/@xlink:title">
                                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                                        </xsl:when>
                                        <xsl:when test="contains($label-2, 'label') and mets:FLocat[@LOCTYPE='URL']/@xlink:label">
                                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/>
                                        </xsl:when>
                                        <xsl:when test="contains($label-2, 'title') and mets:FLocat[@LOCTYPE='URL']/@xlink:title">
                                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:call-template name="getFileTypeDesc">
                                                <xsl:with-param name="mimetype">
                                                    <xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
                                                    <xsl:text>/</xsl:text>
                                                    <xsl:value-of select="substring-before(substring-after(@MIMETYPE,'/'),';')"/>
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text> (</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="@SIZE &lt; 1024">
                                            <xsl:value-of select="@SIZE"/>
                                            <i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
                                        </xsl:when>
                                        <xsl:when test="@SIZE &lt; 1024 * 1024">
                                            <xsl:value-of select="substring(string(@SIZE div 1024),1,5)"/>
                                            <i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
                                        </xsl:when>
                                        <xsl:when test="@SIZE &lt; 1024 * 1024 * 1024">
                                            <xsl:value-of select="substring(string(@SIZE div (1024 * 1024)),1,5)"/>
                                            <i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring(string(@SIZE div (1024 * 1024 * 1024)),1,5)"/>
                                            <i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>)</xsl:text>
                                </a>
                            </div>

                </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="dim:dim" mode="itemDetailView-DIM">
        <xsl:call-template name="itemSummaryView-DIM-title"/>
        <div class="ds-table-responsive">
            <table class="ds-includeSet-table detailtable table table-striped table-hover">
                <xsl:apply-templates mode="itemDetailView-DIM"/>
            </table>
        </div>

        <span class="Z3988">
            <xsl:attribute name="title">
                 <xsl:call-template name="renderCOinS"/>
            </xsl:attribute>
            &#xFEFF; <!-- non-breaking space to force separating the end tag -->
        </span>
        <xsl:copy-of select="$SFXLink" />
    </xsl:template>

    <xsl:template match="dim:field" mode="itemDetailView-DIM">
            <tr>
                <xsl:attribute name="class">
                    <xsl:text>ds-table-row </xsl:text>
                    <xsl:if test="(position() div 2 mod 2 = 0)">even </xsl:if>
                    <xsl:if test="(position() div 2 mod 2 = 1)">odd </xsl:if>
                </xsl:attribute>
                <td class="label-cell">
                    <xsl:value-of select="./@mdschema"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="./@element"/>
                    <xsl:if test="./@qualifier">
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="./@qualifier"/>
                    </xsl:if>
                </td>
            <td class="word-break">
              <xsl:copy-of select="./node()"/>
              <!--<xsl:if test="./@authority and ./@confidence">-->
                <!--<xsl:call-template name="authorityConfidenceIcon">-->
                  <!--<xsl:with-param name="confidence" select="./@confidence"/>-->
                <!--</xsl:call-template>-->
              <!--</xsl:if>-->
            </td>
                <td><xsl:value-of select="./@language"/></td>
            </tr>
    </xsl:template>

    <!-- don't render the item-view-toggle automatically in the summary view, only when it gets called -->
    <xsl:template match="dri:p[contains(@rend , 'item-view-toggle') and
        (preceding-sibling::dri:referenceSet[@type = 'summaryView'] or following-sibling::dri:referenceSet[@type = 'summaryView'])]">
    </xsl:template>

    <!-- don't render the head on the item view page -->
    <xsl:template match="dri:div[@n='item-view']/dri:head" priority="5">
    </xsl:template>

   <xsl:template match="mets:fileGrp[@USE='CONTENT']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>
            <xsl:choose>
                <!-- If one exists and it's of text/html MIME type, only display the primary bitstream -->
                <xsl:when test="mets:file[@ID=$primaryBitstream]/@MIMETYPE='text/html'">
                    <xsl:apply-templates select="mets:file[@ID=$primaryBitstream]">
                        <xsl:with-param name="context" select="$context"/>
                    </xsl:apply-templates>
                </xsl:when>
                <!-- Otherwise, iterate over and display all of them -->
                <xsl:otherwise>
                    <xsl:apply-templates select="mets:file">
                     	<!--Do not sort any more bitstream order can be changed-->
                        <!--<xsl:sort data-type="number" select="boolean(./@ID=$primaryBitstream)" order="descending" />-->
                        <!--<xsl:sort select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>-->
                        <xsl:with-param name="context" select="$context"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>

   <xsl:template match="mets:fileGrp[@USE='LICENSE']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>
            <xsl:apply-templates select="mets:file">
                        <xsl:with-param name="context" select="$context"/>
            </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="mets:file">
        <xsl:param name="context" select="."/>
        <div class="file-wrapper row">
            <div class="col-xs-6 col-sm-3">
                <div class="thumbnail">
                    <a class="image-link">
                        <xsl:attribute name="href">
                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                        mets:file[@GROUPID=current()/@GROUPID]">
                                <img alt="Thumbnail">
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                    mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:otherwise>
                                <!--<i class="glyphicon glyphicon-file" aria-hidden="true"/>-->
                                <img alt="Thumbnail">
                                    <xsl:attribute name="data-src">
                                        <xsl:text>holder.js/100%x</xsl:text>
                                        <xsl:value-of select="$thumbnail.maxheight"/>
                                        <xsl:text>/text:No Thumbnail</xsl:text>
                                    </xsl:attribute>
                                </img>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--<img data-src="holder.js/100%x180" alt="100%x180" style="max-width: 178px; width: 100%; display: block; margin:auto;" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAALIAAAC0CAYAAAAw03Z1AAAGuUlEQVR4Xu3Y10tkWRTF4V3mHFHxQUVFHxQxJ1T8280JFRMoGMEXU5kDxu59ZkqujuUUzLz08neh6W617nWv9dW551YsHo+/GQcJ/OEJxID8hzfIrx8SADIQJBIAskSNDAFkDEgkAGSJGhkCyBiQSADIEjUyBJAxIJEAkCVqZAggY0AiASBL1MgQQMaARAJAlqiRIYCMAYkEgCxRI0MAGQMSCQBZokaGADIGJBIAskSNDAFkDEgkAGSJGhkCyBiQSADIEjUyBJAxIJEAkCVqZAggY0AiASBL1MgQQMaARAJAlqiRIYCMAYkEgCxRI0MAGQMSCQBZokaGADIGJBIAskSNDAFkDEgkAGSJGhkCyBiQSADIEjUyBJAxIJEAkCVqZAggY0AiASBL1MgQQMaARAJAlqiRIYCMAYkEgCxRI0MAGQMSCQBZokaGADIGJBIAskSNDAFkDEgkAGSJGhkCyBiQSADIEjUyBJAxIJEAkCVqZAggY0AiASBL1MgQQMaARAJAlqiRIYCMAYkEgCxRI0MAGQMSCQBZokaGADIGJBIAskSNDAFkDEgkAGSJGhkCyBiQSADIEjUyBJAxIJEAkCVqZAggY0AiASBL1MgQQMaARAJAlqiRIYCMAYkEgCxRI0MAGQMSCQBZokaGADIGJBIAskSNDAFkDEgkAORIjXt7e3ZwcGADAwOWk5NjV1dXtrm5aRkZGe8/9fLyYtnZ2dbW1mbPz8+2sbFhFxcXlpaWZnV1deFPqsfn6/nrnp6ekp7z7e3N1tfX7fT01GKxmDU0NFhtbW2ql5P+OSD/rtchxuNx293dDWUPDQ1Zbm5u+NrS0tI/AKSnp9vo6KgtLCzY9fW1ZWZmBtQOrbW11aqrq79Fk+x6/qK5ubmk51xZWbGTk5MP1/M3VFVVlTTSVIYD8u+UxsfH7fHx8T2v4eHhsCL7kQDqWBcXF+38/Nyam5sD1snJSXPUIyMjYfV22JWVlWGlXF1dDd/r6uqym5ubsLL7St7R0RFe99X1fDVOds6Wlpbwe/rK79fzN5nDLikpsZ6enlS6lv4ZIP+N1W/Vs7Ozdn9/b1HIifaPj48DziicBOyampqA1ZEnVsjE98rKyuzh4cHu7u6sqakpbD38zZHsesnOWVpaGpD7Nsch+xbHYfv//fd14D/5AHKkfYfsID9D9i3D2NhYADg4OGj5+fnhVb7KHh4efvDT29trxcXFYcV1eK+vr+H7/jX/XvT46nrJzunXXl5etvLycuvs7Ay/i0POysoKWyF/Y/zkA8gpQD46OrK1tTWrqKiw9vb28ApfuaempsKK6NsHv9Vvb29bQUFBeFj0wx/mdnZ2wr/7+/utsLDwW8jfndO3JH493544XFbkj29bIKcAOXG7jz5YnZ2dhRWyqKjI+vr63lfIxK3eV/GJiYnwdT+ib4LEJT+vyN+d098cia2F3zH8zjE/P295eXnhLsGKHI+//eRbUnT2mZkZu729/bC18JXPQfrfDshXRD986+Bfd7C+R/aHvcvLy3fYvoL7Su4rtO+PfYvx+ROGz9f7t3NOT0+Hc/mDpn9a4pgbGxutvr7+x1fIihwh4Cucg4zukRN73a/2ovv7+2E7kTgcua/O/nDnn2D4KukPZg56a2vr/UHNP83w46vrJTunn9vfZP7xXHTf3d3d/eMf9DxLIP/Htcy3Dg7XPzXw2/z/cXx3Tkfsq7Ifvtpz/JUAkJEgkQCQJWpkCCBjQCIBIEvUyBBAxoBEAkCWqJEhgIwBiQSALFEjQwAZAxIJAFmiRoYAMgYkEgCyRI0MAWQMSCQAZIkaGQLIGJBIAMgSNTIEkDEgkQCQJWpkCCBjQCIBIEvUyBBAxoBEAkCWqJEhgIwBiQSALFEjQwAZAxIJAFmiRoYAMgYkEgCyRI0MAWQMSCQAZIkaGQLIGJBIAMgSNTIEkDEgkQCQJWpkCCBjQCIBIEvUyBBAxoBEAkCWqJEhgIwBiQSALFEjQwAZAxIJAFmiRoYAMgYkEgCyRI0MAWQMSCQAZIkaGQLIGJBIAMgSNTIEkDEgkQCQJWpkCCBjQCIBIEvUyBBAxoBEAkCWqJEhgIwBiQSALFEjQwAZAxIJAFmiRoYAMgYkEgCyRI0MAWQMSCQAZIkaGQLIGJBIAMgSNTIEkDEgkQCQJWpkCCBjQCIBIEvUyBBAxoBEAkCWqJEhgIwBiQSALFEjQwAZAxIJAFmiRoYAMgYkEgCyRI0MAWQMSCQAZIkaGQLIGJBIAMgSNTIEkDEgkQCQJWpkCCBjQCIBIEvUyBBAxoBEAr8AQizVRbhMmFcAAAAASUVORK5CYII="/>-->
                    </a>
                </div>
            </div>

            <div class="col-xs-6 col-sm-7">
                <dl class="file-metadata dl-horizontal">
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-name</i18n:text>
                        <xsl:text>:</xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:attribute name="title">
                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                        </xsl:attribute>
                        <xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:title, 30, 5)"/>
                    </dd>
                <!-- File size always comes in bytes and thus needs conversion -->
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text>
                        <xsl:text>:</xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:choose>
                            <xsl:when test="@SIZE &lt; 1024">
                                <xsl:value-of select="@SIZE"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
                            </xsl:when>
                            <xsl:when test="@SIZE &lt; 1024 * 1024">
                                <xsl:value-of select="substring(string(@SIZE div 1024),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
                            </xsl:when>
                            <xsl:when test="@SIZE &lt; 1024 * 1024 * 1024">
                                <xsl:value-of select="substring(string(@SIZE div (1024 * 1024)),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring(string(@SIZE div (1024 * 1024 * 1024)),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </dd>
                <!-- Lookup File Type description in local messages.xml based on MIME Type.
         In the original DSpace, this would get resolved to an application via
         the Bitstream Registry, but we are constrained by the capabilities of METS
         and can't really pass that info through. -->
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text>
                        <xsl:text>:</xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:call-template name="getFileTypeDesc">
                            <xsl:with-param name="mimetype">
				 <xsl:value-of select="@MIMETYPE"/>
<!--
                                <xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
                                <xsl:text>/</xsl:text>
                                <xsl:value-of select="substring-before(substring-after(@MIMETYPE,'/'),';')"/>
-->
                            </xsl:with-param>
                        </xsl:call-template>
                    </dd>
                <!---->
                <!-- Display the contents of 'Description' only if bitstream contains a description -->
                <xsl:if test="mets:FLocat[@LOCTYPE='URL']/@xlink:label != ''">
                        <dt>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-description</i18n:text>
                            <xsl:text>:</xsl:text>
                        </dt>
                        <dd class="word-break">
                            <xsl:attribute name="title">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/>
                            </xsl:attribute>
                            <!--<xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/>-->
                            <xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:label, 30, 5)"/>
                        </dd>
                </xsl:if>
                </dl>
            </div>

            <div class="file-link col-xs-6 col-xs-offset-6 col-sm-2 col-sm-offset-0">
                <xsl:choose>
                    <xsl:when test="@ADMID">
                        <xsl:call-template name="display-rights"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="view-open"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </div>

</xsl:template>

    <xsl:template name="view-open">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
            </xsl:attribute>
            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
        </a>
    </xsl:template>

    <xsl:template name="display-rights">
        <xsl:variable name="file_id" select="jstring:replaceAll(jstring:replaceAll(string(@ADMID), '_METSRIGHTS', ''), 'rightsMD_', '')"/>
        <xsl:variable name="rights_declaration" select="../../../mets:amdSec/mets:rightsMD[@ID = concat('rightsMD_', $file_id, '_METSRIGHTS')]/mets:mdWrap/mets:xmlData/rights:RightsDeclarationMD"/>
        <xsl:variable name="rights_context" select="$rights_declaration/rights:Context"/>
        <xsl:variable name="users">
            <xsl:for-each select="$rights_declaration/*">
                <xsl:value-of select="rights:UserName"/>
                <xsl:choose>
                    <xsl:when test="rights:UserName/@USERTYPE = 'GROUP'">
                       <xsl:text> (group)</xsl:text>
                    </xsl:when>
                    <xsl:when test="rights:UserName/@USERTYPE = 'INDIVIDUAL'">
                       <xsl:text> (individual)</xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="not ($rights_context/@CONTEXTCLASS = 'GENERAL PUBLIC') and ($rights_context/rights:Permissions/@DISPLAY = 'true')">
                <a href="{mets:FLocat[@LOCTYPE='URL']/@xlink:href}">
                    <img width="64" height="64" src="{concat($theme-path,'/images/Crystal_Clear_action_lock3_64px.png')}" title="Read access available for {$users}"/>
                    <!-- icon source: http://commons.wikimedia.org/wiki/File:Crystal_Clear_action_lock3.png -->
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="view-open"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getFileIcon">
        <xsl:param name="mimetype"/>
            <i aria-hidden="true">
                <xsl:attribute name="class">
                <xsl:text>glyphicon </xsl:text>
                <xsl:choose>
                    <xsl:when test="contains(mets:FLocat[@LOCTYPE='URL']/@xlink:href,'isAllowed=n')">
                        <xsl:text> glyphicon-lock</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> glyphicon-file</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                </xsl:attribute>
            </i>
        <xsl:text> </xsl:text>
    </xsl:template>

    <!-- Generate the license information from the file section -->
    <xsl:template match="mets:fileGrp[@USE='CC-LICENSE']" mode="simple">
        <li><a href="{mets:file/mets:FLocat[@xlink:title='license_text']/@xlink:href}"><i18n:text>xmlui.dri2xhtml.structural.link_cc</i18n:text></a></li>
    </xsl:template>

    <!-- Generate the license information from the file section -->
    <xsl:template match="mets:fileGrp[@USE='LICENSE']" mode="simple">
        <li><a href="{mets:file/mets:FLocat[@xlink:title='license.txt']/@xlink:href}"><i18n:text>xmlui.dri2xhtml.structural.link_original_license</i18n:text></a></li>
    </xsl:template>

</xsl:stylesheet>
