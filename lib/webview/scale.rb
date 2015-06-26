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

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def self.scale(type)
    
    case type
    when :time
      scale = Sol::TimeScale.new
    when :time_utc
      scale = Sol::TimeScale.new(true)
    when :linear
      scale = Sol::LinearScale.new
    when :identity
      identity_scale(domain, range)
    when :power
      power_scale(domain, range)
    when :log
      log_scale(domain, range)
    when :quantize
      qunatize_scale(domain, range)
    when :quantile
      quantile_scale(domain, range)
    when :treshold
      treshold_scale(domain, range)
    when :ordinal
      ordinal_scale(domain, range)
    when :categorial_colors
        cat_colors_scale(domain, range)
    when :color_brewer
      color_brewer_scale(domain, range)
    end
    
    scale
    
  end
  
  #==========================================================================================
  #
  #==========================================================================================

  class Scale

    attr_reader :spec
    attr_reader :type
    attr_reader :spec

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def initialize(type)
      @type = type
      @spec = "d3.scale.#{@type}()"
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def range(values)

      scale = "["
      values.each_with_index do |value, i|
        scale << ", " if i > 0
        scale << "#{value}"
      end
      scale << "]"
      @spec << ".range(#{scale})"
      
    end

  end

  #==========================================================================================
  #
  #==========================================================================================

  class TimeScale < Scale

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def initialize(utc = nil)
      @type = "time"
      @spec = "d3.time.scale()"
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def domain(dates)
      # check to verify that dates is an array of dates.  

      # If the array has more than two elements then 'range' needs to have the same number 
      # of elements
      @elements = dates.size
      scale = "["
      dates.each_with_index do |date, i|
        scale << ", " if i > 0
        scale << "new Date(#{date*1000})"
      end
      scale << "]"
      @spec << ".domain(#{scale})"
    end

    #------------------------------------------------------------------------------------
    # val is either an interval or an integer.  If it is an integer then step is ignored
    # if given.
    #------------------------------------------------------------------------------------

    def nice(val, step = nil)
      
    end

  end

  #==========================================================================================
  #
  #==========================================================================================

  class LinearScale < Scale

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def initialize
      super("linear")
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def domain(numbers)

      # If the array has more than two elements then 'range' needs to have the same number 
      # of elements
      @elements = numbers.size

      scale = "["
      numbers.each_with_index do |num, i|
        if (!num.is_a? Numeric)
          raise "Linear domain values should all be numbers. Invalid: #{num}"
        end
        scale << ", " if i > 0
        scale << "#{num}"
      end
      scale << "]"
      @spec << ".domain(#{scale})"

    end

  end

  #==========================================================================================
  #
  #==========================================================================================

  class OrdinalScale < Scale

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def domain(values)

      # If the array has more than two elements then 'range' needs to have the same number 
      # of elements
      @elements = values.size

      scale = "["
      values.each_with_index do |value, i|
        scale << ", " if i > 0
        scale << "#{value}"
      end
      scale << "]"
      @spec << ".domain(#{scale})"

    end

  end

end
