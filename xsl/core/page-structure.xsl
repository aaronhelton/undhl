
<!--
    Main structure of the page, determines where
    header, footer, body, navigation are structurally rendered.
    Rendering of the header, footer, trail and alerts

    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
    Author: Alexey Maslov

-->

<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                xmlns:dri="http://di.tamu.edu/DRI/1.0/"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:xlink="http://www.w3.org/TR/xlink/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:confman="org.dspace.core.ConfigurationManager"
                exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc confman">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!--
        Requested Page URI. Some functions may alter behavior of processing depending if URI matches a pattern.
        Specifically, adding a static page will need to override the DRI, to directly add content.
    -->
    <xsl:variable name="request-uri" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI']"/>

    <!-- Make the userMeta available to other templates -->
    <xsl:variable name="thisUserMeta" select="/dri:document/dri:meta/dri:userMeta"/>

    <!--
        The starting point of any XSL processing is matching the root element. In DRI the root element is document,
        which contains a version attribute and three top level elements: body, options, meta (in that order).

        This template creates the html document, giving it a head and body. A title and the CSS style reference
        are placed in the html head, while the body is further split into several divs. The top-level div
        directly under html body is called "ds-main". It is further subdivided into:
            "ds-header"  - the header div containing title, subtitle, trail and other front matter
            "ds-body"    - the div containing all the content of the page; built from the contents of dri:body
            "ds-options" - the div with all the navigation and actions; built from the contents of dri:options
            "ds-footer"  - optional footer div, containing misc information

        The order in which the top level divisions appear may have some impact on the design of CSS and the
        final appearance of the DSpace page. While the layout of the DRI schema does favor the above div
        arrangement, nothing is preventing the designer from changing them around or adding new ones by
        overriding the dri:document template.
    -->
    <xsl:template match="dri:document">

        <xsl:choose>
            <xsl:when test="not($isModal)">

                <!--THIS (LACK OF) INDENTATION IS ON PURPOSE, DON'T CHANGE IT ##START##-->
            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;
            </xsl:text>
            <xsl:text disable-output-escaping="yes"> &lt;html class=&quot;no-js&quot; lang=&quot;en&quot;&gt;</xsl:text>
                <!--THIS (LACK OF) INDENTATION IS ON PURPOSE, DON'T CHANGE IT ##END##-->

                <!-- First of all, build the HTML head element -->

                <xsl:call-template name="buildHead"/>

                <!-- Then proceed to the body -->
                <body>
                    <!-- Prompt IE 6 users to install Chrome Frame. Remove this if you support IE 6.
                   chromium.org/developers/how-tos/chrome-frame-getting-started -->
                    <!--[if lt IE 7]><p class=chromeframe>Your browser is <em>ancient!</em> <a href="http://browsehappy.com/">Upgrade to a different browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">install Google Chrome Frame</a> to experience this site.</p><![endif]-->
                    <xsl:choose>
                        <xsl:when
                                test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='framing'][@qualifier='popup']">
                            <xsl:apply-templates select="dri:body/*"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="buildHeader"/>
                            <xsl:call-template name="buildTrail"/>
                            <!--javascript-disabled warning, will be invisible if javascript is enabled-->
                            <div id="no-js-warning-wrapper" class="hidden">
                                <div id="no-js-warning">
                                    <div class="notice failure">
                                        <xsl:text>JavaScript is disabled for your browser. Some features of this site may not work without it.</xsl:text>
                                    </div>
                                </div>
                            </div>

                            <div id="main-container" class="container">

                                <!-- search form -->
                                <xsl:apply-templates select="dri:options">
					<xsl:with-param name="search-only" select="1" />
				</xsl:apply-templates>
                                <!-- /search form -->


			     <xsl:choose>


	
				<xsl:when test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI'] = ''">


					<div class="row">
						<div id="carousel-example-generic" class="carousel slide col-md-12" data-ride="carousel">
						  <!-- Indicators -->
						  <ol class="carousel-indicators">
						    <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
						    <li data-target="#carousel-example-generic" data-slide-to="1"></li>
						    <li data-target="#carousel-example-generic" data-slide-to="2"></li>
						  </ol>

						  <!-- Wrapper for slides -->
						  <div class="carousel-inner">
						    <div class="item active">
							<img src="/themes/undhl/images/edit-559993.jpg" alt="pi1" class="img-responsive" />
							<div class="carousel-caption">
								<h3>
								<a>
									<xsl:attribute name="href">/discover?filtertype_1=agenda&amp;filter_relational_operator_1=equals&amp;filter_1=DEMOCRATIC+REPUBLIC+OF+THE+CONGO+SITUATION</xsl:attribute>
									<i18n:text>xmlui.ArtifactBrowser.navigation.head_congo_situation</i18n:text>
								</a>
								</h3>
							</div>
						    </div>
						    <div class="item">
							<img src="/themes/undhl/images/edit-594678.jpg" alt="pi1" class="img-responsive" />
							<div class="carousel-caption">
								<h3>
                                                                <a>
                                                                        <xsl:attribute name="href">/discover?filtertype_1=agenda&amp;filter_relational_operator_1=equals&amp;filter_1=CHILDREN+IN+ARMED+CONFLICTS</xsl:attribute>
                                                                       	<i18n:text>xmlui.ArtifactBrowser.navigation.head_children_in_armed_conflicts</i18n:text>
                                                                </a>
                                                                </h3>
							</div>
						    </div>
						    <div class="item">
							<img src="/themes/undhl/images/cropped-516848.jpg" alt="pi1" class="img-responsive" />
							<div class="carousel-caption">
                                                                <h3>
                                                                <a>
                                                                        <xsl:attribute name="href">/discover?filtertype_1=agenda&amp;filter_relational_operator_1=equals&amp;filter_1=SYRIAN+ARAB+REPUBLIC+SITUATION</xsl:attribute>
                                                                        <i18n:text>xmlui.ArtifactBrowser.navigation.head_syria_situation</i18n:text>
                                                                </a>
                                                                </h3>
							</div>
						    </div>
						  </div>

						  <!-- Controls -->
						  <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
						    <span class="glyphicon glyphicon-chevron-left"></span>
						  </a>
						  <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
						    <span class="glyphicon glyphicon-chevron-right"></span>
						  </a>
						</div>
					</div>


					<!-- <h3><i18n:text>xmlui.ArtifactBrowser.Navigation.head_discover</i18n:text></h3> -->

					<div class="row" id="home_browse_row">
						<div class="col-md-3">
							<!-- <h4><a href="/search-filter?field=issuingBody">UN Bodies</a></h4> -->
							<h4><a href="/search-filter?field=issuingBody"><i18n:text>xmlui.ArtifactBrowser.Navigation.browse_issuingbody</i18n:text></a></h4>
							<a href="/search-filter?field=issuingBody">
								<img src="/themes/undhl/images/cropped-595698.jpg"/>
							</a>
						</div>
                                                <div class="col-md-3">
							<h4><a href="/search-filter?field=spatial"><i18n:text>xmlui.ArtifactBrowser.Navigation.browse_spatial</i18n:text></a></h4>
							<a href="/search-filter?field=spatial">
								<img src="/themes/undhl/images/regions-and-countries.png"/>
							</a>
                                                </div>
                                                <div class="col-md-3">
							<!-- <h4><a href="/search-filter?field=series">Series</a></h4> -->
							<h4><a href="/community-list"><i18n:text>xmlui.ArtifactBrowser.Navigation.browse_series</i18n:text></a></h4>
							<a href="/community-list">
								<img src="/themes/undhl/images/cropped-YB-shadow.jpg" />
							</a>
                                                </div>
                                                <div class="col-md-3">
							<!-- <h4><a href="/search-filter?field=contentType">Content type</a></h4>	-->
							<h4><a href="/search-filter?field=contentType"><i18n:text>xmlui.ArtifactBrowser.Navigation.browse_contenttype</i18n:text></a></h4>	
							<a href="/search-filter?field=contentType">
								<img src="/themes/undhl/images/cropped-492744.jpg" />			
							</a>
                                                </div>

					</div>



				</xsl:when>
				<xsl:otherwise>
                                <div class="row row-offcanvas row-offcanvas-right">
                                    <div class="horizontal-slider clearfix">
					<xsl:choose>
						<xsl:when test="/dri:document/dri:body/dri:div[@id='aspect.artifactbrowser.ItemViewer.div.item-view'] or contains(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI'], 'search-filter')" >

							<div class="col-xs-12 col-sm-12 col-md-12 main-content">
								<xsl:apply-templates select="*[not(self::dri:options)]"/>
								<div class="visible-xs visible-sm">
									<xsl:call-template name="buildFooter"/>
								</div>

							</div>							

						</xsl:when>
						<xsl:otherwise>
                                        		<div class="col-xs-6 col-sm-3 sidebar-offcanvas" id="sidebar" role="navigation">
                                            			<xsl:apply-templates select="dri:options"/>
                                        		</div>
                                                        <div class="col-xs-12 col-sm-12 col-md-9 main-content">
                                                                <xsl:apply-templates select="*[not(self::dri:options)]"/>
                                                                <div class="visible-xs visible-sm">
                                                                        <xsl:call-template name="buildFooter"/>
                                                                </div>

                                                        </div>

						</xsl:otherwise>
					</xsl:choose>

<!--
                                        <div class="col-xs-12 col-sm-12 col-md-9 main-content">
					    <xsl:if test="/dri:document/dri:body/dri:div[@id='aspect.artifactbrowser.ItemViewer.div.item-view']">
						Item landing
					    </xsl:if>
                                            <xsl:apply-templates select="*[not(self::dri:options)]"/>

                                            <div class="visible-xs visible-sm">
                                                <xsl:call-template name="buildFooter"/>
                                            </div>
                                        </div>
-->
<!--
                                        <div class="col-xs-6 col-sm-3 sidebar-offcanvas" id="sidebar" role="navigation">
                                            <xsl:apply-templates select="dri:options"/>
                                        </div>
-->
                                    </div>
                                </div>
				</xsl:otherwise>
			     </xsl:choose>	

                                <!--
                            The footer div, dropping whatever extra information is needed on the page. It will
                            most likely be something similar in structure to the currently given example. -->
                            <div class="hidden-xs hidden-sm">
                            <xsl:call-template name="buildFooter"/>
                             </div>
                         </div>


                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- Javascript at the bottom for fast page loading -->
                    <xsl:call-template name="addJavascript"/>
                </body>
                <xsl:text disable-output-escaping="yes">&lt;/html&gt;</xsl:text>

            </xsl:when>
            <xsl:otherwise>
                <!-- This is only a starting point. If you want to use this feature you need to implement
                JavaScript code and a XSLT template by yourself. Currently this is used for the DSpace Value Lookup -->
                <xsl:apply-templates select="dri:body" mode="modal"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this
    information is either user-provided bits of post-processing (as in the case of the JavaScript), or
    references to stylesheets pulled directly from the pageMeta element. -->
    <xsl:template name="buildHead">
        <head>
            <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

            <!-- Use the .htaccess and remove these lines to avoid edge case issues.
             More info: h5bp.com/i/378 -->
            <!-- This was in here twice.  Removing to see if it fixes IE issue on prod -->
            <!-- <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/> -->
            

            <!-- Mobile viewport optimized: h5bp.com/viewport -->
            <meta name="viewport" content="width=device-width,initial-scale=1"/>

            <link rel="shortcut icon">
                <xsl:attribute name="href">
                    <!-- <xsl:value-of select="$theme-path"/> -->
			<xsl:text>/themes/undhl/images/favicon.ico</xsl:text>
			<!-- <xsl:text>lib/images/favicon.ico</xsl:text> -->
                </xsl:attribute>
            </link>
            <link rel="apple-touch-icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="$theme-path"/>
                    <xsl:text>lib/images/apple-touch-icon.png</xsl:text>
                </xsl:attribute>
            </link>

            <meta name="Generator">
                <xsl:attribute name="content">
                    <xsl:text>DSpace</xsl:text>
                    <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']"/>
                    </xsl:if>
                </xsl:attribute>
            </meta>

            <!-- Add stylsheets -->

            <!--TODO figure out a way to include these in the concat & minify-->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='stylesheet']">
                <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="media">
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$theme-path"/>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>

            <!--### CLASSIC MIRAGE COLOR SCHEME START ###-->
            <link rel="stylesheet" href="{concat($theme-path, 'styles/bootstrap-classic-mirage-colors-min.css')}"/>
            <link rel="stylesheet" href="{concat($theme-path, 'styles/classic-mirage-style.css')}"/>
            <!--### CLASSIC MIRAGE COLOR SCHEME END ###-->

            <!--### BOOTSTRAP COLOR SCHEME START ###-->
            <!--<link rel="stylesheet" href="{concat($theme-path, 'styles/bootstrap-min.css')}"/>-->
            <!--### BOOTSTRAP COLOR SCHEME END ###-->

            <link rel="stylesheet" href="{concat($theme-path, 'styles/dspace-bootstrap-tweaks.css')}"/>
            <link rel="stylesheet" href="{concat($theme-path, 'styles/jquery-ui-1.10.3.custom.css')}"/>

	    <!-- ksd styles -->
            <link rel="stylesheet" href="/themes/undhl/styles/ksd_styles.css"/>
            <!-- /ksd styles -->

	    <!-- jquery for the carousel -->
<!--	
	    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
	    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css"/>
	    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>	
-->
<!--
	    <script src="/themes/undhl/scripts/jquery.jcarousel.min.js" > </script>
-->
	    <!-- jquery for the carousel -->	

            <!-- Add syndication feeds -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']">
                <link rel="alternate" type="application">
                    <xsl:attribute name="type">
                        <xsl:text>application/</xsl:text>
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>

            <!--  Add OpenSearch auto-discovery link -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']">
                <link rel="search" type="application/opensearchdescription+xml">
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='scheme']"/>
                        <xsl:text>://</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/>
                        <xsl:text>:</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverPort']"/>
                        <xsl:value-of select="$context-path"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='context']"/>
                        <xsl:text>description.xml</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title" >
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']"/>
                    </xsl:attribute>
                </link>
            </xsl:if>

            <!-- The following javascript removes the default text of empty text areas when they are focused on or submitted -->
            <!-- There is also javascript to disable submitting a form when the 'enter' key is pressed. -->
            <script>
                //Clear default text of emty text areas on focus
                function tFocus(element)
                {
                if (element.value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){element.value='';}
                }
                //Clear default text of emty text areas on submit
                function tSubmit(form)
                {
                var defaultedElements = document.getElementsByTagName("textarea");
                for (var i=0; i != defaultedElements.length; i++){
                if (defaultedElements[i].value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){
                defaultedElements[i].value='';}}
                }
                //Disable pressing 'enter' key to submit a form (otherwise pressing 'enter' causes a submission to start over)
                function disableEnterKey(e)
                {
                var key;

                if(window.event)
                key = window.event.keyCode;     //Internet Explorer
                else
                key = e.which;     //Firefox and Netscape

                if(key == 13)  //if "Enter" pressed, then disable!
                return false;
                else
                return true;
                }
            </script>

            <xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 9]&gt;
                &lt;script src="</xsl:text><xsl:value-of select="concat($theme-path, 'vendor/html5shiv/dist/html5shiv.js')"/><xsl:text disable-output-escaping="yes">"&gt;&#160;&lt;/script&gt;
                &lt;script src="</xsl:text><xsl:value-of select="concat($theme-path, 'vendor/respond/respond.min.js')"/><xsl:text disable-output-escaping="yes">"&gt;&#160;&lt;/script&gt;
                &lt;![endif]--&gt;</xsl:text>

            <!-- Modernizr enables HTML5 elements & feature detects -->
            <script src="{concat($theme-path, 'vendor/modernizr/modernizr.js')}">&#160;</script>

            <!-- Add the title in -->
            <xsl:variable name="page_title" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title'][last()]" />
            <title>
                <xsl:choose>
                    <xsl:when test="starts-with($request-uri, 'page/about')">
                        <xsl:text>About This Repository</xsl:text>
                    </xsl:when>
                    <xsl:when test="not($page_title)">
                        <xsl:text>  </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="$page_title/node()" />
                    </xsl:otherwise>
                </xsl:choose>
            </title>

            <!-- Head metadata in item pages -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']">
                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']"
                              disable-output-escaping="yes"/>
            </xsl:if>

            <!-- Add all Google Scholar Metadata values -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[substring(@element, 1, 9) = 'citation_']">
                <meta name="{@element}" content="{.}"></meta>
            </xsl:for-each>

        </head>
    </xsl:template>


    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->
    <xsl:template name="buildHeader">


        <header>
            <div class="navbar navbar-default navbar-static-top" role="navigation">

		<div id="un_brand_bar">

<!--
                    	<div class="row navbar_row">
-->
			<div class="container">
                                <div class="col-md-6" id="un_icon">
                                        <a href="http://www.un.org/en/" title="United Nations Headquarters website">Welcome to the United Nations. It's your world.</a>
                                </div>
                                <div class="col-md-6" id="brand_language_selector">
                                        <div class="content">
                                                <ul class="language-switcher-locale-url">
                                                        <!-- <li class="ar first"><a href="http://www.un.org/ar" class="language-link" lang="ar" xml:lang="ar">عربي</a></li>-->
                                                        <!-- <li class="zh-hans"><a href="http://www.un.org/zh" class="language-link" lang="zh-hans" xml:lang="zh-hans">中文</a></li> -->
                                                        <li class="en"><a href="/?locale-attribute=en" class="language-link" lang="en" xml:lang="en">English</a></li>
                                                        <li class="fr"><a href="/?locale-attribute=fr" class="language-link" lang="fr" xml:lang="fr">Français</a></li>
                                                        <!-- <li class="ru"><a href="http://www.un.org/ru" class="language-link" lang="ru" xml:lang="ru">Русский</a></li>-->
                                                        <li class="es last"><a href="/?locale-attribute=es" class="language-link" lang="es" xml:lang="es">Español</a></li>
                                                </ul>
                                        </div>
                                </div>

			</div>
		</div>

                <div class="container">

                    <div class="row navbar_row" id="dhl_brand_bar">
			<div class="col-md-6" id="dhl_logo">
<!--
				<div id="dhl_logo_img">
					<img src="http://www.unmultimedia.org/oralhistory/wp-content/themes/DHL-OHP/images/dhl_vid.png" alt="DHL Logo" />
				</div>
-->
				<div id="dhl_logo_img">
					<a href="http://www.un.org/depts/dhl/"><img src="/themes/undhl/images/dhl_logo.png" alt="DHL Logo" /></a>
				</div>
			</div>
			<div class="col-md-6" id="dhl_dr_logo">
				<h1><a href="/"><i18n:text>xmlui.general.dspace_home</i18n:text></a></h1>	
			</div>	
                    </div>			

		    <div class="row navbar_row" id="dr_top_level_bar">

			<div class="col-md-6" id="dr_nav_left">

			   <ul class="nav nav-pills pull-left bodies_list">
				<!-- <li><a href="">General Assembly</a></li> -->
				<li class="dropdown">
                                        <!-- To do: internationalize these -->
					<a class="dropdown-toggle" data-toggle="dropdown" href="#">
						Security Council<span class="caret"></span>
					</a>
					<ul class="dropdown-menu" role="menu">
						<li><a href="/discover?filtertype=issuingBody&amp;filter_relational_operator=equals&amp;filter=Security+Council">All documents and publications</a></li>
						<li><a href="/discover?filtertype=issuingBody&amp;filter_relational_operator=equals&amp;filter=Security+Council+Plenary">Plenary documents</a></li>
						<li><a href="/discover?filtertype=issuingBody&amp;filter_relational_operator=equals&amp;filter=Security+Council+Subsidiary+Bodies">Subsidiary Bodies</a></li>
					</ul>	
				</li>
<!--
				<li><a href="">About DAG Repository</a></li>
				<li><a href="">Search</a></li>
                                <li><a href="">Learn</a></li>
                                <li class="dropdown">
					<a class="dropdown-toggle" data-toggle="dropdown" href="#">
						Go To<span class="caret"></span>				
					</a>
                                        <ul class="dropdown-menu" role="menu">
                                                <li><a href="">DAG Repository</a></li>
                                                <li><a href="">DAG Discovery</a></li>
                                                <li><a href="">Research Guides</a></li>
						<li><a href="">Ask DAG</a></li>
						<li><a href="">Contact Us</a></li>
                                        </ul>
				</li>
-->
			    </ul>

			</div>

			<div class="col-md-6" id="dr_nav_right">

			    <ul class="nav nav-pills pull-right bodies_list">	

				<!-- To do: internationalize these strings -->
				<li><a href="/discover">Discover</a></li>

				<li><a href="http://research.un.org/en/repository/about">About DAG Repository</a></li>

                            <xsl:choose>
                                <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
                                    <li class="dropdown">
                                        <a id="user-dropdown-toggle" href="#" role="button" class="dropdown-toggle"
                                           data-toggle="dropdown">
                                            <span class="hidden-xs">
                                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='firstName']"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='lastName']"/>
                                                &#160;
                                                <b class="caret"/>
                                            </span>
                                        </a>
                                        <ul class="dropdown-menu pull-right" role="menu"
                                            aria-labelledby="user-dropdown-toggle" data-no-collapse="true">
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='url']}">
                                                    <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='logoutURL']}">
                                                    <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                                                </a>
                                            </li>
                                        </ul>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='loginURL']}">
                                            <span class="hidden-xs">
                                                <i18n:text>xmlui.dri2xhtml.structural.login</i18n:text>
                                            </span>
                                        </a>
                                    </li>
                                </xsl:otherwise>
                            </xsl:choose>



				<!--
				<li><a href="">Economic and Social Council</a></li>
				<li><a href="">Human Rights Council</a></li>
				-->
			</ul>
			</div>
		    </div>	

<!--
                    <div class="navbar-header">

                        <button type="button" class="navbar-toggle" data-toggle="offcanvas">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>

                        <a href="{$context-path}/" class="navbar-brand">
                            <img src="{$theme-path}/images/DSpace-logo-line.svg" />
                        </a>


                        <div class="navbar-header pull-right visible-xs hidden-sm hidden-md hidden-lg">
                        <ul class="nav nav-pills pull-left ">

                            <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']) &gt; 1">
                                <li id="ds-language-selection-xs" class="dropdown">
                                    <xsl:variable name="active-locale" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='currentLocale']"/>
                                    <button id="language-dropdown-toggle-xs" href="#" role="button" class="dropdown-toggle navbar-toggle navbar-link" data-toggle="dropdown">
                                        <b class="visible-xs glyphicon glyphicon-globe" aria-hidden="true"/>
                                    </button>
                                    <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="language-dropdown-toggle-xs" data-no-collapse="true">
                                        <xsl:for-each
                                                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']">
                                            <xsl:variable name="locale" select="."/>
                                            <li role="presentation">
                                                <xsl:if test="$locale = $active-locale">
                                                    <xsl:attribute name="class">
                                                        <xsl:text>disabled</xsl:text>
                                                    </xsl:attribute>
                                                </xsl:if>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$current-uri"/>
                                                        <xsl:text>?locale-attribute=</xsl:text>
                                                        <xsl:value-of select="$locale"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of
                                                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='supportedLocale'][@qualifier=$locale]"/>
                                                </a>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </li>
                            </xsl:if>

                            <xsl:choose>
                                <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
                                    <li class="dropdown">
                                        <button class="dropdown-toggle navbar-toggle navbar-link" id="user-dropdown-toggle-xs" href="#" role="button"  data-toggle="dropdown">
                                            <b class="visible-xs glyphicon glyphicon-user" aria-hidden="true"/>
                                        </button>
                                        <ul class="dropdown-menu pull-right" role="menu"
                                            aria-labelledby="user-dropdown-toggle-xs" data-no-collapse="true">
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='url']}">
                                                    <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='logoutURL']}">
                                                    <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                                                </a>
                                            </li>
                                        </ul>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <form style="display: inline" action="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='loginURL']}" method="get">
                                            <button class="navbar-toggle navbar-link">
                                            <b class="visible-xs glyphicon glyphicon-user" aria-hidden="true"/>
                                            </button>
                                        </form>
                                    </li>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ul>
                              </div>
                    </div>

                    <div class="navbar-header pull-right hidden-xs">
                        <ul class="nav navbar-nav pull-left">
                              <xsl:call-template name="languageSelection"/>
                        </ul>
                        <ul class="nav navbar-nav pull-left">
                            <xsl:choose>
                                <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
                                    <li class="dropdown">
                                        <a id="user-dropdown-toggle" href="#" role="button" class="dropdown-toggle"
                                           data-toggle="dropdown">
                                            <span class="hidden-xs">
                                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='firstName']"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='lastName']"/>
                                                &#160;
                                                <b class="caret"/>
                                            </span>
                                        </a>
                                        <ul class="dropdown-menu pull-right" role="menu"
                                            aria-labelledby="user-dropdown-toggle" data-no-collapse="true">
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='url']}">
                                                    <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='logoutURL']}">
                                                    <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                                                </a>
                                            </li>
                                        </ul>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='loginURL']}">
                                            <span class="hidden-xs">
                                                <i18n:text>xmlui.dri2xhtml.structural.login</i18n:text>
                                            </span>
                                        </a>
                                    </li>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ul>

                        <button data-toggle="offcanvas" class="navbar-toggle visible-sm" type="button">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                    </div>
-->
                </div>
            </div>

        </header>

    </xsl:template>


    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->
    <xsl:template name="buildTrail">
        <div class="trail-wrapper">
            <div class="container">
                <div class="row">
                    <!--TODO-->
                    <!--<div class="col-xs-9 col-sm-10 col-md-12">-->
                    <div class="col-xs-12">
                        <xsl:choose>
                            <xsl:when test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) > 1">
                                <div class="breadcrumb dropdown visible-xs">
                                    <a id="trail-dropdown-toggle" href="#" role="button" class="dropdown-toggle"
                                       data-toggle="dropdown">
                                        <xsl:variable name="last-node"
                                                      select="/dri:document/dri:meta/dri:pageMeta/dri:trail[last()]"/>
                                        <xsl:choose>
                                            <xsl:when test="$last-node/i18n:*">
                                                <xsl:apply-templates select="$last-node/*"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:apply-templates select="$last-node/text()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:text>&#160;</xsl:text>
                                        <b class="caret"/>
                                    </a>
                                    <ul class="dropdown-menu" role="menu" aria-labelledby="trail-dropdown-toggle">
                                        <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"
                                                             mode="dropdown"/>
                                    </ul>
                                </div>
                                <ul class="breadcrumb hidden-xs">
                                    <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
                                </ul>
                            </xsl:when>
                            <xsl:otherwise>
                                <ul class="breadcrumb">
                                    <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
                                </ul>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </div>
            </div>
        </div>


    </xsl:template>

    <xsl:template match="dri:trail">
        <!--put an arrow between the parts of the trail-->
        <li>
            <xsl:if test="position()=1">
                <i class="glyphicon glyphicon-home" aria-hidden="true"/>&#160;
            </xsl:if>
            <!-- Determine whether we are dealing with a link or plain text trail link -->
            <xsl:choose>
                <xsl:when test="./@target">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="./@target"/>
                        </xsl:attribute>
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">active</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <xsl:template match="dri:trail" mode="dropdown">
        <!--put an arrow between the parts of the trail-->
        <li role="presentation">
            <!-- Determine whether we are dealing with a link or plain text trail link -->
            <xsl:choose>
                <xsl:when test="./@target">
                    <a role="menuitem">
                        <xsl:attribute name="href">
                            <xsl:value-of select="./@target"/>
                        </xsl:attribute>
                        <xsl:if test="position()=1">
                            <i class="glyphicon glyphicon-home" aria-hidden="true"/>&#160;
                        </xsl:if>
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:when test="position() > 1 and position() = last()">
                    <xsl:attribute name="class">disabled</xsl:attribute>
                    <a role="menuitem" href="#">
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">active</xsl:attribute>
                    <xsl:if test="position()=1">
                        <i class="glyphicon glyphicon-home" aria-hidden="true"/>&#160;
                    </xsl:if>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <xsl:template name="cc-license">
        <xsl:param name="metadataURL"/>
        <xsl:variable name="externalMetadataURL">
            <xsl:text>cocoon:/</xsl:text>
            <xsl:value-of select="$metadataURL"/>
            <xsl:text>?sections=dmdSec,fileSec&amp;fileGrpTypes=THUMBNAIL</xsl:text>
        </xsl:variable>

        <xsl:variable name="ccLicenseName"
                      select="document($externalMetadataURL)//dim:field[@element='rights']"
                />
        <xsl:variable name="ccLicenseUri"
                      select="document($externalMetadataURL)//dim:field[@element='rights'][@qualifier='uri']"
                />
        <xsl:variable name="handleUri">
            <xsl:for-each select="document($externalMetadataURL)//dim:field[@element='identifier' and @qualifier='uri']">
                <a>
                    <xsl:attribute name="href">
                        <xsl:copy-of select="./node()"/>
                    </xsl:attribute>
                    <xsl:copy-of select="./node()"/>
                </a>
                <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <xsl:if test="$ccLicenseName and $ccLicenseUri and contains($ccLicenseUri, 'creativecommons')">
            <div about="{$handleUri}" class="row">
                <!--<xsl:attribute name="style">-->
                    <!--<xsl:text>margin:0em 2em 0em 2em; padding-bottom:0em;</xsl:text>-->
                <!--</xsl:attribute>-->
            <div class="col-sm-3 col-xs-12">
                <a rel="license"
                   href="{$ccLicenseUri}"
                   alt="{$ccLicenseName}"
                   title="{$ccLicenseName}"
                        >
                    <img class="img-responsive">
                        <xsl:attribute name="src">
                            <xsl:value-of select="concat($theme-path,'/images/cc-ship.gif')"/>
                        </xsl:attribute>
                        <xsl:attribute name="alt">
                            <xsl:value-of select="$ccLicenseName"/>
                        </xsl:attribute>
                    </img>
                </a>
            </div> <div class="col-sm-8">
                <span>
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.cc-license-text</i18n:text>
                    <xsl:value-of select="$ccLicenseName"/>
                </span>
            </div>
            </div>
        </xsl:if>
    </xsl:template>

    <!-- Like the header, the footer contains various miscellaneous text, links, and image placeholders -->
    <!-- To do: internationalize these as well -->
    <xsl:template name="buildFooter">
        <footer>
                <div class="row">
		     <div class="col-md-12">
                	<ul id="footer_links">
				<li class="first"><a href="/contact">Contact Us</a></li>
				<!-- <li><a href="">Request a Copy</a></li> -->
				<li><a href="/">About the DAG Repository</a></li>
                        	<li><a href="http://www.un.org/en/aboutun/copyright/">Copyright</a></li>
                                <li><a href="http://www.un.org/en/aboutun/terms/">Terms of use</a></li>
                                <li><a href="http://www.un.org/en/aboutun/privacy/">Privacy Notice</a></li>
                              	<li><a href="http://www.un.org/en/aboutun/fraudalert/">Fraud Alert</a></li>
                        </ul>
		    </div>
<!--
                    <hr/>
                    <div class="col-xs-7 col-sm-8">
                        <div>
                            <a href="http://www.dspace.org/" target="_blank">DSpace software</a> copyright&#160;&#169;&#160;2002-2013&#160; <a href="http://www.duraspace.org/" target="_blank">Duraspace</a>
                        </div>
                        <div>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                                    <xsl:text>/contact</xsl:text>
                                </xsl:attribute>
                                <i18n:text>xmlui.dri2xhtml.structural.contact-link</i18n:text>
                            </a>
                            <xsl:text> | </xsl:text>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                                    <xsl:text>/feedback</xsl:text>
                                </xsl:attribute>
                                <i18n:text>xmlui.dri2xhtml.structural.feedback-link</i18n:text>
                            </a>
                        </div>
                    </div>
                    <div class="col-xs-5 col-sm-4">
                        <div class="pull-right">
                            <span class="theme-by">Theme by&#160;</span>
                            <br/>
                            <a title="@mire NV" target="_blank" href="http://atmire.com">
                                <img alt="@mire NV" src="{concat($theme-path, '/images/@mirelogo-small.png')}"/>
                            </a>
                        </div>

                    </div>
-->
                </div>

                <!--Invisible link to HTML sitemap (for search engines) -->
                <a class="hidden">
                    <xsl:attribute name="href">
                        <xsl:value-of
                                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/htmlmap</xsl:text>
                    </xsl:attribute>
                    <xsl:text>&#160;</xsl:text>
                </a>
            <p>&#160;</p>
        </footer>
    </xsl:template>


    <!--
            The meta, body, options elements; the three top-level elements in the schema
    -->




    <!--
        The template to handle the dri:body element. It simply creates the ds-body div and applies
        templates of the body's child elements (which consists entirely of dri:div tags).
    -->
    <xsl:template match="dri:body">
        <div>
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']">
                <div class="alert">
                    <button type="button" class="close" data-dismiss="alert">&#215;</button>
                    <xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']/node()"/>
                </div>
            </xsl:if>

            <!-- Check for the custom pages -->
            <xsl:choose>
                <xsl:when test="starts-with($request-uri, 'page/about')">
                    <div class="hero-unit">
                        <h1>About This Repository</h1>
                        <p>To add your own content to this page, edit webapps/xmlui/themes/Mirage/lib/xsl/core/page-structure.xsl and
                            add your own content to the title, trail, and body. If you wish to add additional pages, you
                            will need to create an additional xsl:when block and match the request-uri to whatever page
                            you are adding. Currently, static pages created through altering XSL are only available
                            under the URI prefix of page/.</p>
                    </div>
                </xsl:when>
                <!-- Otherwise use default handling of body -->
                <xsl:otherwise>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>

        </div>
    </xsl:template>


    <!-- Currently the dri:meta element is not parsed directly. Instead, parts of it are referenced from inside
        other elements (like reference). The blank template below ends the execution of the meta branch -->
    <xsl:template match="dri:meta">
    </xsl:template>

    <!-- Meta's children: userMeta, pageMeta, objectMeta and repositoryMeta may or may not have templates of
        their own. This depends on the meta template implementation, which currently does not go this deep.
    <xsl:template match="dri:userMeta" />
    <xsl:template match="dri:pageMeta" />
    <xsl:template match="dri:objectMeta" />
    <xsl:template match="dri:repositoryMeta" />
    -->


  
    

    <xsl:template name="addJavascript">

        <!--TODO concat & minify!-->

        <script>
            <xsl:text>if(!window.DSpace){window.DSpace={};}window.DSpace.context_path='</xsl:text><xsl:value-of select="$context-path"/><xsl:text>';window.DSpace.theme_path='</xsl:text><xsl:value-of select="$theme-path"/><xsl:text>';</xsl:text>
        </script>

        <script src="{$theme-path}/scripts/theme.js">&#160;</script>

        <!-- Add javascipt specified in DRI -->
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][not(@qualifier)]">
            <script>
                <xsl:attribute name="src">
                    <xsl:value-of select="$theme-path"/>
                    <xsl:value-of select="."/>
                </xsl:attribute>&#160;</script>
        </xsl:for-each>

        <!-- add "shared" javascript from static, path is relative to webapp root-->
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][@qualifier='static']">
            <!--This is a dirty way of keeping the scriptaculous stuff from choice-support
            out of our theme without modifying the administrative and submission sitemaps.
            This is obviously not ideal, but adding those scripts in those sitemaps is far
            from ideal as well-->
            <xsl:choose>
                <xsl:when test="text() = 'static/js/choice-support.js'">
                    <script>
                        <xsl:attribute name="src">
                            <xsl:value-of select="$theme-path"/>
                            <xsl:text>js/choice-support.js</xsl:text>
                        </xsl:attribute>&#160;</script>
                </xsl:when>
                <xsl:when test="not(starts-with(text(), 'static/js/scriptaculous'))">
                    <script>
                        <xsl:attribute name="src">
                            <xsl:value-of
                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:attribute>&#160;</script>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

        <!-- add setup JS code if this is a choices lookup page -->
        <xsl:if test="dri:body/dri:div[@n='lookup']">
            <xsl:call-template name="choiceLookupPopUpSetup"/>
        </xsl:if>

        <!-- Add a google analytics script if the key is present -->
        <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']">
            <script><xsl:text>
                  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

                  ga('create', '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']"/><xsl:text>', '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/><xsl:text>');
                  ga('send', 'pageview');
           </xsl:text></script>
        </xsl:if>
    </xsl:template>

    <xsl:template name="languageSelection">
        <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']) &gt; 1">
            <li id="ds-language-selection" class="dropdown">
                <xsl:variable name="active-locale" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='currentLocale']"/>
                <a id="language-dropdown-toggle" href="#" role="button" class="dropdown-toggle" data-toggle="dropdown">
                    <span class="hidden-xs">
                        <xsl:value-of
                                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='supportedLocale'][@qualifier=$active-locale]"/>
                        <xsl:text>&#160;</xsl:text>
                        <b class="caret"/>
                    </span>
                </a>
                <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="language-dropdown-toggle" data-no-collapse="true">
                    <xsl:for-each
                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']">
                        <xsl:variable name="locale" select="."/>
                        <li role="presentation">
                            <xsl:if test="$locale = $active-locale">
                                <xsl:attribute name="class">
                                    <xsl:text>disabled</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$current-uri"/>
                                    <xsl:text>?locale-attribute=</xsl:text>
                                    <xsl:value-of select="$locale"/>
                                </xsl:attribute>
                                <xsl:value-of
                                        select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='supportedLocale'][@qualifier=$locale]"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
            </li>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
