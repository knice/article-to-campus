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

    <!-- PRE-HEADER -->
    <table border="0" cellpadding="0" cellspacing="0" width="600" summary="Links to the web version of this page and the archive of past issues.">
      <tbody>
      <tr>
        <td align="center">
          <p class="preheader">View as a web page: <a href="{$page-url}{$tracking-vars}"><xsl:value-of select="$page-url"/></a><br/>
          Find previous issues at <a href="http://news.ucsc.edu/tuesday-newsday/{$tracking-vars}"> http://news.ucsc.edu/tuesday-newsday/</a></p>
        </td>
      </tr>
      </tbody>
    </table>
    <!-- END PRE-HEADER -->

      
    

<!-- CONTENT -->

        
        <!--[if (gte mso 9)|(IE)]>
          <table width="600" align="center">
            <tr>
              <td>
        <![endif]-->
        
        <table border="0" align="center" cellpadding="0" cellspacing="0" width="600">
          <tbody>
            
            <tr>
              <td>

                <table cellpadding="0" cellspacing="0" border="0" align="left" width="600" height="95">
                  <tbody>
                    <tr>
                      <!-- Name, date and issue information -->
                      <td width="392" class="email-info">
                        <h1>
                          <span class="blue"><strong>Tuesday</strong></span> <span class="yellow">Newsday</span>
                        </h1>
                        <span class="meta">Vol. <xsl:value-of select="/system-index-block/calling-page/system-page/system-data-structure/volume"/> Issue <xsl:value-of select="/system-index-block/calling-page/system-page/system-data-structure/issue"/> - <xsl:value-of select="$display-date"/></span>
                      </td>

                      <!-- UC Santa Cruz logo -->
                      <td style="padding-left:10px;" width="208">
                        <img src="[system-asset:local]/tuesday-newsday/images/ucsc-logo-160h.png[/system-asset:local]" alt="UC Santa Cruz" width="198" height="63" align="right"/>
                      </td>

                    </tr>
                  </tbody>
                </table>

              </td>
            </tr>

            <!-- Editor's note -->
            <xsl:apply-templates select="system-data-structure/editors-note"/>

            <!-- Feature story photo -->
            <xsl:if test="system-data-structure/feature-section/banner/path != '/'">
                <xsl:apply-templates select="system-data-structure/feature-section"/>
            </xsl:if>

            <!-- Sections: keynotes, profiles, or news -->                
            <xsl:apply-templates select="system-data-structure/articles-section"/>

            <!-- Section: campus messages -->
            <xsl:apply-templates select="system-data-structure/messages-section"/>

            <!-- Section: news links -->
            <xsl:apply-templates select="system-data-structure/links-section"/>

            <!-- Section: promotional columns -->
            <xsl:apply-templates select="system-data-structure/bottom-section"/>

            <!-- Section: Footer text -->
            <xsl:apply-templates select="system-data-structure/footer-block"/>              


          </tbody>
        </table>
        
        
            <!-- Post-table text (privacy policy and terms) -->
            <xsl:apply-templates select="system-data-structure/footer-text"/>      


        <!--[if (gte mso 9)|(IE)]>
            </td>
          </tr>
        </table>
        <![endif]--> 
      

<!-- END CONTENT -->

</xsl:template>





<!-- 
    FEATURE ARTICLE
-->
<xsl:template match="feature-section">

      <xsl:variable name="feature-link">
        <xsl:choose>
          <xsl:when test="url != ''"><xsl:value-of select="url"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="page/link"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>         
   
      <xsl:variable name="feature-title">
        <xsl:choose>
          <xsl:when test="headline != ''"><xsl:value-of select="headline"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="page/title"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="feature-description">
        <xsl:choose>
          <xsl:when test="description !=''"><xsl:value-of select="description"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="page/summary"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="feature-banner">
        <xsl:choose>
          <xsl:when test="banner/link !='/'"><xsl:value-of select="banner/link"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="page/content/system-data-structure/lead-image/image/link"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="feature-banner-alt">
        <xsl:choose>
          <xsl:when test="banner-alt !=''"><xsl:value-of select="banner-alt"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="page/content/system-data-structure/lead-image/image-alt"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <tr>
        <td bgcolor="#f2f6f9">              
          <a href="{$feature-link}{$tracking-vars}">
              <img alt="{$feature-banner-alt}" src="{$feature-banner}" width="100%"/>
          </a>
        </td>
      </tr>

      <tr>
        <td class="item" bgcolor="#f2f6f9">
          <h2><a href="{$feature-link}{$tracking-vars}"><xsl:value-of select="$feature-title"/></a></h2>
          <p><xsl:value-of select="$feature-description"/></p>
        </td>
      </tr>

</xsl:template>


<!-- 
    BOTTOM COLUMNS
-->
<xsl:template match="bottom-section">

<tr bgcolor="#f2f6f9">
  <td>
    

    <table cellspacing="0" cellpadding="6" border="0">
      <tr>

        <xsl:for-each select="column">
          
          <td width="50%" valign="top" class="bottom-columns">
              
            <xsl:if test="html/node() != ''">            

              <!-- SUB-SECTION -->
              <table border="0" width="100%" cellspacing="0" cellpadding="0">
                
                <xsl:if test="header != ''">
                  <!-- SUB-SECTION HEADER -->
                  <tr>
                    <td width="100%" valign="middle" bgcolor="#f1b521" color="#ffffff" class="section-header">
                      <h2 class="gold"><xsl:value-of select="header"/></h2>
                    </td>
                  </tr>

                </xsl:if>
                
                <!-- SUB-SECTION CONTENT -->
                  <!-- Content for highlight area -->
                   <tr>
                    <td valign="top">
                      <xsl:copy-of select="html/node()"/>
                    </td>
                  </tr>

              </table>
              <!-- END SUB-SECTION -->
            
            </xsl:if>

          </td>
          
        </xsl:for-each>

      </tr>
    </table>

  </td>
</tr>

</xsl:template>



<!-- 
    EDITOR'S NOTE
-->
<xsl:template match="editors-note">

  <xsl:if test="node() != ''">
               
    <tr>
      <td>

        <table cellpadding="0" cellspacing="0" border="0" summary="Editor's note" class="editors-note">
          <tr>
            <td>
                <h2>Editor's note</h2>
            </td>
          </tr>
        
          <tr>
            <td>
              <xsl:copy-of select="node()"/>
            </td>
          </tr>
        </table>      

      </td>
    </tr>         

  </xsl:if>

</xsl:template>


  <!-- 
    SECTIONS
  -->
  <xsl:template match="system-data-structure/articles-section">
 
  <!-- Print header and link -->
  <xsl:if test="header != ''">

    <!-- Grab page title -->
    <xsl:variable name="header-text">
      <xsl:value-of select="header"/>
    </xsl:variable>

    <tr>
      <td align="left" valign="middle" bgcolor="#00458c" style="color:#fff;" class="section-header">
      <h2>
        <xsl:choose>
          <xsl:when test="header-link/link != '/'">
            <a href="{header-link/link}{$tracking-vars}"><xsl:value-of select="$header-text"/></a>
          </xsl:when>
          <xsl:when test="header-url != ''">
            <a href="{header-url}{$tracking-vars}"><xsl:value-of select="$header-text"/></a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$header-text"/>
          </xsl:otherwise>
        </xsl:choose>                  
      </h2>
      </td>
    </tr>

  </xsl:if>  

  
  <xsl:for-each select="article">

    <tr bgcolor="#f2f6f9">
      <td class="item">        

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

      <xsl:variable name="article-image">
        <xsl:choose>
          <xsl:when test="thumbnail/path !='/'"><xsl:value-of select="thumbnail/path"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="page/content/system-data-structure/lead-image/image/link"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="article-description">
        <xsl:choose>
          <xsl:when test="description !=''"><xsl:value-of select="description"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="page/summary"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <table border="0" cellpadding="0" cellspacing="0">              
        <tr>
          <td align="center" valign="top" width="30%" class="item-image">
            <a href="{$article-link}{$tracking-vars}">
                <img alt="{$article-title}" src="{$article-image}" width="250"/>
            </a>
          </td>
          <td valign="top" width="70%" class="item-copy">
            <h3 class="item-headline">
                <a href="{$article-link}{$tracking-vars}"><strong><xsl:value-of select="$article-title"/></strong></a>
            </h3>
            <p class="item-description"><xsl:value-of select="$article-description"/></p>
          </td>
        </tr>
      </table>
   
   </td>
  </tr>
  
  </xsl:for-each>

  </xsl:template>



  <!-- 
      CAMPUS MESSAGES 
  -->
  <xsl:template match="system-data-structure/messages-section">
 
  <!-- Print header and link -->
  <xsl:if test="header != ''">

    <!-- Grab page title -->
    <xsl:variable name="header-text">
      <xsl:value-of select="header"/>
    </xsl:variable>

    <tr bgcolor="#f2f6f9">
      <td align="left" valign="middle" bgcolor="#00458c" style="color:#fff;" class="section-header">
      <h2>
        <xsl:choose>
          <xsl:when test="header-link/link != '/'">
            <a href="{header-link/link}{$tracking-vars}"><xsl:value-of select="$header-text"/></a>
          </xsl:when>
          <xsl:when test="header-url != ''">
            <a href="{header-url}{$tracking-vars}"><xsl:value-of select="$header-text"/></a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$header-text"/>
          </xsl:otherwise>
        </xsl:choose>                  
      </h2>
      </td>
    </tr>

  </xsl:if>  

  <tr bgcolor="#f2f6f9">
    <td>
      <ul class="message-list">

    <xsl:for-each select="message">
             
      <xsl:variable name="message-title">
        <xsl:choose>
          <xsl:when test="headline != ''"><xsl:value-of select="headline"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="page/title"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="message-link">
        <xsl:choose>
          <xsl:when test="url != ''"><xsl:value-of select="url"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="page/link"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>    


      <li>
        <a href="{$message-link}{$tracking-vars}"><strong><xsl:value-of select="$message-title"/></strong></a>
      </li>

     
    
    </xsl:for-each>

      </ul>
     </td>
    </tr>

  </xsl:template>




  <!-- 
    NEWS LINKS SECTION
  -->
  <xsl:template match="system-data-structure/links-section">
              
  <!-- Print header and link -->
  <xsl:if test="header != ''">

    <!-- Grab page title -->
    <xsl:variable name="header-text">
      <xsl:value-of select="header"/>
    </xsl:variable>

    <tr>
      <td align="left" valign="middle" bgcolor="#00458c" style="color:#fff;" class="section-header">
      <h2>
        <xsl:choose>
          <xsl:when test="header-link/link != '/'">
            <a href="{header-link/link}{$tracking-vars}"><xsl:value-of select="$header-text"/></a>
          </xsl:when>
          <xsl:when test="header-url != ''">
            <a href="{header-url}{$tracking-vars}"><xsl:value-of select="$header-text"/></a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$header-text"/>
          </xsl:otherwise>
        </xsl:choose>                  
      </h2>
      </td>
    </tr>

  </xsl:if>   
  
    <tr bgcolor="#f2f6f9">
      <td>      
        <table border="0" cellpadding="0" cellspacing="0" summary="Links to popular news stories about UC Santa Cruz">

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
      
      <xsl:variable name="link-uuid">              
          <xsl:value-of select="translate(substring-after(block/path, '/inthenews/'),'/','-')"/>            
      </xsl:variable>          
                                     
        <tr>
          <td align="center" valign="top" width="12%">            
            <a data-link-uuid="{$link-uuid}" href="{$link-url}">
              <img align="top" alt="{$link-source}" border="0" height="60" src="{$link-thumbnail}" width="60"/>
            </a>
           </td>
          <td valign="top" width="88%">
            <p>
                <span class="xsmall">
                    <xsl:value-of select="$link-source"/> - <xsl:value-of select="$link-date"/>
                </span><br/>
                <a data-link-uuid="{$link-uuid}" href="{$link-url}"><strong><xsl:value-of select="$link-title"/></strong></a>
            </p>
          </td>
        </tr>
      
    </xsl:for-each>

    </table>
  </td>
</tr>

</xsl:template>



<!--
    FOOTER ROW BLOCK
-->
<xsl:template match="footer-block">

  <xsl:if test="path !='/'">
    <tr bgcolor="#01458c">
      <td>   
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