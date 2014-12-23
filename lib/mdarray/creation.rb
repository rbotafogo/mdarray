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

##########################################################################################
#
##########################################################################################

class MDArray

  #------------------------------------------------------------------------------------
  # Given two types returns the upcasted one
  #------------------------------------------------------------------------------------

  def self.upcast(type1, type2)

    type1_i = MDArray.numerical.index(type1)
    type2_i = MDArray.numerical.index(type2)
    type_i = (type1_i < type2_i)? type2_i : type1_i
    type = MDArray.numerical.at(type_i)

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def get_binary_op
    (@binary_operator)? @binary_operator : MDArray.binary_operator
  end

  def get_unary_op
    (@unary_operator)? @unary_operator : MDArray.unary_operator
  end

  # Factory Methods

  #------------------------------------------------------------------------------------
  # Builds a new MDArray
  # @param type the type of the new mdarray to build, could be boolean, byte, short,
  #  int, long, float, double, string, structure
  # @param shape [Array] the shape of the mdarray as a ruby array
  # @param storage [Array] a ruby array with the initialization data
  #------------------------------------------------------------------------------------

  def self.build(type, shape, storage = nil, layout = :row)

    if (shape.is_a? String)
      # building from csv
      # using shape as filename
      # using storage as flag for headers
      storage = (storage)? storage : false
      parameters = Csv.read_numeric(shape, storage)
      shape=[parameters[0], parameters[1]]
      storage = parameters[2]
    end

    # Java-NetCDF creates an ArrayObject when given type string.  It should create an
    # ArrayString instead.  Some string methods in Java-NetCDF expect an ArrayObject
    # instead of an ArrayString, however, other libraries actually expect an ArrayString,
    # so we know have two type: "string" stores internally the data as an ArrayObject, 
    # "rstring" stores data internally as an ArrayString
    rtype = (type == "rstring")? "string" : type
    dtype = DataType.valueOf(rtype.upcase)

    jshape = shape.to_java :int

    if (storage)
      jstorage = storage.to_java rtype.downcase.to_sym
      if (type == "rstring")
        # circunvent bug in Java-NetCDF.  Type rstring is actually type string but should
        # and should build and ArrayString and not an ObjectString which is currently being
        # build.
        index = Java::UcarMa2.Index.factory(jshape)
        nc_array = Java::UcarMa2.ArrayString.factory(index, jstorage)
      else
        nc_array = Java::UcarMa2.Array.factory(dtype, jshape, jstorage)
      end
    else
      nc_array = Java::UcarMa2.Array.factory(dtype, jshape)
    end

    klass = Object.const_get("#{rtype.capitalize}MDArray")
    return klass.new(rtype, nc_array)

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.from_jstorage(type, shape, jstorage, section = false)

    if (shape.size == 1 && shape[0] == 0)
      return nil
    end

    dtype = DataType.valueOf(type.upcase)
    jshape = shape.to_java :int
    nc_array = Java::UcarMa2.Array.factory(dtype, jshape, jstorage)
    klass = Object.const_get("#{type.capitalize}MDArray")
    return klass.new(type, nc_array, section)

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.build_from_nc_array(type, nc_array, section = false)
    if (!type)
      type = MDArray.get_ncarray_type(nc_array)
    end
    klass = Object.const_get("#{type.capitalize}MDArray")
    return klass.new(type, nc_array, section)
  end
  
  #------------------------------------------------------------------------------------
  # Builds a boolean mdarray
  # @param shape [Array] the shape of the mdarray as a ruby array
  # @param storage [Array] a ruby array with the initialization data
  #------------------------------------------------------------------------------------

  def self.boolean(shape, storage = nil, layout = :row)
    self.build("boolean", shape, storage, layout)
  end

  #------------------------------------------------------------------------------------
  # Builds a byte mdarray
  # @param shape [Array] the shape of the mdarray as a ruby array
  # @param storage [Array] a ruby array with the initialization data
  #------------------------------------------------------------------------------------

  def self.byte(shape, storage = nil, layout = :row)
    self.build("byte", shape, storage, layout)
  end

  #------------------------------------------------------------------------------------
  # Builds a char mdarray
  # @param shape [Array] the shape of the mdarray as a ruby array
  # @param storage [Array] a ruby array with the initialization data
  #------------------------------------------------------------------------------------

  def self.char(shape, storage = nil, layout = :row)
    self.build("char", shape, storage, layout)
  end

  #------------------------------------------------------------------------------------
  # Builds a byte mdarray
  # @param shape [Array] the shape of the mdarray as a ruby array
  # @param storage [Array] a ruby array with the initialization data
  #
  #------------------------------------------------------------------------------------

  def self.short(shape, storage = nil, layout = :row)
    self.build("short", shape, storage, layout)
  end

  #------------------------------------------------------------------------------------
  # Builds an int mdarray
  # @param shape [Array] the shape of the mdarray as a ruby array
  # @param storage [Array] a ruby array with the initialization data
  #------------------------------------------------------------------------------------

  def self.int(shape, storage = nil, layout = :row)
    self.build("int", shape, storage, layout)
  end

  #------------------------------------------------------------------------------------
  # Builds a long mdarray
  # @param shape [Array] the shape of the mdarray as a ruby array
  # @param storage [Array] a ruby array with the initialization data
  #
  #------------------------------------------------------------------------------------

  def self.long(shape, storage = nil, layout = :row)
    self.build("long", shape, storage, layout)
  end

  #------------------------------------------------------------------------------------
  # Builds a float mdarray
  # @param shape [Array] the shape of the mdarray as a ruby array
  # @param storage [Array] a ruby array with the initialization data
  #------------------------------------------------------------------------------------

  def self.float(shape, storage = nil, layout = :row)
    self.build("float", shape, storage, layout)
  end

  #------------------------------------------------------------------------------------
  # Builds a double mdarray
  # @param shape [Array] the shape of the mdarray as a ruby array
  # @param storage [Array] a ruby array with the initialization data
  #------------------------------------------------------------------------------------

  def self.double(shape, storage = nil, layout = :row)
    self.build("double", shape, storage, layout)
  end

  #------------------------------------------------------------------------------------
  # Builds a string mdarray. Java-NetCDF does not actuallly build a string array when
  # type string is passed, it builds an object array.  This is an open issue with 
  # Java-NetCDF.
  # @param shape [Array] the shape of the mdarray as a ruby array
  # @param storage [Array] a ruby array with the initialization data
  #------------------------------------------------------------------------------------

  def self.string(shape, storage = nil, layout = :row)
    self.build("string", shape, storage, layout)
  end

  #------------------------------------------------------------------------------------
  # Builds a string mdarray.  Really builds an string array.  Only exists to fix the
  # Java-NetCDF issue described above.
  # @param shape [Array] the shape of the mdarray as a ruby array
  # @param storage [Array] a ruby array with the initialization data
  #------------------------------------------------------------------------------------

  def self.rstring(shape, storage = nil, layout = :row)
    self.build("rstring", shape, storage, layout)
  end

  #------------------------------------------------------------------------------------
  # Builds a structure mdarray
  # @param shape [Array] the shape of the mdarray as a ruby array
  # @param storage [Array] a ruby array with the initialization data
  #------------------------------------------------------------------------------------

  def self.structure(shape, storage = nil, layout = :row)
    self.build("structure", shape, storage, layout)
  end

  #------------------------------------------------------------------------------------
  # Construct an array by executing a function over each coordinate.
  # The resulting array therefore has a value ``fn(x, y, z)`` at
  # coordinate ``(x, y, z)``.
  # Parameters
  # ----------
  # @param type : data-type, optional
  #    Data-type of the coordinate arrays passed to `fn`
  # @param shape : (N,) tuple of ints
  #   Shape of the output array, which also determines the shape of
  #   the coordinate arrays passed to `fn`.
  # @param &block: a block to be executed
  #   The block is called with N parameters, each of which
  #   represents the coordinates of the array varying along a
  #   specific axis.  For example, if `shape` were ``(2, 2)``, then
  #   the parameters would be two arrays, ``[[0, 0], [1, 1]]`` and
  #   ``[[0, 1], [0, 1]]``.  `fn` must be capable of operating on
  #   arrays, and should return a scalar value.
  #------------------------------------------------------------------------------------

  def self.fromfunction(type, shape, &block)

    dtype = DataType.valueOf(type.upcase)
    jshape = shape.to_java :int
    arr = self.build(type, shape)
    arr.dim_set(nil, block)
    return arr

  end

  #------------------------------------------------------------------------------------
  # Build mdarray and fills it with the given value
  # @param type type of the mdarray
  # @param shape
  # @param value the given value to fill in the mdarray
  #------------------------------------------------------------------------------------

  def self.init_with(type, shape, value)

    size = 1
    shape.each do |val|
      size = size * val
    end

    storage = Array.new(size, value)    
    self.build(type, shape, storage)

  end

  #------------------------------------------------------------------------------------
  # Return evenly spaced values within a given interval.
  # Values are generated within the half-open interval [start, stop) (in other words, 
  # the interval including start but excluding stop). For integer arguments the function 
  # is equivalent to the Python built-in range function, but returns an mdarray rather 
  # than a list.
  # When using a non-integer step, such as 0.1, the results will often not be 
  # consistent. It is better to use linspace for these cases.
  # @param start
  # @param stop
  # @param step
  # @return int mdarray
  #------------------------------------------------------------------------------------

  def self.arange(*args)

    case args.size
    when 1
      start = 0
      last = args[0]
      stride = 1
    when 2
      start = args[0]
      last = args[1]
      stride = 1
    when 3
      start = args[0]
      last = args[1]
      stride = args[2]
    else
      raise "Method arange can have at most 3 arguments"
    end

    arr = Array.new
    (start...last).step(stride) { |val| arr << val }
    self.build("int", [arr.size], arr)

  end

  #------------------------------------------------------------------------------------
  # Return evenly spaced values within a given interval.
  # Values are generated within the half-open interval [start, stop) (in other words, 
  # the interval including start but excluding stop). For integer arguments the function 
  # is equivalent to the Python built-in range function, but returns an mdarray rather 
  # than a list.
  # @param type the desired type of the new mdarray
  # @param start
  # @param stop
  # @param step
  # @returns mdarray of the given type
  #------------------------------------------------------------------------------------

  def self.typed_arange(type, *args)

    case args.size
    when 1
      start = 0
      last = args[0]
      stride = 1
    when 2
      start = args[0]
      last = args[1]
      stride = 1
    when 3
      start = args[0]
      last = args[1]
      stride = args[2]
    else
      raise "Method arange can have at most 3 arguments"
    end

    arr = Array.new
    (start...last).step(stride) { |val| arr << val }
    self.build(type, [arr.size], arr)

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.linspace(type, start, stop, number)
    
    arr = (start..stop).step((stop-start).to_f/(number-1)).map{|x| x }
    self.build(type, [arr.size], arr)
    
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.ones(type, shape)
    init_with(type, shape, 1)
  end
  
  #------------------------------------------------------------------------------------
  # fmap is an array with the following data: long_name, scope, function, return_type, 
  # input1_type, input2_type
  #------------------------------------------------------------------------------------

  def self.register_function(name, fmap, arity, helper_class)
    
    if ((list = MDArray.function_map[name]) == nil)
      list = (MDArray.function_map[name] = Array.new)
    end
    list << FunctionMap.new(name, fmap[0], fmap[1], fmap[2], fmap[3], fmap[4], fmap[5],
                            arity, helper_class)

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  protected

  #------------------------------------------------------------------------------------
  # Builds a new CoercedMDArray
  #------------------------------------------------------------------------------------

  def coerced_build(type, nc_array)

    klass = Object.const_get("#{type.capitalize}MDArray")
    instance = klass.new(type, nc_array)
    instance.coerced = true
    return instance

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  private
  
  #------------------------------------------------------------------------------------
  # Get the shape: length of array in each dimension.
  #------------------------------------------------------------------------------------

  def self.get_shape(jarray)
    jarray.getShape().to_a
  end

  #------------------------------------------------------------------------------------
  #  Get the number of dimensions of the array.
  #------------------------------------------------------------------------------------

  def self.get_rank(jarray)
    jarray.getRank()
  end

  #------------------------------------------------------------------------------------
  # Gets the size of the array.  
  #------------------------------------------------------------------------------------

  def self.get_size(jarray)
    jarray.getSize()
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def self.get_element_type(jarray)
    jarray.getElementType()
  end

end
