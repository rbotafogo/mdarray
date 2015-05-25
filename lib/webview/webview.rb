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

  class << self
    attr_accessor :native_array
    attr_accessor :columns
  end

  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  def line_chart(web_engine)
    
    scrpt = <<EOS

      dcfx.convert();

      // Add an anchor for the new chart
      d3.select("body").append("div").attr("id", "line-chart")

      // build line-chart
      dcfx.line_chart2("#line-chart", 500, 400, -4, 4);

      dc.renderAll(); 

EOS

    web_engine.execute_script(scrpt)

  end

  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  def start(stage)

    browser = WebView.new
    web_engine = browser.getEngine()
    
    # Load configuration file
    f = Java::JavaIo.File.new("#{File.dirname(__FILE__)}/config.html")
    fil = f.toURI().toURL().toString()
    web_engine.load(fil)

    @window = web_engine.executeScript("window")
    @document = @window.eval("document")

    # Intitialize variable nc_array on javascript
    @window.setMember("native_array", Webview.native_array)
    @window.setMember("columns", Webview.columns)
    web_engine.setJavaScriptEnabled(true)

    # Add button to run the script. Later should be removed as the graph is supposed to 
    # run when the window is loaded
    script_button = build(Button, "Run script")
    script_button.set_on_action { |e| line_chart(web_engine) }

    # Add a menu bar
    menu_bar = build(MenuBar)
    menu_filters = build(Menu, "Filters")
    # add filters to the filter menu
    # add_filters
    menu_bar.get_menus.add_all(menu_filters)

    with(stage, title: "Image Viewer") do
      layout_scene(600, 600, :oldlace) do
        pane = border_pane do
          top menu_bar 
          center browser
          right script_button
        end
      end
      show
    end

  end

  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------
  
  def self.launch(array, columns = nil)

    if (array.is_a? MDArray)
      Webview.native_array = array.nc_array
      Webview.columns = columns.nc_array
    end

    super()

  end

end






=begin

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

=end
  
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

=begin
  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  def set_data(web_engine)

    data = <<EOS

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

  var data2 = [
               {"V0":1,"V1":2},
               {"V0":2,"V1":4},
               {"V0":3,"V1":9},
               {"V0":4,"V1":16}
              ];
EOS

    web_engine.execute_script(data)

  end

  def test_script(web_engine)
    
    # set_data(web_engine)

    scrpt = <<EOS

      // Add an anchor for the new chart
      d3.select("body").append("div").attr("id", "line-chart")

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

      // Display chart on the anchor added above
      dcfx.line_chart("#line-chart", 500, 400, dateDim, hits, minDate, maxDate);

      dc.renderAll(); 

EOS

end
=end
