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
  #
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

  def self.binary_operator=(operator)
    @@binary_operator = operator
  end

  def self.binary_operator
    @@binary_operator
  end

  def self.unary_operator=(operator)
    @@unary_operator = operator
  end

  def self.unary_operator
    @@unary_operator
  end

  def get_binary_op
    (@binary_operator)? @binary_operator : @@binary_operator
  end

  def get_unary_op
    (@unary_operator)? @unary_operator : @@unary_operator
  end

  # Factory Methods

  #------------------------------------------------------------------------------------
  # Builds a new MDArray
  #------------------------------------------------------------------------------------

  def self.build(type, shape, storage = nil)
    
    dtype = DataType.valueOf(type.upcase)
    jshape = shape.to_java :int

    if (storage)
      jstorage = storage.to_java type.downcase.to_sym
      nc_array = Java::UcarMa2.Array.factory(dtype, jshape, jstorage)
    else
      nc_array = Java::UcarMa2.Array.factory(dtype, jshape)
    end

    klass = Object.const_get("#{type.capitalize}MDArray")
    return klass.new(type, nc_array)

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.boolean(shape, storage = nil)
    self.build("boolean", shape, storage)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.byte(shape, storage = nil)
    self.build("byte", shape, storage)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.char(shape, storage = nil)
    self.build("char", shape, storage)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.short(shape, storage = nil)
    self.build("short", shape, storage)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.int(shape, storage = nil)
    self.build("int", shape, storage)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.long(shape, storage = nil)
    self.build("long", shape, storage)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.float(shape, storage = nil)
    self.build("float", shape, storage)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.double(shape, storage = nil)
    self.build("double", shape, storage)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.string(shape, storage = nil)
    self.build("string", shape, storage)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.structure(shape, storage = nil)
    self.build("structure", shape, storage)
  end

  #------------------------------------------------------------------------------------
  # Construct an array by executing a function over each coordinate.
  # The resulting array therefore has a value ``fn(x, y, z)`` at
  # coordinate ``(x, y, z)``.
  # Parameters
  # ----------
  # <tt>&block<tt>: a block to be executed
  #    The block is called with N parameters, each of which
  #  represents the coordinates of the array varying along a
  #  specific axis.  For example, if `shape` were ``(2, 2)``, then
  #  the parameters would be two arrays, ``[[0, 0], [1, 1]]`` and
  #  ``[[0, 1], [0, 1]]``.  `fn` must be capable of operating on
  #  arrays, and should return a scalar value.
  # shape : (N,) tuple of ints
  #   Shape of the output array, which also determines the shape of
  #   the coordinate arrays passed to `fn`.
  # dtype : data-type, optional
  #    Data-type of the coordinate arrays passed to `fn`.  By default,
  #   `dtype` is float.
  #------------------------------------------------------------------------------------

  def self.fromfunction(type, shape, &block)

    dtype = DataType.valueOf(type.upcase)
    jshape = shape.to_java :int
    arr = self.build(type, shape)
    arr.dim_set(nil, block)
    return arr

  end

  #------------------------------------------------------------------------------------
  #
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
  #
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
  #
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
  #
  #------------------------------------------------------------------------------------

  def self.register_function(name, func)
    
    if ((list = MDArray.function_map[name]) == nil)
      list = (MDArray.function_map[name] = Array.new)
    end
    list << FunctionMap.new(name, func[0], func[1], func[2], func[3], func[4], func[5])

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
