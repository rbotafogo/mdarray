# -*- coding: utf-8 -*-

##########################################################################################
# @author Rodrigo Botafogo
#
# Copyright © 2013 Rodrigo Botafogo. All Rights Reserved. Permission to use, copy, modify, 
# and distribute this software and its documentation, without fee and without a signed 
# licensing agreement, is hereby granted, provided that the above copyright notice, this 
# paragraph and the following two paragraphs appear in all copies, modifications, and 
# distributions.
#
# IN NO EVENT SHALL RODRIGO BOTAFOGO BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF 
# THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF RODRIGO BOTAFOGO HAS BEEN ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
#
# RODRIGO BOTAFOGO SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE 
# SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED HEREUNDER IS PROVIDED "AS IS". 
# RODRIGO BOTAFOGO HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, 
# OR MODIFICATIONS.
##########################################################################################


class Graph

  def initialize(web_engine)

    p "inside Graph"
    p web_engine
    web_engine.executeScript('d3.select("body").append("p").text("New paragraph!");')

  end

end

#==========================================================================================
#
#==========================================================================================

class Webview < JRubyFX::Application
  include_package "javax.script"

  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  attr_reader :web_engine
  attr_reader :window
  attr_reader :document

  def test_script
    
<<EOS

  var data = [
              {date: "12/27/2012", http_404: 2, http_200: 190, http_302: 100},
              {date: "12/28/2012", http_404: 2, http_200: 10, http_302: 100},
              {date: "12/29/2012", http_404: 1, http_200: 300, http_302: 200},
              {date: "12/30/2012", http_404: 2, http_200: 90, http_302: 0},
              {date: "12/31/2012", http_404: 2, http_200: 90, http_302: 0},
              {date: "01/01/2013", http_404: 2, http_200: 90, http_302: 0},
              {date: "01/02/2013", http_404: 1, http_200: 10, http_302: 1},
              {date: "01/03/2013", http_404: 2, http_200: 90, http_302: 0},
              {date: "01/04/2013", http_404: 2, http_200: 90, http_302: 0},
              {date: "01/05/2013", http_404: 2, http_200: 90, http_302: 0},
              {date: "01/06/2013", http_404: 2, http_200: 200, http_302: 1},
              {date: "01/07/2013", http_404: 1, http_200: 200, http_302: 100}
              ];
       
              var ndx = crossfilter(data); 
var parseDate = d3.time.format("%m/%d/%Y").parse;
data.forEach(function(d) {
	d.date = parseDate(d.date);
	d.total= d.http_404+d.http_200+d.http_302;
});

var dateDim = ndx.dimension(function(d) {return d.date;});
var hits = dateDim.group().reduceSum(function(d) {return d.total;}); 

var minDate = dateDim.bottom(1)[0].date;
var maxDate = dateDim.top(1)[0].date;

var hitslineChart  = dc.lineChart("#chart-line-hitsperday"); 

hitslineChart
	.width(500).height(200)
	.dimension(dateDim)
	.group(hits)
	.x(d3.time.scale().domain([minDate,maxDate])); 

dc.renderAll(); 

EOS
  end

  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  def start(stage)

    browser = WebView.new
    web_engine = browser.getEngine()
    
    f = Java::JavaIo.File.new("#{File.dirname(__FILE__)}/empty_doc.html")
    fil = f.toURI().toURL().toString()
    web_engine.load(fil)

    @window = web_engine.executeScript("window")
    @document = @window.eval("document")
    web_engine.setJavaScriptEnabled(true)

    script_button = build(Button, "Run script")
    script_button.set_on_action { |e| web_engine.execute_script(test_script) }

    pane = nil
    with(stage, title: "Image Viewer") do
      layout_scene(400, 400, :oldlace) do
        pane = border_pane do
          center browser

	        # This exclamation mark means "yes, normally you would add this to the parent,
	        # however don't add it, just create a javaFX MenuBar object"
          menu_bar = menu_bar! do
            menu("File") do
              menu_item("Open") do
                set_on_action do
                  file_chooser do
                    file = show_open_dialog(stage)
                    # pane.center browser # multi_touch_image_view(file.to_uri.to_s)
                  end
                end
              end
              menu_item("Quit") do
                set_on_action do
                  # res = @web_engine.executeScript("$('#demo').html('jquery text')")
                  # elmt = @document.getElementById("demo")
                  # elmt.childNodes.item(0).nodeValue = "New text"
                end
              end
            end
          end
          top menu_bar

          right script_button

        end
      end
      show
    end
    
  end
  
end

  
=begin
    pane = build(BorderPane)

    menu_bar = build(MenuBar)

    menu_file = build(Menu, "File")
    open = build(MenuItem, "Open")

    open.set_on_action do
      file_chooser do
        file = show_open_dialog(stage)
        pane.center browser # multi_touch_image_view(file.to_uri.to_s)
      end
    end

    quit = build(MenuItem, "Quit")
    menu_file.get_items.add_all(open, quit)

    menu_edit = build(Menu, "Edit")
    menu_view = build(Menu, "View")
    menu_bar.get_menus.add_all(menu_file, menu_edit, menu_view)
=end