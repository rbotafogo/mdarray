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

  context "Arithmetic Tests" do

    setup do

      # create a = [20 30 40 50]
      @a = MDArray.arange(20, 60, 10)
      # create b = [0 1 2 3]
      @b = MDArray.arange(4)
      # create c = [1.87 5.34 7.18 8.84]
      @c = MDArray.double([4], [1.87, 5.34, 7.18, 8.84])
      # create d = [[1 2] [3 4]]
      @d = MDArray.int([2, 2], [1, 2, 3, 4])
      # creates an array from a function (actually a block).  The name fromfunction
      # is preserved to maintain API compatibility with NumPy (is it necessary?)
      @e = MDArray.fromfunction("double", [4, 5, 6]) do |x, y, z|
        3.21 * (x + y + z)
      end
      @f = MDArray.fromfunction("double", [4, 5, 6]) do |x, y, z|
        9.57 * x + y + z
      end
      @bool = MDArray.boolean([4], [true, true, false, false])
            
    end # setup

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "do down-casting when in-place operation" do

      # in place operation between an "int" array and a "double" array will keep the 
      # type of a to "int", no up-casting. Values will be truncated
      @a.add! @c
      assert_equal(21, @a[0])
      assert_equal(@a.type, "int")
      
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "do up-casting" do

      # when doing operations between two arrays, the resulting array will have the 
      # highest casting value. result will be of type double
      result = @a + @c
      assert_equal(21.87, result[0])
      assert_equal("double", result.dtype)

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "do up-casting with basic types" do

      result = 1.57 * @a
      # since @a is an int, this should be converted to double, as there is no "float"
      # type in ruby
      assert_equal("double", result.dtype)
      assert_equal(result.to_string, "31.400000000000002 47.1 62.800000000000004 78.5 ")

      result = @c * 1.57
      assert_equal("double", result.dtype)

      # array @a will be cast to "double"
      result = @a ** 2.5
      assert_equal("double", result.dtype)

      # array @c will keep its double type
      result = @c ** 2.5
      assert_equal("double", result.dtype)
      
      # force result to be of given type.  Cannot use binary operators, need to use the
      # corresponding function.  Upcast int @a to float
      result = @a.mul(1.57, "float")
      assert_equal("float", result.dtype)

      result = @a.div(2, "short")
      assert_equal("short", result.dtype)

      # force result to be of given type.  Cannot use binary operators, need to use the
      # corresponding function.
      result = @e.mul(1.57, "float")
      assert_equal("float", result.dtype)


    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "allow forced casting" do

      # force result to be of type float, by normal rules it would be of type double
      result = @a.mul(1.57, "float")
      assert_equal("float", result.dtype)
      # final result depends on when casting occurs.  It is possible that the operation
      # is done in double and cast when storing on the float array, or the operation
      # can be done in float already.  Ruby operations perform the former, i.e., 
      # double operation and cast to float.
      if (MDArray.binary_operator == RubyBinaryOperator)
        assert_equal("31.4 47.1 62.8 78.5 ", result.to_string)
      else
        assert_equal("31.400002 47.100002 62.800003 78.5 ", result.to_string)
      end

      # force result to be ot type "int"
      # @a.binary_operator = BinaryOperator
      result = @a.mul(3.43, "int")
      assert_equal(result.type, "int")
      if (MDArray.binary_operator == RubyBinaryOperator)
        # When BinaryOperator with force casting, values are operated first and then
        # casted.  So, in the example above we have 20 * 3.43 = 68,6 and then the value
        # is casted to int for a result of 68
        assert_equal(68, result[0])
      else
        # When we cast earlier values are first cast to the the selected type
        # and then operated upon.  So, in the example we have 20 * 3.43, which becomes
        # 20 * 3 = 60
        assert_equal(60, result[0])
      end

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------
    
    should "allow mixing types" do

      # adding double to number
      res = @c + 10.5
      assert_equal(res.to_string, "12.370000000000001 15.84 17.68 19.34 ")
      # adding two double arrays
      res = @e + @f

      # adding a double to an int, should cast to double
      res = @c + @a
      assert_equal("21.87 35.34 47.18 58.84 ", res.to_string)
      # adding an int to a double, should cast to double
      res = @a + @c
      assert_equal("21.87 35.34 47.18 58.84 ", res.to_string)

      # adding an int array to a (ruby) float/double number, should cast to double
      res = @a + 10.55
      assert_equal("30.55 40.55 50.55 60.55 ", res.to_string)

      # adding two ints
      res = @a + @b
      assert_equal(res.to_string, "20 31 42 53 ")

      # unary operation on arrays
      res = @c.floor
      assert_equal(res.to_string, "1.0 5.0 7.0 8.0 ")
      # Can also operate with the number first.  Still doing elementwise operation
      c = 10 / @c
      assert_equal("5.347593582887701 1.8726591760299627 1.392757660167131 1.1312217194570136 ",
                   c.to_string)

    end

  end

end
