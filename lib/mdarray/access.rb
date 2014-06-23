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

class MDArray

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def get_current_index
    @local_iterator.get_current_index
  end

  #------------------------------------------------------------------------------------
  # Returns the next element of the local_iterator or nil if no next element available
  #------------------------------------------------------------------------------------

  def next

    if (@local_iterator && @local_iterator.has_next?)
      @local_iterator.get_next
    else
      nil
    end

  end

  #------------------------------------------------------------------------------------
  # When get is used to retrieve an element, it is assumed that the index does not need
  # correction, for instance, no negative index is allowed.  If one wants to use 
  # negative indexes, then method [] should be used.  So mat.get([-1, 0, 0]) raises an
  # exception while mat[-1, 0, 0] gets the last value for the first dimension.
  #------------------------------------------------------------------------------------

  def [](*index)

    if (index.size != 0)
      @local_index[*index]
    elsif (@local_iterator)
      @local_iterator.get_current
    else
      raise "No iterator defined! Cannot get element"
    end

  end

  #------------------------------------------------------------------------------------
  # When get is used to retrieve an element, it is assumed that the index does not need
  # correction, for instance, no negative index is allowed.  If one wants to use 
  # negative indexes, then method [] should be used.  So mat.get([-1, 0, 0]) raises an
  # exception while mat[-1, 0, 0] gets the last value for the first dimension.
  #------------------------------------------------------------------------------------

  def get(index = nil)
    @local_index.get(index)
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def get_as(type, counter = nil)
    @local_index.get_as(type, counter)
  end

  #---------------------------------------------------------------------------------------
  # Sets a value for a scalar D0 array
  #---------------------------------------------------------------------------------------

  def get_scalar
    @local_index.get_scalar
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def jget(index = nil)
    @local_index.jget(index)
  end

  #------------------------------------------------------------------------------------
  # Gets the next element of the local iterator
  #------------------------------------------------------------------------------------

  def get_next

    if (@local_iterator)
      @local_iterator.get_next
    else
      raise "No iterator defined! Cannot get next element"
    end

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def []=(*index, value)

    if (index.size != 0)
      @local_index[index] = value
    elsif (@local_iterator)
      @local_iterator.set_current(value)
    else
      raise "No iterator defined! Cannot set element value"
    end

  end

  #---------------------------------------------------------------------------------------
  # When set is used to assign to an element, it is assumed that the index does not need
  # correction, for instance, no negative index is allowed.  If one wants to use 
  # negative indexes, then method [] should be used.  So mat.set([-1, 0, 0], 10), raises 
  # an exection while mat[-1, 0, 0] = 10 sets the last value for the first dimension.
  # *<tt>index</tt>: array with the index position
  # *<tt>value</tt>: value to be set
  #---------------------------------------------------------------------------------------

  def set(index, value)
    @local_index.set(index, value)
  end

  #---------------------------------------------------------------------------------------
  # Sets a value for a scalar D0 array
  #---------------------------------------------------------------------------------------

  def set_scalar(value)
    @local_index.set_scalar(value)
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def set_next(value)

    if (@local_iterator)
      @local_iterator.set_next(value)
    else
      raise "No iterator defined! Cannot set element value"
    end
    
  end
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def get_counter
    Counter.new(self)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def reset_traversal
    @local_iterator = get_iterator_fast
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def each
    
    iterator = get_iterator_fast
    while (iterator.has_next?)
      yield iterator.get_next if block_given?
    end
    
  end

  # (1) Each creates a new iterator and does not touch the @local_iterator so that
  # one should be able to call each from different threads.  Still, should be careful
  # if another thread adds or removes elements from the array.  Needs to check what 
  # happens in this situation

  #------------------------------------------------------------------------------------
  # Cycles through the whole list of elements yielding to a block (if given) the next
  # element and its index.  The index is a ruby array.
  #------------------------------------------------------------------------------------

  def each_with_counter

    iterator = get_iterator_fast
    while (iterator.has_next?)
      yield iterator.get_next, iterator.get_current_counter if block_given?
    end
    
  end

  #------------------------------------------------------------------------------------
  # Continues a each from the position the @local_iterator is in.  each_cont cannot be
  # called from multiple threads as there is only one @local_iterator.
  #------------------------------------------------------------------------------------

  def each_cont

    while (elmt = self.next)
      yield elmt if block_given?
    end

  end

  #----------------------------------------------------------------------------------------
  # Given an MDArray, makes it immutable.  Renjin data cannot be changed as Renjin assumes
  # it can delay processing.
  #----------------------------------------------------------------------------------------

  def immutable

    instance_eval { def set(name, value) raise "Array is immutable" end }
    instance_eval { def set_scalar(name, value) raise "Array is immutable" end }
    instance_eval { def set_next(value) raise "Array is immutable" end }
    instance_eval { def []=(name, value) raise "Array is immutable" end }

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  private
  
  #------------------------------------------------------------------------------------
  # Cycles through the whole list of elements yielding to a block (if given) the next
  # element and its iterator. Was made private so that users do not need to know about
  # iterator.  Giving iterator could be a speed up usefule for final users concerned 
  # about performance.
  #------------------------------------------------------------------------------------

  def each_with_iterator

    iterator = get_iterator_fast
    while (iterator.has_next?)
      yield iterator.get_next, iterator if block_given?
    end
    
  end

end
