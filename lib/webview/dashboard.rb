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

require 'jrubyfx'

require_relative 'dcfx'

#==========================================================================================
#
#==========================================================================================

class Dashboard

  attr_reader :width
  attr_reader :height
  attr_reader :datasets
  attr_reader :graphs

  attr_reader :data
  attr_reader :dimension_labels

  #------------------------------------------------------------------------------------
  # Launches the UI and passes self so that it can add elements to it.
  #------------------------------------------------------------------------------------

  def initialize(width, height)

    @width = width
    @height = height
    @datasets = Array.new
    @graphs = Array.new

  end

  #------------------------------------------------------------------------------------
  # adds the data to the javascript environment
  #------------------------------------------------------------------------------------

  def add_data(data, dimension_labels)
    
    @data = data
    @dimension_labels = dimension_labels

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def add_graph(g)
    @datasets << g
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def run(web_engine)

    @web_engine = web_engine
    @window = @web_engine.executeScript("window")
    @document = @window.eval("document")
    @web_engine.setJavaScriptEnabled(true)

    # Intitialize variable nc_array and dimension_labels on javascript
    @window.setMember("native_array", @data.nc_array)
    @window.setMember("labels", @dimension_labels.nc_array)

    # convert the data to JSON format
    scrpt = <<EOS
      graph = new DCGraph();
      graph.convert(["Date"]);
      // Make variable data accessible to all graphs
      var data = graph.getData();
      //$('#help').append(JSON.stringify(data));
      var timeFormat = d3.time.format("%d/%m/%Y");
      facts = crossfilter(data);
EOS

    graphs_spec = String.new
    @datasets.each do |g|
      graphs_spec << "d3.select(\"body\").append(\"div\").attr(\"id\", \"#{g.spot}\")"
      graphs_spec << g.js_spec
      # graphs_spec << "DCGraph.graph_function(\"#{g.name}\");"
    end

    scrpt += graphs_spec + "dc.renderAll();"

    @web_engine.executeScript(scrpt)

  end

  #------------------------------------------------------------------------------------
  # Launches the UI and passes self so that it can add elements to it.
  #------------------------------------------------------------------------------------

  def plot
    DCFX.launch(self, @width, @height)
  end

end

require_relative 'graph'
