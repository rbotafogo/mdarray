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

require 'map'
require_relative 'env'

##########################################################################################
# Superclass for implementations of multidimensional arrays. An Array has a classType 
# which gives the Class of its elements, and a shape which describes the number of 
# elements in each index. The rank is the number of indices. A scalar Array has 
# rank = 0. An Array may have arbitrary rank. The Array size is the total number of 
# elements, which must be less than 2^31 (about 2x10^9).
#
# Actual data storage is done with Java 1D arrays and stride index calculations. 
# This makes our Arrays rectangular, i.e. no "ragged arrays" where different elements 
# can have different lengths as in Java multidimensional arrays, which are arrays of 
# arrays.
#
# Each primitive Java type (boolean, byte, char, short, int, long, float, double) has 
# a corresponding concrete implementation, e.g. ArrayBoolean, ArrayDouble. Reference 
# types are all implemented using the ArrayObject class, with the exceptions of the 
# reference types that correspond to the primitive types, eg Double.class is mapped 
# to double.class.
#
# For efficiency, each Array type implementation has concrete subclasses for ranks 0-7, 
# eg ArrayDouble.D0 is a double array of rank 0, ArrayDouble.D1 is a double array of 
# rank 1, etc. These type and rank specific classes are convenient to work with when you 
# know the type and rank of the Array. Ranks greater than 7 are handled by the 
# type-specific superclass e.g. ArrayDouble. The Array class itself is used for fully 
# general handling of any type and rank array. Use the Array.factory() methods to create 
# Arrays in a general way.
#
# The stride index calculations allow logical views to be efficiently implemented, eg 
# subset, transpose, slice, etc. These views use the same data storage as the original 
# Array they   # are derived from. The index stride calculations are equally efficient 
# for any composition of logical views.
# 
# The type, shape and backing storage of an Array are immutable. The data itself is read 
# or written using a Counter or an IndexIterator, which stores any needed state information 
# for efficient traversal. This makes use of Arrays thread-safe (as long as you dont share 
# the Counter or IndexIterator) except for the possibility of non-atomic read/write on 
# long/doubles. If this is the case, you should probably synchronize your calls. 
# Presumably 64-bit CPUs will make those operations atomic also.
##########################################################################################

class MDArray
  include_package "ucar.ma2"
  include Enumerable
  
  attr_reader :type
  attr_reader :nc_array
  attr_reader :local_index               # internal helper index for this array
  attr_reader :local_iterator
  # @binary_operator and @unary_operator are instance variables that allow overwriting the
  # class variables @@binary_operator and @@unary_operator
  attr_accessor :binary_operator
  attr_accessor :unary_operator 
  attr_accessor :coerced
  
  @numerical = ["byte", "short", "int", "long", "float", "double"]
  @non_numerical = ["boolean", "char", "string", "sequence"]

  class << self
    
    attr_accessor :functions
    attr_accessor :function_map

    attr_reader :numerical
    attr_reader :non_numerical

  end

  MDArray.function_map = Map.new

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def initialize(type, storage, section = false)

    @type = type
    @nc_array = storage
    @local_index = Counter.new(self)
    @local_iterator = nil
    @section = section
    @coerced = false            # should never be set by the user! For internal use only!

    # initialize printing defaults
    printing_defaults

  end

  #------------------------------------------------------------------------------------
  #  Get the number of dimensions of the array.
  #------------------------------------------------------------------------------------

  def get_rank
    @nc_array.getRank()
  end

  alias ndim :get_rank
  alias rank :get_rank

  #------------------------------------------------------------------------------------
  # Gets the size of the array.  
  #------------------------------------------------------------------------------------

  def get_size
    @nc_array.getSize()
  end

  alias size :get_size

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def get_shape
    @nc_array.getShape().to_a
  end

  alias shape :get_shape

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def get_element_type
    @nc_array.getElementType().toString()
  end

  alias dtype :get_element_type

  #------------------------------------------------------------------------------------
  # Prints the content of the netcdf_array. Mainly for debugging purposes
  #------------------------------------------------------------------------------------
  
  def to_string(max_size = 3)
    if (size > max_size * 2)
      @nc_array.toString()
    else
      @nc_array.toString()
    end

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def to_s
    self.print
  end

  #------------------------------------------------------------------------------------
  # Method to print all elements of the array for debuging purposes only.  Does not
  # need to be very efficient.
  #------------------------------------------------------------------------------------

  def ndenumerate
    
    reset_traversal
    while (@local_iterator.has_next?) do
      @local_iterator.next
      print "#{get_current_index} #{@local_iterator.get_current}\n"
    end
    
  end

  #---------------------------------------------------------------------------------------
  # Checks to see if this array is compatible with another array.  Two arrays are
  # compatible if they have the same shape
  #---------------------------------------------------------------------------------------

  def compatible(array)
    (get_shape == array.get_shape)? true : false
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def get_type(other_val, force_cast = nil)

    if (force_cast != nil)
      type = force_cast
    elsif (other_val.is_a? Numeric)
      # if type is integer, then make it the smaller possible integer and then let upcast
      # do its work
      if (other_val.integer?)
        type = "short"
      else
        type = "double"
      end
      type = MDArray.upcast(@type, type)
    else
      type = MDArray.upcast(@type, other_val.type)
    end

    return type

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def self.print_function_map

    MDArray.function_map.each_pair do |key, value|

      value.each do |func|

        p "scope: #{func.scope}, short name: #{key}, long name: #{func.long_name}, return type: #{func.return_type}, input1 type: #{func.input1_type}, input2 type: #{func.input2_type}"

      end

    end
      
  end # print_function_map

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def self.function_map_to_csv

    p "scope, short name, long name, return type, input1 type, input2 type" 
    
    MDArray.function_map.each_pair do |key, value|
      value.each do |func|
        p "#{func.scope}, #{key}, #{func.long_name}, #{func.return_type}, #{func.input1_type}, #{func.input2_type}"
      end
    end
      
  end # print_function_map

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.make_binary_op(name, exec_type, func, force_type = nil, pre_condition = nil,
                          post_condition = nil)

    define_method(name) do |op2, requested_type = nil, *args|
      binary_op = get_binary_op
      op = binary_op.new(name, exec_type, force_type, pre_condition, post_condition)
      op.exec(self, op2, requested_type, *args)
    end

    MDArray.register_function(name, func)

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.make_unary_op(name, exec_type, func, force_type = nil, pre_condition = nil,
                         post_condition = nil)
    
    define_method(name) do |requested_type = nil, *args|
      unary_op = get_unary_op
      op = unary_op.new(name, exec_type, force_type, pre_condition, post_condition)
      op.exec(self, requested_type, *args)
    end

    MDArray.register_function(name, func)

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def self.select_function(name, scope = nil, return_type = nil, input1_type = nil, 
                           input2_type = nil)

    list = MDArray.function_map[name]
    best_value = -1
    func = nil

    list.each do |function|

      value = 0
      value += (scope == function.scope)? 8 : 0
      value += (return_type == function.return_type)? 4 : 0
      value += (input1_type == function.input1_type)? 2 : 0
      value += (input2_type == function.input2_type)? 1 : 0
      if (value > best_value)
        func = function.function
        best_value = value
        # p "best value: #{best_value}, func: #{func}"
      end
    end

    func

  end

  #------------------------------------------------------------------------------------
  # Methods that are implemented in subclasses and are not really necessary, they are
  # used only if MDArray is created with some of the capitalized types, e.g., Double
  # Integer, etc. instead of double, integer which are preferred and execute faster.
  #------------------------------------------------------------------------------------

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def get_iterator_fast
    
    case type
    when "boolean"
      IteratorFastBoolean.new(self)
    when "char"
      IteratorFastChar.new(self)
    when "short"
      IteratorFastShort.new(self)
    when "int"
      IteratorFastInt.new(self)
    when "long"
      IteratorFastLong.new(self)
    when "float"
      IteratorFastFloat.new(self)
    when "double"
      IteratorFastDouble.new(self)
    else
      IteratorFast.new(self)
    end

  end
  
end

require_relative 'mdarray/proc_util'
require_relative 'mdarray/function_map'
require_relative 'mdarray/creation'
require_relative 'mdarray/hierarchy'
require_relative 'mdarray/function_creation'
require_relative 'mdarray/ruby_functions'
require_relative 'mdarray/operators'
require_relative 'mdarray/ruby_operators'
require_relative 'mdarray/fast_non_numerical'
require_relative 'mdarray/access'
require_relative 'mdarray/slices'
require_relative 'mdarray/printing'
require_relative 'mdarray/counter'
# require_relative 'mdarray/statistics'

