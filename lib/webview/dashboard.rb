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
    attr_reader :charts
    attr_reader :scene
    attr_reader :script           # automatically generated javascript script for this dashboard

    attr_reader :queue            # communication queue

    attr_reader :data
    attr_reader :dimension_labels
    attr_reader :date_columns     # columns that have date information
    attr_reader :properties

    attr_reader :base_dimensions  # dimensions used by crossfilter

    # If a javascript script is added to demo_script, then this script will be executed
    # by the dashboard.
    attr_reader :demo_script

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def init
      # prepare a bootstrap scene specification for this dashboard
      @scene = Bootstrap.new(width)
      @charts = Hash.new
      @properties = Hash.new
      @base_dimensions = Hash.new
      @demo_script = false
    end

    #------------------------------------------------------------------------------------
    # Launches the UI and passes self so that it can add elements to it.
    #------------------------------------------------------------------------------------

    def initialize(width, height)

      @width = width
      @height = height
      @queue = java.util.concurrent::LinkedTransferQueue.new
      # @queue = java.util.concurrent::LinkedBlockingQueue.new(1)
      init
      super()

    end
   
    #------------------------------------------------------------------------------------
    # Adds a new message to the dashboard.  This message will be consumed by the GUI
    #------------------------------------------------------------------------------------

    def add_message(message)
      @queue.add(message)
    end

    #------------------------------------------------------------------------------------
    # Method for the GUI to retrieve a message
    #------------------------------------------------------------------------------------

    def get_message
      @queue.take()
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

    def add_data(data, dimension_labels, date_columns = [])
      @data = data
      @dimension_labels = dimension_labels
      @date_columns = date_columns
      # inform the GUI to add the data, by callling method _add_data
      add_message([:_add_data, nil])
    end

    #------------------------------------------------------------------------------------
    # This method is to be called only by the GUI
    #------------------------------------------------------------------------------------

    def _add_data(window, scrpt)
      # Intitialize variable nc_array and dimension_labels on javascript side
      window.setMember("native_array", @data.nc_array)
      window.setMember("labels", @dimension_labels.nc_array)
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

    def title=(title)
      @scene.title=(title)
    end

    #------------------------------------------------------------------------------------
    # Create a new chart of the given type and name, usign x_column for the x_axis and 
    # y_column for the Y axis.  Set the default values for the chart.  Those values can
    # be changed by the user later.
    #------------------------------------------------------------------------------------
    
    def chart(type, x_column, y_column, name)

      prepare_dimension(x_column, x_column) if (@base_dimensions[x_column + "Dimension"] == nil)

      chart = MDArray::Chart.build(type, x_column, y_column, name)

      # Set chart defaults. Should preferably be read from a config file 
      chart.elastic_y(true)
      chart.x_axis_label(x_column)
      chart.y_axis_label(y_column)
      # p "type: #{type}, x_column #{x_column}, y_column #{y_column}, name #{name}"
      chart.group(:reduce_sum)

      @charts[name] = chart
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

    def run

      # scrpt will have the javascript specification
      scrpt = String.new
      # add dashboard properties
      scrpt << props

      if (@demo_script)
        add_message(@demo_script)
        return
      end

      # add bootstrap container if it wasn't specified by the user
      @scene.create_grid((keys = @charts.keys).size, keys) if !@scene.specified?
      scrpt << @scene.bootstrap
      # add dimensions (the x dimension)
      scrpt << dimensions_spec
      # add charts
      @charts.each do |name, chart|
        # add the graph specification
        scrpt << chart.js_spec if !chart.nil?
      end
      # render all charts
      scrpt += "dc.renderAll();"

      add_message([:eval, scrpt])
      
    end
    
    #------------------------------------------------------------------------------------
    # Launches the UI and passes self so that it can add elements to it.
    #------------------------------------------------------------------------------------
    
    def plot
      if !DCFX.launched?
        Thread.new { DCFX.launch(self, @width, @height) }
      else
        p "already lauched"
        run
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
