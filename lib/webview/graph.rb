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

class Graph

  attr_reader :graph_data
  attr_reader :name
  attr_reader :spot
  attr_reader :properties

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def initialize(name)

    @name = name
    @spot = name + "Chart"
    @width = 800
    @height = 400
    @properties = Hash.new

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def width(val = nil)
    return @width if !val
    @properties["width"] = val
    @width = val
    return self
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def height(val = nil)
    return @height if !val
    @properties["height"] = val
    @height = val
    return self
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def x(val = nil)
    return @x if !val
    @properties["x"] = val
    # set the x label by default to the x column name
    x_axis_label(val) if !@properties["xAxisLabel"]
    @x = val
    return self
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def y(val = nil)
    return @y if !val
    @properties["y"] = val
    # set the y label by default to the y column name 
    y_axis_label(val) if !@properties["yAxisLabel"]

    @y = val
    return self
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def margins(val = nil)
    return @margins if !val
    @properties["margins"] = val
    @margins = val
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
    @properties["xAxisLabel"] = val
    return self
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def y_axis_label(val = nil)
    return @properties["yAxisLabel"] if !val
    @properties["yAxisLabel"] = val
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

  def props

    # define the type of graph
    props = "var #{@name} = dc.#{type}(\##{@spot});"

    # start the graph specification
    props << @name
    @properties.each_pair do |key, value|
      value = "\"#{value}\"" if value.is_a? String
      props << "." + key + "(#{value})"
    end
    props
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def spec
    props
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------


  #------------------------------------------------------------------------------------
  # Dimension should not be set by the user, this will be set by the Dashboard
  #------------------------------------------------------------------------------------

  def dimension(val)
    @properties["dimension"] = val
  end

end

#==========================================================================================
#
#==========================================================================================

class LineGraph < Graph

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def type
    "lineChart"
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def js_spec

    <<EOF

    var #{@name} = dc.lineChart(\"##{@spot}\"); 

    //var timeDimension = #{@dimension}
    var timeDimension = facts.dimension(function(d) {return d["#{@x}"];});
    y = timeDimension.group().reduceSum(function(d) {return d["#{@y}"];});

    // find data range
    var xMin = d3.min(data, function(d){ return Math.min(d["#{@x}"]); });
    var xMax = d3.max(data, function(d){ return Math.max(d["#{@x}"]); });

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
      
EOF
    
  end
  
end

=begin
    //timeDimension = facts.dimension(#{@dimension});
=end
