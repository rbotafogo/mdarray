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

class GraphData
  
  attr_reader :data
  attr_reader :dimension_labels

  def initialize(data, dimension_labels)
    @data = data
    @dimension_labels = dimension_labels
  end

end

#==========================================================================================
#
#==========================================================================================

class Graph

  attr_reader :graph_data
  attr_reader :name

  attr_accessor :web_engine
  attr_accessor :width
  attr_accessor :height
  attr_accessor :x
  attr_accessor :y

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def initialize(data = nil, dimension_labels = nil, name = nil)

    @graph_data = GraphData.new(data, dimension_labels) if data
    # @name = name + rand

    @width = 800
    @height = 400

  end

  def +(g)
    
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def run(web_engine)

    @web_engine = web_engine
    @window = @web_engine.executeScript("window")
    @document = @window.eval("document")
    @web_engine.setJavaScriptEnabled(true)

    add_data
    new_graph
    @web_engine.executeScript(js_spec)
    @web_engine.executeScript(view)

  end

  #------------------------------------------------------------------------------------
  # adds the data to the javascript environment
  #------------------------------------------------------------------------------------

  def add_data

    # Intitialize variable nc_array and dimension_labels on javascript
    @window.setMember("native_array", @graph_data.data.nc_array)
    @window.setMember("labels", @graph_data.dimension_labels.nc_array)

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def new_graph

    @web_engine.executeScript("graph = new DCGraph();")
    @web_engine.executeScript("graph.convert([\"Date\"]);")

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def view

<<EOS
    // build line-chart
    DCGraph.graph_function("#line-chart");

    dc.renderAll();
EOS

  end

  #------------------------------------------------------------------------------------
  # Launches the UI and passes self so that it can add elements to it.
  #------------------------------------------------------------------------------------

  def plot
    DCFX.launch(self)
  end

end

#==========================================================================================
#
#==========================================================================================

class LineGraph < Graph

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def js_spec

    <<EOF

    DCGraph.graph_function = function(reg) {

      var data = graph.getData();
      //$('#help').append(JSON.stringify(graph.getData()));

      var timeFormat = d3.time.format("%d/%m/%Y");
      // Add an anchor for the new chart
      d3.select("body").append("div").attr("id", "line-chart")

      var hitslineChart  = dc.lineChart(reg); 
      //var hitslineChart  = dc.lineChart("#line-char"); 

      facts = crossfilter(data);

      timeDimension = facts.dimension(function(d) {return d["#{@x}"];});
      y = timeDimension.group().reduceSum(function(d) {return d["#{@y}"];});
      //$('#help').append("#{@x}");

      // find data range
      var xMin = d3.min(data, function(d){ return Math.min(d["#{@x}"]); });
      var xMax = d3.max(data, function(d){ return Math.max(d["#{@x}"]); });

      hitslineChart
	      .width(#{@width}).height(#{@height})
	      .dimension(timeDimension)
        .xAxisLabel("#{@x}")
        .yAxisLabel("#{@y}")
	      .group(y)
	      .x(d3.time.scale().domain([xMin, xMax])); 
      
    };

EOF
    
  end
  
end

