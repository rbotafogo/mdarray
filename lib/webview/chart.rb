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

    def initialize(type, dim, y_column, name)

      @type = type
      @dim = dim
      @jstype = Chart.chart_map[type]
      @y_column = y_column
      @name = name
      @spot = name + "Chart"
      @properties = Hash.new

      dimension(MDArray.camelcase(dim.to_s))
      
    end
    
    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def width(val = nil)
      return @properties["width"] if !val
      @properties["width"] = "width(#{val})"
      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def height(val = nil)
      return @properties["width"] if !val
      @properties["height"] = "height(#{val})"
      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def dimension(val = nil)
      return @properties["dimension"] if !val
      @properties["dimension"] = "dimension(#{val})"
      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def margins(val = nil)
      return @properties["width"] if !val
      @properties["margins"] = "margins(#{val})"
      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def transition_duration(val = nil)
      return @properties["transitionDuration"] if !val
      @properties["transitionDuration"] = "transitionDuration(#{val})"
      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def x_axis_label(val = nil)
      return @properties["xAxisLabel"] if !val
      @properties["xAxisLabel"] = "xAxisLabel(\"#{val}\")"
      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def y_axis_label(val = nil)
      return @properties["yAxisLabel"] if !val
      @properties["yAxisLabel"] = "yAxisLabel(\"#{val}\")"
      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def elastic_y(bool = nil)
      return @properties["elasticY"] if !bool
      @properties["elasticY"] = "elasticY(#{bool})"
      return self
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def elastic_x(bool = nil)
      return @properties["elasticX"] if !bool
      @properties["elasticX"] = "elasticX(#{bool})"
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
      @properties["x"] = "x(#{scale.spec})"

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

    def group(column, method)
      
      @group_name = @name.downcase + "Group"
      @group = 
        "var #{@group_name} = #{column + "Dimension"}.group().#{MDArray.camelcase(method.to_s)}(function(d) {return d[\"#{@y_column}\"];});"
      @properties["group"] = "group(#{@group_name})"
      return self

    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def props

      # start the chart specification
      str = @name
      @properties.each_pair do |key, value|
        str << "." + "#{value}"
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
