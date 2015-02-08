<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output indent="yes" method="xml"/> 
    <xsl:include href="/formats/Format Date"/>
    
    <xsl:template match="/system-index-block">
        <xsl:apply-templates select="calling-page/system-page"/>
    </xsl:template>
    
    <!-- 
        VARIABLES
    -->
    <xsl:variable name="siteURL"><xsl:text>http://news.ucsc.edu</xsl:text></xsl:variable>
    <xsl:variable name="page-url"><xsl:value-of select="$siteURL"/><xsl:value-of select="/system-index-block/calling-page/system-page/path"/>.html</xsl:variable>
    
    <xsl:variable name="issue-date">
      <xsl:call-template name="format-date">
      <xsl:with-param name="date" select="/system-index-block/calling-page/system-page/system-data-structure/issue-datetime"/>
      <xsl:with-param name="mask">mm-dd-yyyy</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="display-date">
      <xsl:call-template name="format-date">
      <xsl:with-param name="date" select="/system-index-block/calling-page/system-page/system-data-structure/issue-datetime"/>
      <xsl:with-param name="mask">mmmm dd, yyyy</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>    
    
    <xsl:variable name="tracking-vars"><xsl:text>?utm_source=</xsl:text><xsl:value-of select="$issue-date"/><xsl:text>&amp;utm_medium=email&amp;utm_campaign=tuesday-newsday</xsl:text></xsl:variable>

    <!-- 
      Demo: Make trackable links template
      @param:   $url-to-track
      @logic:   Takes a given url and adds GA campaign code to the end.
     -->
    <xsl:template name="make-trackable">
      <xsl:param name="url-to-track"/>
      <xsl:if test="contains($url-to-track, '?')">
        <xsl:variable name="url-separator">&amp;</xsl:variable>
      </xsl:if>
      <xsl:variable name="url-separator">?</xsl:variable>
      <xsl:value-of select="$url-to-track"/><xsl:value-of select="$url-separator"/><xsl:value-of select="$tracking-vars"/>
    </xsl:template>
    

    <!-- 
        LAYOUT
    -->
    <xsl:template match="system-page">

    <!-- HEADER -->
    <table border="0" cellpadding="0" cellspacing="0" width="600">
      <tbody>
      <tr>
        <td align="center">
          <p class="url-link">View as a web page: <a href="{$page-url}{$tracking-vars}"><xsl:value-of select="$page-url"/></a><br/>
          You can always find back issues at <a href="http://news.ucsc.edu/tuesday-newsday/{$tracking-vars}"> http://news.ucsc.edu/tuesday-newsday/</a></p>
        </td>
      </tr>
      </tbody>
    </table>
      
    <table border="0" cellpadding="0" cellspacing="0" id="main" width="600">

      <!-- Email banner image -->
      <tr>
        <td colspan="2">
          <xsl:apply-templates select="system-data-structure/banner"/>    
        </td>
      </tr>
      
      <!-- Main content row -->
      <tr>
      
          <!-- Left column -->
          <td valign="top" width="375">
            <table border="0" cellpadding="0" cellspacing="0" id="issue-header">
              <tbody>
                <tr>
                  <td class="small" width="50%">VOL. <xsl:value-of select="/system-index-block/calling-page/system-page/system-data-structure/volume"/> &#160;&#160; ISSUE <xsl:value-of select="/system-index-block/calling-page/system-page/system-data-structure/issue"/></td>
                  <td align="right" class="small" width="50%"><xsl:value-of select="$display-date"/></td>
                </tr>
              </tbody>
            </table>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <tbody>
                <xsl:apply-templates select="system-data-structure/editors-note"/>
                <xsl:apply-templates select="system-data-structure/articles-section"/>
                <xsl:apply-templates select="system-data-structure/links-section"/>            
              </tbody>
            </table>
          </td>

        <!-- Right column -->
        <td class="gray" valign="top" width="225">
          
          <table border="0" cellpadding="0" cellspacing="0" id="issue-header">
            <tbody>
              <tr>
                <td class="small">
                  <a href="{$siteURL}{$tracking-vars}">news.ucsc.edu</a>
                </td>
              </tr>
            </tbody>
          </table>

          <xsl:apply-templates select="system-data-structure/sidebar-section"/>

        </td>

      </tr>

      <!-- Footer row -->
      <xsl:apply-templates select="system-data-structure/footer-block"/>      

    </table>

    <!-- POST FOOTER -->
    <xsl:apply-templates select="system-data-structure/footer-text"/>
      
    </xsl:template>


    <!-- 
        BANNER
    -->
    <xsl:template match="banner">

      <xsl:if test="path != '/'">
        
          <a href="{/system-index-block/calling-page/system-page/link}{$tracking-vars}">
              <img alt="Tuesday Newsday" border="0" height="226" src="{link}" width="600"/>
          </a>

      </xsl:if>

    </xsl:template>


    
    <!-- 
        EDITOR'S NOTE
    -->
    <xsl:template match="editors-note">

      <xsl:if test="node() != ''">
                
        <!-- Content for editor's note -->
         <tr>
          <td colspan="2">
            <table border="0" cellpadding="0" cellspacing="0" class="email-editors-note" id="content" width="97%"> 
              <!-- Editor's note header -->
              <tr>
                <td colspan="2" id="last">
                    <h2>Editor's note</h2>
                </td>
              </tr>
              <tr>
                <td id="last">
                  <xsl:copy-of select="node()"/>
                </td>
              </tr>
            </table>
          </td>
        </tr>

      </xsl:if>

    </xsl:template>


    <!-- 
        SECTION HEADER
    -->
    <xsl:template match="header">

      <xsl:if test="node() != ''">
          
      <tr>
        <td bgcolor="#FDC83B" width="32%">&#160;</td>
        <td bgcolor="#FDC83B" width="68%">
            <h2>
                <a href="http://news.ucsc.edu/{$tracking-vars}"><xsl:value-of select="node()"/></a>
            </h2>
        </td>
      </tr>

      </xsl:if>  

    </xsl:template>


      <!-- 
          ARTICLES SECTION
      -->
      <xsl:template match="system-data-structure/articles-section">

      <!-- Print header and link -->
      <xsl:if test="header != ''">

        <!-- Grab page title -->
        <xsl:variable name="text-header">
          <xsl:value-of select="header"/>
        </xsl:variable>

        <tr>
          <td bgcolor="#FDC83B" width="32%">&#160;</td>
          <td bgcolor="#FDC83B" width="68%">
          <h2>                  
            <xsl:choose>
              <xsl:when test="header-link/link != '/'">
                <a href="{header-link/link}{$tracking-vars}"><xsl:value-of select="$text-header"/></a>
              </xsl:when>
              <xsl:when test="header-url != ''">
                <a href="{header-url}{$tracking-vars}"><xsl:value-of select="$text-header"/></a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$text-header"/>
              </xsl:otherwise>
            </xsl:choose>                  
          </h2>
          </td>
        </tr>
      </xsl:if>  

        <tr>
          <td colspan="2">
            <table border="0" cellpadding="0" cellspacing="0" id="content" width="97%">              

        <xsl:for-each select="article">

          <xsl:variable name="article-title">
            <xsl:choose>
              <xsl:when test="headline != ''"><xsl:value-of select="headline"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="page/title"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="article-link">
            <xsl:choose>
              <xsl:when test="url != ''"><xsl:value-of select="url"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="page/link"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>    

          <xsl:variable name="share-link">
            <xsl:choose>
              <xsl:when test="url != ''"><xsl:value-of select="url"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="concat($siteURL, page/path, '.html')"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>                    

          <xsl:variable name="article-thumbnail">
            <xsl:choose>
              <xsl:when test="thumbnail/path !='/'"><xsl:value-of select="thumbnail/path"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="page/content/system-data-structure/lead-image/image-thumb/link"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="article-description">
            <xsl:choose>
              <xsl:when test="description !=''"><xsl:value-of select="description"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="page/summary"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

            <tr>
              <td align="center" valign="top" width="30%">
                  <xsl:if test="position() = last()">
                    <xsl:attribute name="id">last</xsl:attribute>
                  </xsl:if>
                  <a href="{$article-link}{$tracking-vars}">
                      <img alt="{$article-title}" border="0" height="80" src="{$article-thumbnail}" width="80"/>
                  </a>
              </td>
              <td valign="top" width="70%">
                  <xsl:if test="position() = last()">
                    <xsl:attribute name="id">last</xsl:attribute>
                  </xsl:if>
                  <p>
                      <a href="{$article-link}{$tracking-vars}"><strong><xsl:value-of select="$article-title"/></strong></a>
                  </p>
                  <p><xsl:value-of select="$article-description"/></p>
              </td>
            </tr>
        
        </xsl:for-each>

        </table>
       </td>
      </tr>

      </xsl:template>



      <!-- 
          LINKS SECTION
      -->
      <xsl:template match="system-data-structure/links-section">

      <!-- Print header and link -->
      <xsl:if test="header != ''">

        <!-- Grab page title -->
        <xsl:variable name="text-header">
          <xsl:value-of select="header"/>
        </xsl:variable>

        <tr>
          <td bgcolor="#FDC83B" width="32%">&#160;</td>
          <td bgcolor="#FDC83B" width="68%">
          <h2>                  
            <xsl:choose>
              <xsl:when test="header-link/link != '/'">
                <a href="{header-link/link}{$tracking-vars}"><xsl:value-of select="$text-header"/></a>
              </xsl:when>
              <xsl:when test="header-url != ''">
                <a href="{header-url}{$tracking-vars}"><xsl:value-of select="$text-header"/></a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$text-header"/>
              </xsl:otherwise>
            </xsl:choose>                  
          </h2>
          </td>
        </tr>
      </xsl:if>  
      
        <tr>
          <td colspan="2">      
            <table border="0" cellpadding="0" cellspacing="0" id="content" width="97%">

        <!-- If there are articles -->
        <xsl:for-each select="link">

          <xsl:variable name="link-date">
            <xsl:call-template name="format-date">
              <xsl:with-param name="date" select="block/content/system-data-structure/publish-date"/>
              <xsl:with-param name="mask">mmmm dd, yyyy</xsl:with-param>
            </xsl:call-template>
          </xsl:variable>    

          <xsl:variable name="link-source">
            <xsl:choose>
              <xsl:when test="source !=''"><xsl:value-of select="source"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="block/content/system-data-structure/source"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="link-title">
            <xsl:choose>
              <xsl:when test="headline != ''"><xsl:value-of select="headline"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="block/content/system-data-structure/headline"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="link-url">
            <xsl:choose>
              <xsl:when test="url != ''"><xsl:value-of select="url"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="block/content/system-data-structure/url"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>          

          <xsl:variable name="link-thumbnail">
            <xsl:choose>
              <xsl:when test="thumbnail/path !='/'"><xsl:value-of select="thumbnail/path"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="block/content/system-data-structure/thumbnail/link"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
                                         
            <tr>
              <td align="center" valign="top" width="30%">
                  <xsl:if test="position() = last()">
                    <xsl:attribute name="id">last</xsl:attribute>
                  </xsl:if>                
                  <a href="{$link-url}">
                    <img align="top" alt="{$link-source}" border="0" height="60" src="{$link-thumbnail}" width="60"/>
                  </a>
               </td>
              <td valign="top" width="70%">
                  <xsl:if test="position() = last()">
                    <xsl:attribute name="id">last</xsl:attribute>
                  </xsl:if>                
                  <p>
                      <span class="xsmall">
                          <xsl:value-of select="$link-source"/> - <xsl:value-of select="$link-date"/>
                      </span><br/>
                      <a href="{$link-url}"><strong><xsl:value-of select="$link-title"/></strong></a>
                  </p>
              </td>
            </tr>
          
        </xsl:for-each>

        </table>
      </td>
    </tr>

    </xsl:template>


    <!--
        SIDEBAR SECTION
    -->
    <xsl:template match="system-data-structure/sidebar-section">

      <table border="0" cellpadding="0" cellspacing="0" id="right" width="90%">

        <xsl:for-each select="item">

        <!-- Print header and link -->
        <xsl:if test="header != ''">

          <!-- Grab page title -->
          <xsl:variable name="text-header">
            <xsl:value-of select="header"/>
          </xsl:variable>

          <tr>
            <td class="border-bottom" valign="top">
            <h2>                  
              <xsl:choose>
                <xsl:when test="header-link/link != '/'">
                  <a href="{header-link/link}{$tracking-vars}"><xsl:value-of select="$text-header"/></a>
                </xsl:when>
                <xsl:when test="header-url != ''">
                  <a href="{header-url}"><xsl:value-of select="$text-header"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$text-header"/>
                </xsl:otherwise>
              </xsl:choose>                  
            </h2>
            </td>
          </tr>
        </xsl:if> 
        
        <tr class="sidebar-content">
          <td valign="top">

            <!-- Image header: links to header link if present -->
            <xsl:if test="image/path != '/'">
              <xsl:choose>
                <xsl:when test="header-link/link != '/'">
                  <a href="{header-link/link}{$tracking-vars}">
                    <img alt="{image/name}" src="{image/link}"/>
                  </a>
                </xsl:when>
                <xsl:when test="header-url != ''">
                  <a href="{header-url}">
                    <img alt="{image/name}" src="{image/link}"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <img alt="{image/name}" src="{image/link}"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>

            <xsl:for-each select="article-links">
              <xsl:if test="page/path !='/' or url != ''">
                
                <xsl:variable name="headline-text">
                <xsl:choose>
                    <xsl:when test="headline != ''">
                      <xsl:value-of select="headline"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="page/title"/>
                    </xsl:otherwise>
                </xsl:choose>
                </xsl:variable>

                <xsl:variable name="url-text">
                <xsl:choose>
                    <xsl:when test="url != ''">
                      <xsl:value-of select="url"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="concat(page/link, $tracking-vars)"/>
                    </xsl:otherwise>
                </xsl:choose>
                </xsl:variable>                
                
              <p>
                <strong>
                  <a href="{$url-text}"><xsl:value-of select="$headline-text"/></a>
                </strong>
              </p>
            
              </xsl:if>
            
            </xsl:for-each>

            <xsl:if test="html/node() !=''">
            <div>
              <xsl:copy-of select="html/node()"/>
            </div>
            </xsl:if>
          </td>
        </tr>          

        </xsl:for-each>

      </table>  

    </xsl:template>


    <!--
        FOOTER ROW BLOCK
    -->
    <xsl:template match="footer-block">

      <xsl:if test="path !='/'">
      <tr>
        <td bgcolor="#01458c" colspan="2">
       
          <xsl:copy-of select="content/system-data-structure/content/node()"/>

        </td>
      </tr>
      </xsl:if>

    </xsl:template>


    <!--
        FOOTER ROW BLOCK
    -->
    <xsl:template match="footer-text">

      <xsl:if test="node() !=''">

        <table border="0" cellpadding="0" cellspacing="0" width="600">
          <tbody>
          <tr>
            <td align="center">
              <p class="url-link">
                <xsl:copy-of select="node()"/>
              </p>
            </td>
          </tr>
          </tbody>
        </table>

      </xsl:if>

    </xsl:template>


</xsl:stylesheet>