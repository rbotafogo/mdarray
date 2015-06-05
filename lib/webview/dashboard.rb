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
  attr_reader :base_dimensions  # dimensions used by crossfilter
  attr_reader :root_grid

  #------------------------------------------------------------------------------------
  # Launches the UI and passes self so that it can add elements to it.
  #------------------------------------------------------------------------------------

  def initialize(width, height)

    @width = width
    @height = height
    @datasets = Array.new
    @graphs = Array.new
    @base_dimensions = Hash.new
    @root_grid = MDArray.string([1])  # base grid with one row

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

  def prepare_dimension(dim_name, dim, expr = "")
    @base_dimensions[dim_name] = dim + expr
    return self
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def []=(val)
    @root_grid[0] = val
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def dimensions_spec

    dim_spec = String.new
    @base_dimensions.each_pair do |key, value|
      dim_spec << "var #{key} = facts.dimension(function(d) {return d[\"#{value}\"];});"
    end
    dim_spec

  end

  #------------------------------------------------------------------------------------
  # String MDArray is actually an Object MDArray, so, any object can be added to it
  #------------------------------------------------------------------------------------

  def new_grid(size)
    MDArray.string(size)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def add_grid(grid)
    @root_grid[0] = grid
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def bootstrap
    
    container = "container = d3.select(\"body\").append(\"div\")"
    container << ".attr(\"class\", \"container\")"
    container << ".attr(\"style\", \"font: 12px sans-serif;\")"

    val = @root_grid[0]
    if (val.is_a? String) 
      container << ".append(\"div\").attr(\"class\", \"row\")"
      container << ".append(\"div\").attr(\"col-sm-12\")"
      container << ".attr(\"id\", \"#{val}\")"
    elsif (val.is_a? StringMDArray)
      raise "Grid should have rank of at most 2" if val.get_rank > 2
      container << ";\n " << traverse(val, 12)
    end

    container

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def traverse(grid, size)

    rank = grid.get_rank
    shape = grid.get_shape

    span = size/shape[0]
    if (span < 1)
      raise "Grid specification invalid"
    end
      
    row = 0
    container = "row#{row} = container.append(\"div\").attr(\"class\", \"row\");\n "
    grid.each_with_counter do |val, counter|
      if (rank == 2 && counter[0] > row)
        row = counter[0]
        container << "row#{row} = container.append(\"div\").attr(\"class\", \"row\");\n "
      end
      if (val.is_a? String)
        container << "row#{row}.append(\"div\").attr(\"class\", \"col-sm-#{span}\")"
        container << ".attr(\"id\", \"#{val}Chart\");\n "
      elsif (val.is_a? StringMDArray)
        container = traverse(val, span)
      end
    end

    container

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
=begin
  def spec

    spec = <<EOS
      graph = new DCGraph();
      graph.convert(["Date"]);
    
      // Make variable data accessible to all graphs
      var data = graph.getData();

      //$('#help').append(JSON.stringify(data));
      var timeFormat = d3.time.format("%d/%m/%Y");

      // Add data to crossfilter
      facts = crossfilter(data);
EOS

    # spec << dimension

    @datasets.each do |g|
      # add spot
      spec << "d3.select(\"body\").append(\"div\").attr(\"id\", \"#{g.spot}\");"
      g.dimension("timeDimension")
      spec << g.spec + ";\n"
    end

    spec << "dc.renderAll();"

  end
=end
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

    # add bootstrap container
    scrpt << bootstrap

    # add graphs
    graphs_spec = String.new
    graphs_spec << dimensions_spec
    @datasets.each do |g|
      # add spot
      # graphs_spec << "d3.select(\"body\").append(\"div\").attr(\"id\", \"#{g.spot}\")"
      # add the graph specification
      graphs_spec << g.js_spec
    end

    scrpt += graphs_spec + "dc.renderAll();"

    # p scrpt

    @web_engine.executeScript(scrpt)

=begin
    output = File.open( "script.js","w" )
    output << scrpt
=end
    
  end

  #------------------------------------------------------------------------------------
  # Launches the UI and passes self so that it can add elements to it.
  #------------------------------------------------------------------------------------

  def plot
    thr = Thread.new { DCFX.launch(self, @width, @height) }
    thr.join
  end

  #------------------------------------------------------------------------------------
  # Plots two line graphs.  In order to get them to react to each other, there is the
  # need to define the same dimension twice "dateDimension" and "timeDimension"
  #------------------------------------------------------------------------------------

  def run2(web_engine)

    @web_engine = web_engine
    @window = @web_engine.executeScript("window")
    @document = @window.eval("document")
    @web_engine.setJavaScriptEnabled(true)

    # Intitialize variable nc_array and dimension_labels on javascript
    @window.setMember("native_array", @data.nc_array)
    @window.setMember("labels", @dimension_labels.nc_array)

    scrpt = <<EOS

graph = new DCGraph();
// converts the data to JSON format
graph.convert(["Date"]);

// Make variable data accessible to all graphs
var data = graph.getData();

var timeFormat = d3.time.format("%d/%m/%Y");
facts = crossfilter(data);

// Add bootstrap containers
container = d3.select("body")
  .append("div").attr("class", "container")
  .attr("style", "font: 12px sans-serif;");

row0 = container.append("div").attr("class", "row");
row0.append("div").attr("class", "col-sm-6").attr("id", "blank");
row0.append("div").attr("class", "col-sm-6").attr("id", "DateOpenChart");

row1 = container.append("div").attr("class", "row");
row1.append("div").attr("class", "col-sm-6").attr("id", "DateHighChart");
row1.append("div").attr("class", "col-sm-6").attr("id", "DateVolumeChart");

var dateDimension = facts.dimension(function(d) {return d["Date"];});
var timeDimension = facts.dimension(function(d) {return d["Date"];});

// DateOpenChart
// d3.select("body").append("div").attr("id", "DateOpenChart");
// d3.select("body").append("div").attr("id", "DateVolumeChart");

var dateopen = dc.lineChart("#DateOpenChart"); 
var datevolume = dc.lineChart("#DateVolumeChart");
var datehigh = dc.lineChart("#DateHighChart");

var dateopenGroup = dateDimension.group().reduceSum(function(d) {return d["Open"];});
var datevolumeGroup = timeDimension.group().reduceSum(function(d) {return d["Volume"];});
var datehighGroup = timeDimension.group().reduceSum(function(d) {return d["High"];});

// find data range
var xMin = d3.min(data, function(d){ return Math.min(d["Date"]); });
var xMax = d3.max(data, function(d){ return Math.max(d["Date"]); });

dateopen
  .width(400).height(200)
  .dimension(dateDimension)
  .group(dateopenGroup)
  .elasticY(true)
  .elasticX(true)
  .x(d3.time.scale().domain([xMin, xMax]));

// DateVolumeChart

datevolume
  .width(400).height(200)
  .dimension(dateDimension)
  .group(datevolumeGroup)
  .elasticY(true)
  .elasticX(true)
  .x(d3.time.scale().domain([xMin, xMax]));

datehigh
  .width(400).height(200)
  .dimension(dateDimension)
  .group(datehighGroup)
  .elasticY(true)
  .elasticX(true)
  .x(d3.time.scale().domain([xMin, xMax]));

dc.renderAll();

EOS

    @web_engine.executeScript(scrpt)

  end

end

require_relative 'graph'
