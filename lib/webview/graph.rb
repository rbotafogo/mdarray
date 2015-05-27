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

class Graph

  attr_reader :data
  attr_reader :labels
  attr_reader :name

  attr_accessor :width
  attr_accessor :height
  attr_accessor :x
  attr_accessor :y

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def initialize(data, labels, name = nil)

    @data = data
    @labels = labels
    # @name = name + rand

    @width = 800
    @height = 400

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def plot

    DCFX.launch(@data, @labels, js_spec)

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

      graph = new DCGraph();
      // when we reach this point the data (MDArray or other) has already been sent to
      // the windows page.  Method convert will convert the java array into a javascript
      // json specification of the array.  Method convert receives an array of dimensions
      // that should be converted to a date object
      graph.convert(["Date"]);
      var data = graph.getData();
      //$('#help').append(JSON.stringify(graph.getData()));

      var timeFormat = d3.time.format("%d/%m/%Y");
      // Add an anchor for the new chart
      d3.select("body").append("div").attr("id", "line-chart")

      var hitslineChart  = dc.lineChart(reg); 
      
      ndx = crossfilter(data);
      xDim = ndx.dimension(function(d) {return d["#{@x}"];});
      y = xDim.group().reduceSum(function(d) {return d["#{@y}"];});
      //$('#help').append("#{@x}");

      // find data range
      var xMin = d3.min(data, function(d){ return Math.min(d["#{@x}"]); });
      var xMax = d3.max(data, function(d){ return Math.max(d["#{@x}"]); });

      hitslineChart
	      .width(#{@width}).height(#{@height})
	      .dimension(xDim)
        .xAxisLabel("#{@x}")
        .yAxisLabel("#{@y}")
	      .group(y)
	      .x(d3.time.scale().domain([xMin, xMax])); 
      
    };

    // build line-chart
    DCGraph.graph_function("#line-chart");

    dc.renderAll(); 

EOF
    
  end
  
end

