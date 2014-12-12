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
  # Create a copy of this Array, copying the data so that physical order is the same as 
  # logical order
  #------------------------------------------------------------------------------------

  def copy
    MDArray.build_from_nc_array(@type, @nc_array.copy())
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def flip(dim)
    MDArray.build_from_nc_array(@type, @nc_array.flip(dim))
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def reshape(shape, copy = false)

    new_shape = shape.to_java :int

    if (copy)
      nc_array = @nc_array.reshape(new_shape)
    else
      nc_array = @nc_array.reshapeNoCopy(new_shape)
    end

    MDArray.build_from_nc_array(@type, nc_array)

  end

  #----------------------------------------------------------------------------------------
  # This method fixes a bug in netcdf-java!!! 
  #----------------------------------------------------------------------------------------

  def reshape!(shape)
    new_shape = shape.to_java :int
    # Netcdf-Java bug... reshape of ArrayString becomes an ArrayObject.  In principle
    # should not require comparison with ArrayString here
    if (@nc_array.is_a? ArrayString)
      @nc_array = Java::UcarMa2.ArrayString.factory(@nc_array.getIndex(), 
        @nc_array.getStorage())
    else
      @nc_array = @nc_array.reshapeNoCopy(new_shape)
    end
    # when we reshape an array we need to re-initialize its index and local_iterator
    @local_index = Counter.new(self)
    @local_iterator = nil
    @self
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def reduce(dim = nil)

    if (dim)
      nc_array = @nc_array.reduce(dim.to_java :int)
    else
      nc_array = @nc_array.reduce
    end
    
    shape = MDArray.get_shape(nc_array)
    MDArray.build_from_nc_array(@type, nc_array)
    
  end

  #---------------------------------------------------------------------------------------
  # Create a new Array using same backing store as this Array, by permuting the indices.
  # Parameters:
  # <tt>indices</tt> the old index dims[k] becomes the new kth index.
  # Returns:
  # the new Array
  # Throws:
  # IllegalArgumentException: - wrong rank or dim[k] not valid
  #---------------------------------------------------------------------------------------

  def permute(indices)

    ind = indices.to_java :int
    
    begin
      perm = @nc_array.permute(ind)
    rescue # should catch IllegalArgumentException
      raise "Illegal argument"
    end

    MDArray.build_from_nc_array(@type, perm)

  end

  #---------------------------------------------------------------------------------------
  # Create a new Array as a subsection of this Array, without rank reduction. No data 
  # is moved, so the new Array references the same backing store as the original.
  # @param origin ruby array specifying the starting index. Must be same rank as original 
  #   Array.
  # @param shape ruby array specifying the extents in each dimension. This becomes the 
  #   shape of the returned Array. Must be same rank as original Array.
  # @param reduce true if the array should be reduced by removing dimensions of size 1
  # @returns new Array
  # Throws:
  # InvalidRangeException - if ranges is invalid
  #------------------------------------------------------------------------------------

  def section(origin, shape, reduce = false)

    jorigin = origin.to_java :int
    jshape = shape.to_java :int

    if (reduce)
      arr = @nc_array.section(jorigin, jshape)
    else
      arr = @nc_array.sectionNoReduce(jorigin, jshape, nil)
    end

    # this is an array section, set it to true
    if (arr.rank == 0)
      return arr.get()
    end

    # Build the new array as a section from the given one.  Last argument to build is
    # "true" indicating this is a section.
    section = MDArray.build_from_nc_array(@type, arr, true)
    copy_print_parameters(section)
    return section

  end

  #------------------------------------------------------------------------------------
  # Create a new Array as a subsection of this Array, without rank reduction. No data 
  # is moved, so the new Array references the same backing store as the original.
  # @param origin ruby array specifying the starting index. Must be same rank as 
  #   original Array.
  # @param shape ruby array specifying the extents in each dimension. This becomes the 
  #   shape of the returned Array. Must be same rank as original Array.
  # @param stride array specifying the strides in each dimension. If null, assume all 
  #   ones.
  # @param reduce true if the array should be reduced by removing dimensions of size 1
  # @returns new Array
  # Throws:
  # InvalidRangeException - if ranges is invalid
  #------------------------------------------------------------------------------------

  def section_with_stride(origin, shape, stride, reduce = false)

    jorigin = origin.to_java :int
    jshape = shape.to_java :int
    jstride = stride.to_java :int

    if (reduce)
      arr = @nc_array.section(jorigin, jshape, jstride)
    else
      arr = @nc_array.sectionNoReduce(jorigin, jshape, jstride)
    end

    # Build the new array as a section from the given one.  Last argument to build is
    # "true" indicating this is a section.
    section = MDArray.build_from_nc_array(@type, arr, true)
    copy_print_parameters(section)
    return section

  end

  #---------------------------------------------------------------------------------------
  # Gets a region from this array.  Region is the same as section but using a different
  # interface.
  # parameters that can be given
  # shape
  # origin
  # size
  # stride
  # range
  # section
  # spec
  #---------------------------------------------------------------------------------------

  def region(*args)
    
    opts = Map.options(args)
    reduce = opts.getopt(:reduce)
    sec = MDArray::Section.build(*args)

    if (reduce)
      arr = @nc_array.section(sec.netcdf_elmt.getRanges())
    else
      arr = @nc_array.sectionNoReduce(sec.netcdf_elmt.getRanges())
    end

    # Build the new array as a section from the given one.  Last argument to build is
    # "true" indicating this is a section.
    section = MDArray.build_from_nc_array(@type, arr, true)
    copy_print_parameters(section)
    return section

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def section?
    @section
  end

  #------------------------------------------------------------------------------------
  # Create a new Array using same backing store as this Array, by fixing the specified 
  # dimension at the specified index value. This reduces rank by 1.
  # @param dim dimension to fix
  # @param val value in which to fix the dimension
  # @return new array sliced at the given dimension on the specified value
  #------------------------------------------------------------------------------------

  def slice(dim, val)
    
    arr = @nc_array.slice(dim, val)
    slice = MDArray.build_from_nc_array(@type, arr, true)
    copy_print_parameters(slice)
    return slice

  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def each_slice(axes, reduce = true)
    
    counter = Counter.new(self)

    sizes = Array.new
    (0..rank - 1).each do |axis|
      if (axes.include?(axis))
        sizes[axis] = 1
      else
        sizes[axis] = shape[axis]
      end
    end

    counter.each_along_axes(axes) do |ct|
      yield section(ct, sizes, reduce) if block_given?
    end

  end

  #------------------------------------------------------------------------------------
  # Create a new Array using same backing store as this Array, by transposing two of 
  # the indices.
  # @param dim1 first dimension index
  # @param dim2 second dimension index
  # @return new array with dimensions transposed
  #------------------------------------------------------------------------------------

  def transpose(dim1, dim2)

    arr = @nc_array.transpose(dim1, dim2)
    transpose = MDArray.build_from_nc_array(@type, arr, true)
    copy_print_parameters(transpose)
    return transpose

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  private

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def section=(value)
    @section = value
  end

end
