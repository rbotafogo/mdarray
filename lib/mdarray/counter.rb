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

#=========================================================================================
#
#=========================================================================================

class MDArray
  java_import 'java.lang.ClassCastException'

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------
  
  def get_index
    MDArray::Counter.new(self)
  end
  
  #---------------------------------------------------------------------------------------
  # Counters for Multidimensional arrays. A Counter refers to a particular element of an 
  # array. This is a generalization of index as int[].
  #---------------------------------------------------------------------------------------

  class Counter
    include Enumerable

    attr_reader :mdarray
    attr_reader :nc_index
    attr_reader :shape
    attr_reader :start
    attr_reader :finish
    attr_reader :counter

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def initialize(mdarray)

      @mdarray = mdarray
      @nc_index = mdarray.nc_array.getIndex()
      @shape = @nc_index.getShape().to_a

      # by default the starting index is the [0] index (first element)
      shape = @shape.dup
      set_start(shape.fill(0))
      # by default the finish index is the last element of the array
      finish = Array.new
      @shape.each do |val|
        finish << val - 1
      end

      set_finish(finish)

    end
    
    #-------------------------------------------------------------------------------------
    # Sets the starting position of the index
    #-------------------------------------------------------------------------------------
    
    def set_start(start)

      start = reshape(start)
      if (start[0])
        raise "Cannot set index starting position to an array section"
      else
        @start = start[1].reverse
        reset_counter
      end

    end
    
    #-------------------------------------------------------------------------------------
    # Sets the finishing position of the index
    #-------------------------------------------------------------------------------------
    
    def set_finish(finish)

      finish = reshape(finish)
      if (finish[0])
        raise "Cannot set index finish position to an array section"
      else
        @finish = finish[1].reverse
      end

    end
    
    #-------------------------------------------------------------------------------------
    # Accessor methods for start, finish and position.  
    #-------------------------------------------------------------------------------------

    def start
      @start.reverse
    end

    def finish
      @finish.reverse
    end

    def counter
      @counter.reverse
    end

    #------------------------------------------------------------------------------------
    # Reset the counter to the defined start value
    #------------------------------------------------------------------------------------

    def reset_counter
      @counter = @start.dup
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    def each

      reset_counter
      begin
        yield self.counter if block_given?
      end while(get_next_counter)

    end

    #-------------------------------------------------------------------------------------
    # Walks the counter along each of the axes.  For instance if given axes [0, 2] and
    # the array shape is [4, 3, 2], then the counter will be [0, 0, 0], [0, 0, 1],
    # [1, 0, 1], [1, 0, 1], [2, 0, 0], ... [3, 0, 1]
    #-------------------------------------------------------------------------------------

    def each_along_axes(axes)

      reset_counter
      @axes = axes

      axis = [0, self.counter.size - 2]
      begin
        yield self.counter, axis[1] if block_given?
      end while (axis = walk_along_axes)
      
    end

    #------------------------------------------------------------------------------------
    # Gets the element at the given counter.  If counter is not basic, try to fix it to
    # its basic form.
    #------------------------------------------------------------------------------------
    
    def [](*counter)
      set_counter(counter)
      get_at_counter
    end

    #------------------------------------------------------------------------------------
    # Gets the element at the given counter.  Assumes that the counter is of the proper
    # shape.
    #------------------------------------------------------------------------------------

    def get(counter)
      set_counter_fast(counter)
      get_at_counter
    end

    #------------------------------------------------------------------------------------
    # Gets the element at the courrent counter with the given type
    #------------------------------------------------------------------------------------

    def get_as(type, count = nil)

      count ? set_counter_fast(count) : set_counter_fast(self.counter)

      begin
        case type
        when :boolean
          @mdarray.nc_array.getBoolean(@nc_index)
        when :byte
          @mdarray.nc_array.getByte(@nc_index)
        when :char
          @mdarray.nc_array.getChar(@nc_index)
        when :short
          @mdarray.nc_array.getShort(@nc_index)
        when :int
          @mdarray.nc_array.getInt(@nc_index)
        when :long
          @mdarray.nc_array.getLong(@nc_index)
        when :float 
          @mdarray.nc_array.getFloat(@nc_index)
        when :double
          @mdarray.nc_array.getDouble(@nc_index)
        when :string
          @mdarray.nc_array.getObject(@nc_index).to_s
        else 
          @mdarray.nc_array.getObject(@nc_index)
        end
      rescue Java::UcarMa2::ForbiddenConversionException
        raise "cannot convert to type #{type}"
      end

    end

    #---------------------------------------------------------------------------------------
    #
    #---------------------------------------------------------------------------------------

    def get_scalar
      @mdarray.nc_array.get
    end

    #------------------------------------------------------------------------------------
    # Gets the element at the given counter.  Assumes that the counter is of the proper
    # shape. Also, counter should be an int java array
    #------------------------------------------------------------------------------------

    def jget(counter)
      jset_counter_fast(counter)
      get_at_counter
    end

    #------------------------------------------------------------------------------------
    # Gets element at current counter.  Can be done fast, as counter is always of the 
    # proper shape.
    #------------------------------------------------------------------------------------
    
    def get_current
      set_counter_fast(self.counter)
      get_at_counter
    end

    #------------------------------------------------------------------------------------
    # Sets the value of counter.  If counter is not basic, try to fix it to its basic
    # form.
    #------------------------------------------------------------------------------------
    
    def []= (counter, value)
      set_counter(counter)
      set_at_counter(value)
    end

    #------------------------------------------------------------------------------------
    # Sets the value of counter.  Assume that counter is on its basic form.
    #------------------------------------------------------------------------------------

    def set(counter, value)
      set_counter_fast(counter)
      set_at_counter(value)
    end

    #---------------------------------------------------------------------------------------
    #
    #---------------------------------------------------------------------------------------

    def set_scalar(value)
      @mdarray.nc_array.set(value)
    end

    #------------------------------------------------------------------------------------
    # Sets value of current counter.  Can be done fast, as the current counter is always
    # in its basic shape.
    #------------------------------------------------------------------------------------
    
    def set_current(value)
      set_counter_fast(self.counter)
      set_at_counter(value)
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    private 

    #-------------------------------------------------------------------------------------
    # Returns next counter if no overflow, otherwise returns nil
    #-------------------------------------------------------------------------------------

    def get_next_counter

      # gets the next counter
      shape = @shape.dup.reverse

      @counter.each_with_index do |val, index|

        if val < shape[index] - 1
          @counter[index] = val + 1
          return counter
        else
          @counter[index] = 0
        end

      end
      
      return nil

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    def walk_along_axes

      axes = @axes.dup.reverse

      axes.each do |axis|
        
        index = @counter.size - axis - 1
        if (@counter[index] < @shape[axis] - 1)
          @counter[index] = @counter[index] + 1
          return @counter, axis
        else
          @counter[index] = 0
        end
        
      end
      
      return nil

    end

    #-------------------------------------------------------------------------------------
    # If given index has negative values, then reshape it so that it only has positive
    # values.
    # check if it is a range: regex of the form /x/ or /x:y/ or /x:y:z/    
    #-------------------------------------------------------------------------------------
    
    def reshape(counter)

      if (counter.size != @shape.size)
        raise "Counter shape #{counter} is not compatible with iterator shape #{@shape}"
      end

      reshaped_counter = Array.new
      section = false

      counter.each_with_index do |val, ind|

        if (val.is_a? Integer)
          if (val < 0)
            new_ind = @shape[ind] + val
            if (new_ind < 0)
              raise "Counter shape #{counter} is not compatible with iterator shape #{@shape}"
            end
            reshaped_counter[ind] = new_ind
          elsif (val >= @shape[ind])
            raise "Counter shape #{counter} is not compatible with iterator shape #{@shape}"
          else
            reshaped_counter[ind] = counter[ind]
          end
          
        elsif (val.is_a? Regexp)
          section = true
        else
          raise "Invalid index format: #{val}"
        end
    
      end

      [section, reshaped_counter]
      
    end
    
    #-------------------------------------------------------------------------------------
    # Sets this index to point to the given counter.  assumes that the counter respects 
    # the shape constraints.
    #-------------------------------------------------------------------------------------

    def set_counter_fast(counter)

      begin
        @nc_index.set(counter.to_java :int)
      rescue java.lang.ArrayIndexOutOfBoundsException
        raise RangeError, "Invalid counter: #{counter}"
      end

    end

    #-------------------------------------------------------------------------------------
    # Sets this index to point to the given counter.  Assumes that the counter respects 
    # the shape constraints. Also, in this case, the counter should be an int java array.
    #-------------------------------------------------------------------------------------

    def jset_counter_fast(counter)

      begin
        @nc_index.set(counter)
      rescue java.lang.ArrayIndexOutOfBoundsException
        raise RangeError, "Invalid counter: #{counter}"
      end

    end

    #-------------------------------------------------------------------------------------
    # Sets this index to point to the given counter.  If given counter has negative values
    # then convert them to positive values, making sure that the counter respects the 
    # shape constraints. The given counter is a list of elements as (2, 3, 3) and not and
    # array.
    #-------------------------------------------------------------------------------------

    def set_counter(counter)

      counter = reshape(counter)
      set_counter_fast(counter[1])

    end
    
    #------------------------------------------------------------------------------------
    # Sets the value of the array at counter with value.  If type is given, cast the value
    # to type before assignment
    #------------------------------------------------------------------------------------
    
    def set_at_counter(value)
      
      begin

        case @type
        when "boolean" 
          @mdarray.nc_array.setBoolean(@nc_index, value)
        when "byte" 
          @mdarray.nc_array.setByte(@nc_index, value)
        when "char" 
          @mdarray.nc_array.setChar(@nc_index, value)
        when "short" 
          @mdarray.nc_array.setShort(@nc_index, value)
        when "int" 
          @mdarray.nc_array.setInt(@nc_index, value)
        when "long" 
          @mdarray.nc_array.setLong(@nc_index, value)
        when "float" 
          @mdarray.nc_array.setFloat(@nc_index, value)
        when "double" 
          @mdarray.nc_array.setDouble(@nc_index, value)
        else 
          @mdarray.nc_array.setObject(@nc_index, value)
        end
        
      rescue ClassCastException
        raise "Cannot cast element to array type"
      end
      
    end
    
    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------
    
    def get_at_counter
      
      case @type
      when "boolean" 
        @mdarray.nc_array.getBoolean(@nc_index)
      when "byte" 
        @mdarra.nc_array.getByte(@nc_index)
      when "char" 
        @mdarray.nc_array.getChar(@nc_index)
      when "double" 
        @mdarray.nc_array.getDouble(@nc_index)
      when "float" 
        @mdarray.nc_array.getFloat(@nc_index)
      when "int" 
        @mdarray.nc_array.getInt(@nc_index)
      when "long" 
        @mdarray.nc_array.getLong(@nc_index)
      when "short" 
        @mdarray.nc_array.getShort(@nc_index)
      when "unsigned" 
        @mdarray.nc_array.getUnsigned(@nc_index)
      else 
        @mdarray.nc_array.getObject(@nc_index)
      end
      
    end

    #------------------------------------------------------------------------------------
    # 
    #------------------------------------------------------------------------------------

    def set_i(dim, index)

      index = reshape(index)

      case dim
      when 0
        @nc_index.set0(index)
      when 1
        @nc_index.set1(index)
      when 2
        @nc_index.set2(index)
      when 3
        @nc_index.set3(index)
      when 4
        @nc_index.set4(index)
      when 5
        @nc_index.set5(index)
      when 6
        @nc_index.set6(index)
      else
        raise "Maximum allowed dimension is 6.  Please, use method set to set this index"
      end

    end

    #------------------------------------------------------------------------------------
    # 
    #------------------------------------------------------------------------------------

    def set_i_fast(dim, index)

      case dim
      when 0
        @nc_index.set0(index)
      when 1
        @nc_index.set1(index)
      when 2
        @nc_index.set2(index)
      when 3
        @nc_index.set3(index)
      when 4
        @nc_index.set4(index)
      when 5
        @nc_index.set5(index)
      when 6
        @nc_index.set6(index)
      else
        raise "Maximum allowed dimension is 6.  Please, use method set to set this index"
      end

    end

    #------------------------------------------------------------------------------------
    # Increment the current element by 1.
    #------------------------------------------------------------------------------------

    def incr
      @nc_index.incr()
    end

    #------------------------------------------------------------------------------------
    # Get the length of the ith dimension.
    #------------------------------------------------------------------------------------

    def get_shape(dim_i)
      @nc_index.getShape(dim_i)
    end

    #------------------------------------------------------------------------------------
    # Compute total number of elements in the array.
    #------------------------------------------------------------------------------------

    def compute_size 
      @nc_index.computeSize(@mdarray.nc_array.getShape())
    end

    #------------------------------------------------------------------------------------
    # Gets the current counter from the underlining storage. Should be the same as 
    # @counter
    #------------------------------------------------------------------------------------

    def get_current_counter
      @nc_index.getCurrentCounter().to_a
    end

    #-------------------------------------------------------------------------------------
    # Returns the current counter as a java array.  This is for performance improvement.
    # Should be used carefully so that it doesn't permeate ruby code.
    #-------------------------------------------------------------------------------------

    def jget_current_counter
      @nc_index.getCurrentCounter()
    end

  end # Counter

  
  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  class IteratorFast

    attr_reader :mdarray
    attr_reader :iterator

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    def initialize(mdarray)
      @mdarray = mdarray
      @iterator = mdarray.nc_array.getIndexIterator()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def has_next?
      @iterator.hasNext()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def next
      @iterator.next()
    end

    #------------------------------------------------------------------------------------
    # Returns the current counter as a ruby array
    #------------------------------------------------------------------------------------
    
    def get_current_counter
      @iterator.getCurrentCounter().to_a
    end

    #-------------------------------------------------------------------------------------
    # Returns the current counter as a java array.  This is for performance improvement.
    # Should be used carefully so that it doesn't permeate ruby code.
    #-------------------------------------------------------------------------------------

    def jget_current_counter
      @iterator.getCurrentCounter()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def get_current
      @iterator.getObjectCurrent()
    end

    alias :[] :get_current
    
    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------
    
    def get_next
      @iterator.getObjectNext()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------
    
    def set_current(value)
      @iterator.setObjectCurrent(value)
    end

    alias :[]= :set_current

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------
    
    def set_next(value)
      @iterator.setObjectNext(value)
    end
    
  end # IteratorFast
  
  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  class IteratorFastBoolean < IteratorFast

    def get_current
      @iterator.getBoolenaCurrent
    end

    def get_next
      @iterator.getBooleanNext
    end

    def set_current(value)
      @iterator.setBooleanCurrent(value)
    end

    def set_next(value)
      @iterator.setBooleanNext(value)
    end

  end # IteratorFastBoolean

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  class IteratorFastByte < IteratorFast

    def get_current
      @iterator.getByteCurrent
    end

    def get_next
      @iterator.getByteNext
    end

    def set_current(value)
      @iterator.setByteCurrent(value)
    end

    def set_next(value)
      @iterator.setByteNext(value)
    end

  end # IteratorFastByte

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  class IteratorFastChar < IteratorFast

    def get_current
      @iterator.getCharCurrent
    end

    def get_next
      @iterator.getCharNext
    end

    def set_current(value)
      @iterator.setCharCurrent(value)
    end

    def set_next(value)
      @iterator.setCharNext(value)
    end

  end # IteratorFastChar

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  class IteratorFastShort < IteratorFast

    def get_current
      @iterator.getShortCurrent
    end

    def get_next
      @iterator.getShortNext
    end

    def set_current(value)
      @iterator.setShortCurrent(value)
    end

    def set_next(value)
      @iterator.setShortNext(value)
    end

  end # IteratorFastShort

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  class IteratorFastInt < IteratorFast

    def get_current
      @iterator.getIntCurrent
    end

    def get_next
      @iterator.getIntNext
    end

    def set_current(value)
      @iterator.setIntCurrent(value)
    end

    def set_next(value)
      @iterator.setIntNext(value)
    end

  end # IteratorFastInt

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  class IteratorFastLong < IteratorFast

    def get_current
      @iterator.getLongCurrent
    end

    def get_next
      @iterator.getLongNext
    end

    def set_current(value)
      @iterator.setLongCurrent(value)
    end

    def set_next(value)
      @iterator.setLongNext(value)
    end

  end # IteratorFastLong

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  class IteratorFastFloat < IteratorFast

    def get_current
      @iterator.getFloatCurrent
    end

    def get_next
      @iterator.getFloatNext
    end

    def set_current(value)
      @iterator.setFloatCurrent(value)
    end

    def set_next(value)
      @iterator.setFloatNext(value)
    end

  end # IteratorFastFloat

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  class IteratorFastDouble < IteratorFast

    def get_current
      @iterator.getDoubleCurrent
    end

    def get_next
      @iterator.getDoubleNext
    end

    def set_current(value)
      @iterator.setDoubleCurrent(value)
    end

    def set_next(value)
      @iterator.setDoubleNext(value)
    end

  end # IteratorFastDouble

end
