<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8" indent="yes" />
<xsl:template match="/">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
    <html>
    <head>
        <title><xsl:value-of select="$title" /></title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <style>
        img, video {
            display: inline-flex;
            max-width: 40vw;
            max-height: 40vh;
            margin: 2mm;
            vertical-align: bottom;
            image-orientation: from-image;
            cursor: pointer;
        }
        @media all and (max-width: 20.4cm) {
            img {
                max-width: calc(100% - 4mm);
            }
        }
        body {
            margin: 0;
            display: block;
            background-color: #355e3b
        }
        .main, .nav {
            display: flex;
            flex-flow: wrap;
            justify-content: space-evenly;
        }
        .nav {
            justify-content: space-around;
            font-size: 2em;
            color: #eee8aa;
            margin: 2em;
        }
        .back, .forward {
            cursor: pointer
        }
        .breadcrumb {
            color: #eee8aa;
            font-size: 1.25em;
            margin: 5px;
        }
        .breadcrumb_item {
            cursor: pointer;
        }
        </style>
    </head>
    <body>
        <div class="breadcrumb"></div>
        <div class="nav">
            <span class="back" onClick="move_dir(-1)">&lt;&lt; PREVIOUS</span>
            <span class="page" onClick="select_page()">Current Page</span>
            <span class="forward" onClick="move_dir(1)">NEXT &gt;&gt;</span>
        </div>
	<div class="main">
        </div>
        <div class="nav">
            <span class="back" onClick="move_dir(-1)">&lt;&lt; PREVIOUS</span>
            <span class="page" onClick="select_page()">Current Page</span>
            <span class="forward" onClick="move_dir(1)">NEXT &gt;&gt;</span>
        </div>

	<script type="text/javascript">
	    let urls = []
            let page = 1
	    let start = function () {
	        <xsl:for-each select="list/file">
                    <xsl:choose>
                        <xsl:when test="contains(' mp4 webm mkv avi wmv flv ogv ', concat(' ', substring-after(., '.'), ' '))">
                            urls.push('<video controls="" src="{.}" alt="{.}" title="{.}"/>')
                        </xsl:when>
                        <xsl:otherwise>
                            urls.push(`<img onclick="window.open('{.}', '_blank')" src="{.}" alt="{.}" title="{.}"/>`)
                        </xsl:otherwise>
                    </xsl:choose>
	        </xsl:for-each>

                breadcrumb()
		document.querySelectorAll(".page").forEach(f => f.innerHTML = "PAGE 1/" + Math.ceil(urls.length/9))
		move()
	    }
            
	    let move = function() {
		if (page &lt; 1) { page = 1 }
                if (page > Math.ceil(urls.length/9)) { page = Math.ceil(urls.length/9) }
                document.querySelectorAll(".page").forEach(f => f.innerHTML = "PAGE " + page + "/" + Math.ceil(urls.length/9))
                document.querySelector(".main").innerHTML = urls.slice((page-1)*9, page*9).join("")
	    }

            let move_dir = function(dir) {
              page += dir;
              move()
            }

            let name_fix = function(name) {
              let ret_val = name.split("_")
              ret_val = ret_val.map(f => { return f.charAt(0).toUpperCase() + f.slice(1); })
              return ret_val.join(" ")
            }

            let breadcrumb = function(){
              let page_path = window.location.pathname.replace(/^\/|\/$/g, "").split("/")
              let runner = "/"
              let template = ` >> <span class='breadcrumb_item' onClick="window.location.pathname='~~~~'">`
              let bc_html = `<span class='breadcrumb_item' onClick='window.location.pathname = \"/\"'>Home</span>`
	      page_path.forEach(function(f) { runner += f + "/"; bc_html += template.replace(/~~~~/, runner) + name_fix(f) + "</span>" });
              document.querySelector(".breadcrumb").innerHTML = bc_html
            }

            let select_page = function() {
              let page_pick = prompt("Select a page to jump to.", page)
              let page_pick_int = parseInt(page_pick)
              if (page_pick_int || page_pick_int === 0) { 
                page = page_pick_int
                move()
              }
            }

            document.addEventListener('DOMContentLoaded', start, false);
	</script>
    </body>
    </html>
</xsl:template>
</xsl:stylesheet>
