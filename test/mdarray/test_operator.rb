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

if !(defined? $ENVIR)
  $ENVIR = true
  require_relative '../env.rb'
end

require 'rubygems'
require "test/unit"
require 'shoulda'

require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "Operators Tests" do

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
      @g = MDArray.byte([1], [60])
      @h = MDArray.byte([1], [13])
      @i = MDArray.double([4], [2.0, 6.0, 5.0, 9.0])

      @bool1 = MDArray.boolean([4], [true, false, true, false])
      @bool2 = MDArray.boolean([4], [false, false, true, true])

    end # setup

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "work properly with nil" do

      a = MDArray.int([5, 3, 5])

      assert_raise ( RuntimeError ) { a.fill(nil) }
      assert_raise ( RuntimeError ) { a + nil }
      assert_raise ( RuntimeError ) { a.add!(nil) }

      assert_equal(false, a == nil)
      assert_equal(true, a != nil)
      assert_equal(false, a.eq(nil))
      assert_equal(false, a > nil)
      assert_equal(false, a <= nil)

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "allow setting values" do

      a = MDArray.int([5, 3, 5])
      a.fill(10)

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "do basic array operations" do

      # c = [20 31 42 53]
      # chage the way operators work by changing the binary_operator parameter.
      # @a.binary_operator = BinaryOperator

      c = @a + @b
      assert_equal(20, c[0])

      # c = [20 29 38 47]
      c = @a - @b
      assert_equal(38, c[2])

      # c = [0 30 80 100]
      c = @a * @b
      assert_equal(150, c[3])

      # c = [0 0 0 0]
      c = @b / @a
      assert_equal(0, c[1])
      
      # c = [1 30 1600 125000]
      c = @a ** @b
      assert_equal(1600, c[2])
      # although a and d have the same number of elements we cannot do arithmetic
      # with them.
      assert_raise ( RuntimeError ) { c = @a + @d }

      # arrays a and b still have the same values as before
      assert_equal(20, @a[0])
      assert_equal(30, @a[1])
      assert_equal(2, @b[2])
      assert_equal(3, @b[3])

      # adding two double arrays
      result = @e + @f
      assert_equal(result[0, 0, 0], @e[0, 0, 0] + @f[0, 0, 0])

      # request that result to be of type "byte" is respected
      c = @a.add(@b, "byte")
      assert_equal("byte", c.type)

      # normal int type for result
      c = @a.add 10
      assert_equal("int", c.type)
  
      # upcast will be enforced.  result is double
      c = @a.add @c
      assert_equal("double", c.type)

    end

#=begin
    #-------------------------------------------------------------------------------------
    # Array operations are done elementwise
    #-------------------------------------------------------------------------------------

    should "do basic operations with numbers" do

      # elementwise operation
      c = @a + 20
      assert_equal("40 50 60 70 ", c.to_string)

      # Power test
      c = @c ** 2.5
      assert_equal("4.781938829669405 65.89510321368653 138.13734690718798 232.3435723800906 ",
                   c.to_string)

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "do in-place operations" do

      # a = [20 30 40 50]
      # a ^ 2 = [400, 900, 1600, 2500]
      @a.mul! @a
      assert_equal(1600, @a[2])

      @a.add! 5
      assert_equal("405 905 1605 2505 ", @a.to_string)

      # do in place operations
      # a = a + b = [405 906 1607 2508]
      @a.add! @b
      assert_equal(906, @a[1])
      assert_equal(2508, @a[3])

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "work with expressions" do

      result = @a + 2 * @b - @c
      assert_equal("18.13 26.66 36.82 47.16 ", result.to_string)
      result = (@a + 2) * @b - @c
      assert_equal("-1.87 26.66 76.82 147.16 ", result.to_string)
      result = (@a + 2) * (@b - @c)
      assert_equal("-41.14 -138.88 -217.56 -303.68 ", result.to_string)

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------
    
    should "do bitwise operations" do

      result = @g & @h
      assert_equal("12 ", result.to_string)
      result = @g | @h
      assert_equal("61 ", result.to_string)
      result = @g ^ @h
      assert_equal("49 ", result.to_string)
      # result = @g.binary_ones_complement(@h)
      # assert_equal("-60 ", result.to_string)
      result = @g << 2
      assert_equal("240 ", result.to_string)
      result = @g >> 2
      assert_equal("15 ", result.to_string)

      result = @g & 13
      # although we can coerce arithmetic operations we cannot coerce bitwise operations
      assert_raise ( TypeError ) { result = 13 & @g }

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "coerce arithmetic operations" do

      # resulting array c is upcasted to double.  Note that the operation is commutative
      c = 20.5 + @a
      assert_equal("40.5 50.5 60.5 70.5 ", c.to_string)
      assert_equal(c.type, "double")

      # Can also operate with the number first.  Still doing elementwise operation
      # @c = MDArray.double([4], [1.87, 5.34, 7.18, 8.84])
      c = 10 / @c
      assert_equal("5.347593582887701 1.8726591760299627 1.392757660167131 1.1312217194570136 ",
                   c.to_string)

      # Works with subtraction
      c = 0.5 - @a
      assert_equal("-19.5 -29.5 -39.5 -49.5 ", c.to_string)

      # *TODO: 2.5 ** @a is not working... seems to be a bug, since everything else works
      # fine. Open a case after trying to make a simpler example.
      # c = 2.5 ** @a

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "work with unary operators" do

      result = @c.ceil
      assert_equal(result.to_string, "2.0 6.0 8.0 9.0 ")
      result = result / 4.254
      assert_equal(result.to_string, "0.47014574518100616 1.4104372355430186 1.8805829807240246 2.1156558533145278 ")
      result.floor!
      assert_equal("0.0 1.0 1.0 2.0 ", result.to_string)
      @c.ceil!
      assert_equal("2.0 6.0 8.0 9.0 ", @c.to_string)
 
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "not allow operation between numeric and non-numeric types" do
      
      assert_raise (RuntimeError) { result = @c + @bool1 }
      assert_raise (RuntimeError) { result = @c + "this is a test" }

    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    should "allow users operator's creation" do

      # creating a binary_op as it takes two MDArrays as arguments.  The method "total_sum"
      # will make a cumulative sum of all sums of array1[i] + array2[i].  To achieve this
      # we state that the result is "reduce" (just a number) and that the operation
      # perfomed is the proc given that sums (sum, val1, val2).  The initial value of sum 
      # is given by the second proc Proc.new { 0 }.  This binary operator is defined 
      # for "int" MDArrays and all "lower" classes, i.e., short, byte.
      UserFunction.binary_operator("total_sum", "reduce",
                                   Proc.new { |sum, val1, val2| sum + val1 + val2 }, 
                                   "int", nil, Proc.new { 0 })
      c = @a.total_sum(@b)
      assert_equal(146, c)

      c = @a.total_sum(@c)
      assert_equal(163.23000000000002, c)

      c = @g.total_sum(@h)
      assert_equal(73, c)

      # total_sum is not defined for double MDArray
      assert_raise ( NoMethodError ) { c = @c.total_sum(@b) }


      # define inner_product for the whole hierarchy as it defines it for double
      UserFunction.binary_operator("inner_product", "reduce", 
                                   Proc.new { |sum, val1, val2| sum + (val1 * val2) }, 
                                   "double", nil, Proc.new { 0 })

      c = @a.inner_product(@b)
      assert_equal(260, c)

      c = @a.inner_product(@c)
      assert_equal(926.8, c)

      c = @e.inner_product(@f)
      assert_equal(50079.530999999995, c)

      # same as the inner product but multiplies all values.  Note that in this case
      # we need to initialize prod with value 1, which is done with the second Proc
      UserFunction.binary_operator("proc_proc", "reduce", 
                                   Proc.new { |prod, val1, val2| prod * (val1 * val2) }, 
                                   "double", nil, Proc.new { 1 })
      c = @a.proc_proc(@b)
      assert_equal(0, c)

      c = @a.proc_proc(@c)
      assert_equal(760_572_850.7_520_001, c)


      # Possible to create a new binary operator and force the final type of the resulting
      # MDArray.  Bellow, whenever addd is used the resulting array will be of type double
      func = MDArray.select_function("add")
      UserFunction.binary_operator("addd", "default", func.function, "double", "double")
      
      # @a and @b are int arrays, so result should be int, but since addd is used, resulting
      # array will be double
      c = @a.addd(@b)
      assert_equal("double", c.type)

      # request that resulting array of type int is ignored when using addd
      c = @a.addd(@b, "int")
      assert_equal("double", c.type)

      # Crete method perc_inc and add it into the double MDArray.
      UserFunction.binary_operator("perc_inc", :default, 
                                   Proc.new { |val1, val2| (val2 - val1) / val1 },
                                   "double")

      result = @c.perc_inc @i
      assert_equal("0.06951871657754005 0.12359550561797755 -0.3036211699164345 0.018099547511312233 ", result.to_string)

      # do it in place
      UserFunction.binary_operator("perc_inc!", :in_place, 
                                   Proc.new { |val1, val2| (val2 - val1) / val1 },
                                   "double")

      # "0.06951871514320374 0.1235954761505127 -0.3036211431026459 0.018099529668688774 "

      @c.perc_inc! @i
      assert_equal("0.06951871657754005 0.12359550561797755 -0.3036211699164345 0.018099547511312233 ", @c.to_string)

    end
    
#=end
    
  end


end
