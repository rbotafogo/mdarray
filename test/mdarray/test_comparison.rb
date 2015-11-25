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

require '../../config' if @platform == nil
require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "Comparison Tests" do

    setup do

      # create a = [20 30 40 50]
      @a = MDArray.arange(20, 60, 10)
      # create b = [0 1 2 3]
      @b = MDArray.arange(4)
      # create c = [1.87 5.34 7.18 8.84]
      @c = MDArray.double([4], [1.87, 5.34, 40.18, 84.84])
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
      @g = MDArray.boolean([4], [true, true, true, false])

    end # setup

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "compare elementwise" do

      result = @a > 30
      assert_equal("false false true true ", result.to_string)
      
      result = @a > @b
      assert_equal("true true true true ", result.to_string)

      result = @a > @c
      assert_equal("true true false false ", result.to_string)

      result = @c < @a
      assert_equal("true true false false ", result.to_string)

      result = @c == @c
      assert_equal("true true true true ", result.to_string)

      result = @a.ge(30)
      assert_equal(result[0], false)
      assert_equal(result[1], true)

      # also works with logical operators
      c = @a > 20.5
      assert_equal("false true true true ", c.to_string)

      # TODO: assert_equal
      result = @a.le(30)

      # TODO: assert_equal
      result = @e.le(15)

      # TODO: assert_equal
      result = @e.le(@f)

      # TODO: assert_equal
      result = @a >= 30.5

      # TODO: assert_equal
      result = @a <= @a

      # TODO: assert_equal
      result = @e < @f

      # TODO: assert_equal
      result = @f > @e

      assert_raise ( NoMethodError ) { result = @g < @g }

    end
    
    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "allow coercion on comparison" do

      result = 30.001 > @a
      assert_equal("true true false false ", result.to_string)

      c = 25 > @a
      assert_equal("true false false false ", c.to_string)

    end

  end
  
end


