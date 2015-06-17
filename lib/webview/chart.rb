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

class MDArray
  
  #==========================================================================================
  #
  #==========================================================================================

  class Chart

    class << self
      attr_reader :chart_map
    end

    @chart_map = {:line_chart => "lineChart", :bar_chart => "barChart"}

    attr_reader :type
    attr_reader :dim
    attr_reader :jstype
    attr_reader :name
    attr_reader :y_column

    attr_reader :spot
    attr_reader :properties

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def initialize(type, x_column, y_column, name)

      @type = type
      @dim = x_column + "Dimension"
      @jstype = Chart.chart_map[type]
      @y_column = y_column
      @name = name
      @spot = name + "Chart"
      @properties = Hash.new

      dimension(MDArray.camelcase(@dim.to_s))
      
    end
    
    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def width(val = nil)
      return @properties["width"] if !val
      @properties["width"] = val
      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def height(val = nil)
      return @properties["width"] if !val
      @properties["height"] = val
      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def dimension(val = nil)
      return @properties["dimension"] if !val
      @properties["dimension"] = val
      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def margins(margins_hash = nil)

      return @properties["margins"] if !margins_hash

      default_margins = {top: 10, right: 50, bottom: 30, left: 30}
      margins_hash = default_margins.merge(margins_hash)

      margins = "{"
      margins_hash.each_pair do |key, m|
        margins << "#{key}: #{m}, "
      end
      margins << "}"
      margins[-3] = ""
      p margins
      @properties["margins"] = margins

      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def transition_duration(val = nil)
      return @properties["transitionDuration"] if !val
      @properties["transitionDuration"] = val
      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def x_axis_label(val = nil)
      return @properties["xAxisLabel"] if !val
      @properties["xAxisLabel"] = "\"#{val}\""
      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def y_axis_label(val = nil)
      return @properties["yAxisLabel"] if !val
      @properties["yAxisLabel"] = "\"#{val}\""
      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def elastic_y(bool = nil)
      return @properties["elasticY"] if !bool
      @properties["elasticY"] = bool
      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def elastic_x(bool = nil)
      return @properties["elasticX"] if !bool
      @properties["elasticX"] = bool
      return self
    end

    #------------------------------------------------------------------------------------
    # Defines the x scale for the chart
    #------------------------------------------------------------------------------------

    def x(type, input_domain = nil, input_range = nil)

      if (type.is_a? MDArray::Scale)
        scale = type
      else
        scale = MDArray.scale(type)
        scale.domain(input_domain) if input_domain
        scale.range(input_range) if input_range
      end
      @properties["x"] = scale.spec

      return self

    end
    
    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def grouped?
      @group != nil
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def group(method)
      
      @group_name = @name.downcase + "Group"
      @group = 
        "var #{@group_name} = #{@dim}.group().#{MDArray.camelcase(method.to_s)}(function(d) {return d[\"#{@y_column}\"];});"
      @properties["group"] = @group_name
      return self

    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def props

      # start the chart specification
      str = @name
      @properties.each_pair do |key, value|
        str << "." + "#{key}(#{value})"
      end
      str << ";"
      str

    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def header

    <<EOS
    var #{@name} = dc.#{@jstype}(\"##{@spot}\"); 
    #{@group}
EOS

    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def js_spec
      gr = header + props
      gr
    end

  end
  
end


=begin
    //timeDimension = facts.dimension(#{@dimension});
=end

=begin
    gr = header + <<EOS

    #{@name}
	    .width(#{@width}).height(#{@height})
      .margins({top: 10, right: 10, bottom: 50, left: 100})
	    .dimension(timeDimension)
      .transitionDuration(500)
      .xAxisLabel("#{@x}")
      .yAxisLabel("#{@y}")
      .elasticY(true)
	    .group(y)
	    .x(d3.time.scale().domain([xMin, xMax]))
      .xAxis().tickFormat();
      
EOS
=end
