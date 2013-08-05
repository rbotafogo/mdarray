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

require 'rubygems'
require "test/unit"
require 'shoulda'

require 'mdarray'


class MDArrayTest < Test::Unit::TestCase

  context "Array Creation" do

    #-------------------------------------------------------------------------------------
    # array creation always requires the type and shape, differently from NumPy 
    # narray in which the type and shape can be inferred from the initialization
    # data.  MDArray can be numerical and non-numerical.  Numerical MDArrays can be of 
    # type: byte, short, int, long, double.  Non-numerical MDArrays can be of type
    # boolean, char, string.
    #-------------------------------------------------------------------------------------

    should "create byte array" do

      # build int array with given shape and all values 0
      a = MDArray.byte([2, 2, 3])
      assert_equal([2, 2, 3], a.shape)
      assert_equal(3, a.ndim)
      assert_equal(12, a.size)
      assert_equal("byte", a.dtype)
      assert_equal(0, a[0, 0, 0])
      assert_equal(0, a[1, 1, 2])

      # Cannot write a boolean value on a byte array
      assert_raise ( RuntimeError ) { a[0, 0, 0] = true }
      # writing a double value on byte array will cast double to byte
      a[0, 0, 0] = 10.25
      assert_equal(a[0, 0, 0], 10)
      a[0, 0, 0] = 200
      assert_equal(a[0, 0, 0], -56)

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "create short array" do

      # build int array with given shape and all values 0
      a = MDArray.build("short", [2, 2, 3])
      assert_equal([2, 2, 3], a.shape)
      assert_equal(3, a.ndim)
      assert_equal(12, a.size)
      assert_equal("short", a.dtype)
      assert_equal(0, a[0, 0, 0])
      assert_equal(0, a[1, 1, 2])
      
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "create int array" do

      # build int array with given shape and all values 0
      a = MDArray.build("int", [2, 2, 3])
      assert_equal([2, 2, 3], a.shape)
      assert_equal(3, a.ndim)
      assert_equal(12, a.size)
      assert_equal("int", a.dtype)
      assert_equal(0, a[0, 0, 0])
      assert_equal(0, a[1, 1, 2])
      
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "create float array" do
      
      # build a float array with shape [2, 3] and the given data.
      # Note that the data is shaped according to the given shape, so, in this case
      # the array is:
      # [[0.0 1.0 2.0]
      #  [3.0 4.0 5.0]]
      # Note also that although the data is in "int" format the resulting array
      # is of type float
      b = MDArray.float([2, 3], [0, 1, 2, 3, 4, 5, 6])
      assert_equal("float", b.dtype)
      assert_equal(1.0, b[0, 1])

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "create arrays from arange functions" do 

      # use method arange to build an int array with a sequence of numbers
      # d = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14]
      d = MDArray.arange(15)
      counter = 0
      d.each do |elmt|
        assert_equal(counter, elmt)
        counter += 1
      end

      # with 2 arguments we have the begining and ending values for arange
      # e = [5 6 7 8 9 10 11 12 13 14]
      e = MDArray.arange(5, 15)
      counter = 5
      e.each do |elmt|
        assert_equal(counter, elmt)
        counter += 1
      end

      # with 3 arguments we have the begining, ending and step arguments
      # f = [10 15 20 25]
      f = MDArray.arange(10, 30, 5)
      counter = 10
      f.each do |elmt|
        assert_equal(counter, elmt)
        counter += 5
      end

      # typed_arange does the same as arange but for arrays of other type
      g = MDArray.typed_arange("double", 10, 30)

      # h = [10.0 12.5 15.0 17.5 20.0 22.5 25.0 27.5]
      h = MDArray.typed_arange("double", 10, 30, 2.5)
      counter = 10
      h.each do |elmt|
        assert_equal(counter, elmt)
        counter += 2.5
      end

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "create array from fromfunction" do

      # creates an array from a function (actually a block).  The name fromfunction
      # is preserved to maintain API compatibility with NumPy (is it necessary?)
      arr = MDArray.fromfunction("double", [5]) do |x|
        x
      end

      # creates an array from a function (actually a block).  The name fromfunction
      # is preserved to maintain API compatibility with NumPy (is it necessary?)
      arr = MDArray.fromfunction("double", [5, 5]) do |x, y|
        x + y
      end

      # creates an array from a function (actually a block).  The name fromfunction
      # is preserved to maintain API compatibility with NumPy (is it necessary?)
      arr = MDArray.fromfunction("double", [2, 3, 4]) do |x, y, z|
        3.21 * x + y + z
      end
      assert_equal("double", arr.type)
      assert_equal(0, arr[0, 0, 0])
      assert_equal(4.21, arr[1, 1, 0])

      # creates an array from a function (actually a block).  The name fromfunction
      # is preserved to maintain API compatibility with NumPy (is it necessary?)
      arr = MDArray.fromfunction("int", [2, 3, 4]) do |x, y, z|
        x + y + z
      end
      assert_equal("int", arr.type)

      # creates an array from a function (actually a block).  The name fromfunction
      # is preserved to maintain API compatibility with NumPy (is it necessary?)
      arr = MDArray.fromfunction("double", [5, 5, 5, 5]) do |x, y, z, k|
        x + y + z + k
      end

      # creates an array from a function (actually a block).  The name fromfunction
      # is preserved to maintain API compatibility with NumPy (is it necessary?)
      arr = MDArray.fromfunction("double", [5, 5, 5, 5, 5]) do |x, y, z, k, w|
        x + y + z + k + w
      end

      # creates an array from a function (actually a block).  The name fromfunction
      # is preserved to maintain API compatibility with NumPy (is it necessary?)
      arr = MDArray.fromfunction("double", [5, 5, 5, 5, 5, 5]) do |x, y, z, k, w, i|
        x + y + z + k + w + i
      end

      # creates an array from a function (actually a block).  The name fromfunction
      # is preserved to maintain API compatibility with NumPy (is it necessary?)
      arr = MDArray.fromfunction("double", [5, 5, 5, 5, 5, 5, 5]) do |x, y, z, k, w, i, l|
        x + y + z + k + w + i + l
      end

      # creates an array from a function (actually a block).  The name fromfunction
      # is preserved to maintain API compatibility with NumPy (is it necessary?)
      # Arrays with dimension larger than 7, the data is treated as an array, and we
      # cannot use the same notation as before.
      arr = MDArray.fromfunction("double", [5, 5, 5, 5, 5, 5, 5, 5]) do |x|
        x.inject(:+)
      end

      # creates an array from a function (actually a block).  The name fromfunction
      # is preserved to maintain API compatibility with NumPy (is it necessary?)
      # A similar notation as the array can be used for lower dimensions using ruby *
      # operator.  This is a little less efficient though.
      arr = MDArray.fromfunction("double", [5, 5, 5, 5, 5]) do |*x|
        x.inject(:+)
      end

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "create array from arange" do

      arr = MDArray.arange(10)
      assert_equal("0 1 2 3 4 5 6 7 8 9 ", arr.to_string)
      arr = MDArray.arange(2, 30)
      assert_equal("2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 ", 
                   arr.to_string)
      arr = MDArray.arange(2, 30, 3)
      assert_equal("2 5 8 11 14 17 20 23 26 29 ", arr.to_string)
      # inconsistent result, better to use linspace
      arr = MDArray.arange(2, 30, 2.5)

    end


    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "create array from linspace" do

      arr = MDArray.linspace("double", 0, 2, 9)
      assert_equal(0.0, arr[0])
      assert_equal(0.5, arr[2])
      assert_equal(1.0, arr[4])
      assert_equal(1.5, arr[6])
      assert_equal(2.0, arr[8])

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "create array with ones" do

      # creates an array with all 1's
      ones = MDArray.ones("byte", [2, 2, 2, 2])
      assert_equal(1, ones[1, 1, 1, 1])
      assert_equal(1, ones[1, 0, 1, 0])

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "create array with given value" do

      # creates an array with a given value and type
      fives = MDArray.init_with("double", [3, 3], 5.34)
      assert_equal(5.34, fives[2, 1])
      assert_equal(5.34, fives[0, 2])

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "allow filling the array with data" do

      # fill b with a given value
      b = MDArray.double([2, 3], [0, 1, 2, 3, 4, 5])
      b.fill(5.47)
      b.each do |elmt|
        assert_equal(5.47, elmt)
      end

      # typed_arange does the same as arange but for arrays of other type
      g = MDArray.typed_arange("double", 6)
      g.reshape!([2, 3])
      b.fill(g)
      assert_equal(b.to_string, g.to_string)

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "create boolean arrays" do

      bool = MDArray.boolean([2, 2])
      bool[0, 0] = true
      assert_raise ( RuntimeError ) { bool[0, 1] = 10.0 }
      assert_equal(bool[0, 0], true)
      bool[0, 1] = false
      assert_equal(bool[0, 1], false)

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "create string arrays" do

      sarray = MDArray.string([2, 3], ["hello", "this", "is", "a", "string", "array"])
      assert_equal(6, sarray.size)
      assert_equal("hello", sarray.get([0, 0]))
      assert_equal("hello this is a string array ", sarray.to_string)

    end

    #-------------------------------------------------------------------------------------
    # A struct array is an array of pointers to structures
    #-------------------------------------------------------------------------------------

    should "create struct arrays" do

      m = Hash.new
      m[:hello] = "world"
      m[:test] = 1.23

      struct = MDArray.structure([10])
      struct[0] = m

    end

    #-------------------------------------------------------------------------------------
    # Creates a scalar array, i.e, array of size 0.  In general this is not necessary and
    # should not be used as one can operate with scalars directly.  This is however needed 
    # for writing scalar values on NetCDF-3 files.
    #-------------------------------------------------------------------------------------

    should "create scalar arrays" do

      scalar = MDArray.double([])
      scalar.set_scalar(2.55)
      assert_equal(2.55, scalar.get_scalar)

      scalar2 = MDArray.double([])
      scalar2.set_scalar(5.55)
      
      scalar3 = scalar + scalar2

    end

    #-------------------------------------------------------------------------------------
    # Creates a MDArray from a java array.  Needed for some internal methods. Not to be
    # used in general
    #-------------------------------------------------------------------------------------

    should "creade arrays from java arrays" do

      value = Array.new
      (0...5).each do |val|
        value << val.to_java(:float)
      end
      MDArray.from_jstorage("float", [1], value.to_java(:float))

    end

  end

end
