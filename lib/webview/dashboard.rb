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
require_relative 'scale'
require_relative 'interval'
require_relative 'bootstrap'

#==========================================================================================
#
#==========================================================================================

class MDArray

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def self.camelcase(str, *separators)
    
    case separators.first
      
    when Symbol, TrueClass, FalseClass, NilClass
      first_letter = separators.shift
    end
    
    separators = ['_', '\s'] if separators.empty?
    
    # str = self.dup
    
    separators.each do |s|
      str = str.gsub(/(?:#{s}+)([a-z])/){ $1.upcase }
    end
    
    case first_letter
    when :upper, true
      str = str.gsub(/(\A|\s)([a-z])/){ $1 + $2.upcase }
    when :lower, false
      str = str.gsub(/(\A|\s)([A-Z])/){ $1 + $2.downcase }
    end
    
    str
    
  end
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.dashboard(width, height)
    return Dashboard.new(width, height)
  end

  #==========================================================================================
  #
  #==========================================================================================
  
  class Dashboard

    attr_reader :width
    attr_reader :height
    attr_reader :datasets
    attr_reader :charts
    attr_reader :scene

    attr_reader :data
    attr_reader :dimension_labels
    attr_reader :date_columns     # columns that have date information
    attr_reader :properties

    attr_reader :base_dimensions  # dimensions used by crossfilter

    # If a javascript script is added to demo_script, then this script will be executed
    # by the dashboard.
    attr_reader :demo_script

    #------------------------------------------------------------------------------------
    # Launches the UI and passes self so that it can add elements to it.
    #------------------------------------------------------------------------------------

    def initialize(width, height)

      @width = width
      @height = height

      # prepare a bootstrap scene specification for this dashboard
      @scene = Bootstrap.new(width)
      @datasets = Array.new
      @charts = Array.new
      @properties = Hash.new
      @base_dimensions = Hash.new

      @demo_script = false

    end
    
    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def time_format(val = nil)
      return @properties["timeFormat"] if !val
      @properties["timeFormat"] = "var timeFormat = d3.time.format(\"#{val}\");"
      return self
    end

    #------------------------------------------------------------------------------------
    # adds the data to the javascript environment
    #------------------------------------------------------------------------------------

    def add_data(data, dimension_labels, date_columns = nil)
      @data = data
      @dimension_labels = dimension_labels
      @date_columns = date_columns
    end

    #------------------------------------------------------------------------------------
    # 
    #------------------------------------------------------------------------------------

    def prepare_dimension(dim_name, dim)
      # @base_dimensions[MDArray.camelcase(dim_name.to_s)] = dim
      @base_dimensions[dim_name + "Dimension"] = dim
      return self
    end

    #------------------------------------------------------------------------------------
    # 
    #------------------------------------------------------------------------------------

    def dimension?(dim_name)
      !@base_dimension[MDArray.camelcase(dim_name.to_s)].nil?
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------
    
    def chart(type, x_column, y_column, name)
      dimension = x_column + "Dimension"
      prepare_dimension(x_column, x_column) if (@base_dimensions[dimension] == nil)
      chart = MDArray::Chart.new(type, dimension, y_column, name)
      @datasets << chart
      chart
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
    # Prepare dashboard data and properties
    #------------------------------------------------------------------------------------

    def props

      # convert the data to JSON format
      scrpt = <<EOS

      graph = new DCGraph();
      graph.convert(#{@date_columns});
      // Make variable data accessible to all charts
      var data = graph.getData();
      //$('#help').append(JSON.stringify(data));
      // add data to crossfilter and call it 'facts'.
      facts = crossfilter(data);
EOS

      @properties.each_pair do |key, value|
        scrpt << value
      end

      scrpt

    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def prepare_engine(web_engine)

      @web_engine = web_engine
      @window = @web_engine.executeScript("window")
      @document = @window.eval("document")
      @web_engine.setJavaScriptEnabled(true)

      # Intitialize variable nc_array and dimension_labels on javascript side
      @window.setMember("native_array", @data.nc_array)
      @window.setMember("labels", @dimension_labels.nc_array)

    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def run(web_engine)

      prepare_engine(web_engine)

      if (@demo_script)
        @web_engine.executeScript(scrpt + @demo_script)
        return
      end

      # scrpt will have the javascript specification
      scrpt = String.new
      # add dashboard properties
      scrpt << props
      # add bootstrap container
      scrpt << @scene.bootstrap
      # add dimensions (the x dimension)
      scrpt << dimensions_spec
      # add charts
      @datasets.each do |g|
        # add the graph specification
        scrpt << g.js_spec
      end
      # render all charts
      scrpt += "dc.renderAll();"

      # for testing purposes, print to the console the javascript
      p scrpt

      @web_engine.executeScript(scrpt)

    end
    
    #------------------------------------------------------------------------------------
    # Launches the UI and passes self so that it can add elements to it.
    #------------------------------------------------------------------------------------
    
    def plot
      if !DCFX.launched?
        DCFX.launch(self, @width, @height) 
      else
        p "already lauched"
      end
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def set_demo_script(scrpt)
      @demo_script = scrpt
    end
    
  end
  
end

require_relative 'chart'