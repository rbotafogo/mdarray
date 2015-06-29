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

# Required Mixins for charts
require_relative "base_chart"
require_relative "coordinate_chart"
require_relative "margins"
require_relative "stack"

#==========================================================================================
#
#==========================================================================================

class Sol
  
  #==========================================================================================
  #
  #==========================================================================================

  class Chart
    include BaseChart

    def self.build(type, x_column, y_column, name)
      case type
      when :line_chart
        return LineChart.new(type, x_column, y_column, name)
      when :bar_chart
        return BarChart.new(type, x_column, y_column, name)
      else
        return Chart.new(type, x_column, y_column, name)
      end

    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

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

      dimension(Sol.camelcase(@dim.to_s))
      
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

require_relative "line_chart"
require_relative "bar_chart"
