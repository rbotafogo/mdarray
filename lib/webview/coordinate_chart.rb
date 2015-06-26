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

class Sol
  
  #==========================================================================================
  #
  #==========================================================================================

  module CoordinateChart

    #------------------------------------------------------------------------------------
    # Turn on/off the brush-based range filter. When brushing is on then user can drag the 
    # mouse across a chart with a quantitative scale to perform range filtering based on the 
    # extent of the brush, or click on the bars of an ordinal bar chart or slices of a pie 
    # chart to filter and unfilter them. However turning on the brush filter will disable 
    # other interactive elements on the chart such as highlighting, tool tips, and reference 
    # lines. Zooming will still be possible if enabled, but only via scrolling (panning will 
    # be disabled.) Default: true
    #------------------------------------------------------------------------------------

    def brush_on(bool = nil)
      return @properties["brushOn"] if bool == nil
      @properties["brushOn"] = bool
      return self
    end

    #------------------------------------------------------------------------------------
    # Get or set the padding in pixels for the clip path. Once set padding will be applied 
    # evenly to the top, left, right, and bottom when the clip path is generated. If set to 
    # zero, the clip area will be exactly the chart body area minus the margins. Default: 5
    #------------------------------------------------------------------------------------

    def clip_padding(val = nil)
      return @properties["clipPadding"] if !val
      @properties["clipPadding"] = val
      return self
    end

    #------------------------------------------------------------------------------------
    # Get or set the elasticity on x axis. If this attribute is set to true, then the x 
    # axis will rescle to auto-fit the data range when filtered.
    #------------------------------------------------------------------------------------

    def elastic_x(bool = nil)
      return @properties["elasticX"] if bool == nil
      @properties["elasticX"] = bool
      return self
    end

    #------------------------------------------------------------------------------------
    # Turn on/off elastic y axis behavior. If y axis elasticity is turned on, then the 
    # grid chart will attempt to recalculate the y axis range whenever a redraw event is 
    # triggered.
    #------------------------------------------------------------------------------------
    
    def elastic_y(bool = nil)
      return @properties["elasticY"] if bool == nil
      @properties["elasticY"] = bool
      return self
    end

    #------------------------------------------------------------------------------------
    # Defines the x scale for the chart
    #------------------------------------------------------------------------------------

    def x(type, input_domain = nil, input_range = nil)

      if (type.is_a? Sol::Scale)
        scale = type
      else
        scale = Sol.scale(type)
        scale.domain(input_domain) if input_domain
        scale.range(input_range) if input_range
      end
      @properties["x"] = scale.spec

      return self

    end

    #------------------------------------------------------------------------------------
    # Set or get the x axis label. If setting the label, you may optionally include additional 
    # padding to the margin to make room for the label. By default the padded is set to 12 
    # to accomodate the text height.
    #------------------------------------------------------------------------------------

    def x_axis_label(val = nil, padding = 12)
      return @properties["xAxisLabel"] if !val
      @properties["xAxisLabel"] = "\"#{val}\""
      return self
    end

    #------------------------------------------------------------------------------------
    # Set or get the y axis label. If setting the label, you may optionally include additional 
    # padding to the margin to make room for the label. By default the padded is set to 12 to 
    # accomodate the text height.
    #------------------------------------------------------------------------------------

    def y_axis_label(val = nil, padding = 12)
      return @properties["yAxisLabel"] if !val
      @properties["yAxisLabel"] = "\"#{val}\""
      return self
    end

  end

end
