# -*- coding: utf-8 -*-

##########################################################################################
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

#======================================================================================
#
#======================================================================================

class MDArray

  # attributes necessary for printing
  attr_writer :nan_str
  attr_writer :inf_str
  attr_writer :summary_edge_items
  attr_writer :summary_threshold
  
  attr_writer :max_line_width
  attr_writer :separator
  attr_writer :prefix
  attr_writer :formatter
  
  attr_writer :int_output_size
  attr_writer :float_output_precision
  attr_writer :float_output_suppress_small

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def printing_defaults

    @nan_str = "nan"
    @inf_str = "inf"
    @summary_edge_items = 3     # repr N leading and trailing items of each dimension
    @summary_threshold = 1000   # total items > triggers array summarization
    
    @max_line_width = 80
    @separator = " "
    @prefix = " "
    
    @int_output_size = 2
    @float_output_precision = 2
    @float_output_suppress_small = false

    case type
    when "int"
      @formatter = method(:integer_formatter)
    when "float"
      @formatter = method(:float_formatter)
    when "double"
      @formatter = method(:float_formatter)
    when "string"
      @formatter = method(:string_formatter)
    else
      @formatter = method(:default_formatter)
    end

  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def print

    case rank
    when 0
      print0d
    when 1
      print1d
    else
      printnd
    end
    Kernel.print "\n"

  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------
  
  def csv1d
    
    each_with_counter do |elmt, index|
      if (!is_zero?(index))
        Kernel.print @separator
      end
      Kernel.printf @formatter.call(elmt)
    end
    Kernel.print "\n"

  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def to_csv

    @separator = ", "

    counter = Counter.new(self)
    # find the axes and sizes 
    axes = Array.new
    sizes = Array.new
    (0..(rank - 2)).each do |val|
      axes << val
      sizes << 1
    end
    sizes << shape[rank - 1]

    counter.each_along_axes(axes) do |ct, axis|
      (0..ct.size - 2).each do |i|
        Kernel.print ct[i] 
        Kernel.print @separator
      end
      section(ct, sizes).csv1d
    end
    
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def print0d
    Kernel.print(@nc_array.get())
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------
  
  def print1d
    
    Kernel.print "["
    each_with_counter do |elmt, index|
      if (!is_zero?(index))
        Kernel.print @separator
      end
      Kernel.printf @formatter.call(elmt)
    end
    Kernel.print "]"
    
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def apply_over_axes(axes)

    counter = Counter.new(self)
    # find the axes and sizes 
    slice = Array.new(rank, 0)
    sizes = Array.new(rank, 1)
    (0..rank).each do |i|
      if (axes[i] != i)
        sizes[i] = shape[i]
      end
    end

    counter.each_along_axes(axes) do |ct, axis|
      section(ct, sizes)
    end
    
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  private

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------
  
  def integer_formatter(integer)
    # "%0#{@int_output_size}d" % integer
    integer.to_s
  end
  
  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def float_formatter(float)
    "%.#{@float_output_precision}f" % float
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def string_formatter(val)
    val.to_str
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def default_formatter(val)
    val.to_s
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def is_zero?(counter)
    
    counter.each do |i|
      if (i != 0)
        return false
      end
    end
    return true
    
  end
  
  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def printnd

    counter = Counter.new(self)
    # find the axes and sizes 
    axes = Array.new
    sizes = Array.new
    (0..(rank - 2)).each do |val|
      axes << val
      sizes << 1
    end
    sizes << shape[rank - 1]

    Kernel.print "[" * (rank - 1)
    last_axis = -1
    counter.each_along_axes(axes) do |ct, axis|
      
      if (axis == last_axis)
        Kernel.print "\n"
        Kernel.print @prefix * (axis + 1)
      elsif (axis < last_axis)
        Kernel.print "]" * (last_axis - axis) + "\n\n" 
        Kernel.print @prefix * (axis + 1)
        Kernel.print "[" * (last_axis - axis)
        axis = last_axis
      end
      
      section(ct, sizes).print1d
      last_axis = rank - 2

    end
    
    Kernel.print "]" * (rank - 1) + "\n"

  end
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def copy_print_parameters(section)

    # section printing paramters should be the same as the original MDArray
    section.nan_str = @nan_str
    section.inf_str = @inf_str
    section.summary_edge_items = @summary_edge_items
    section.summary_threshold = @summary_threshold
    section.max_line_width = @max_line_width
    section.separator = @separator
    section.prefix = @prefix
    section.int_output_size = @int_output_size
    section.float_output_precision = @float_output_precision
    section.float_output_suppress_small = @float_output_suppress_small

  end

end # MDArray

