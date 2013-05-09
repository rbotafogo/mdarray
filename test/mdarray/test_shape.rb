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

  context "Shape Manipulation" do

    setup do 

      # create an int array with 15 elements and 1 dimension
      # [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14]
      @a = MDArray.arange(15)
      assert_equal([15], @a.shape)
      assert_equal(1, @a.ndim)
      assert_equal(1, @a.rank)
      assert_equal(15, @a.size)
      assert_equal("int", @a.dtype)

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "allow getting a section from an array" do

      b = @a.reshape([3, 5])
      c = b.section([0, 0], [3, 1])
      # c.print
      c = b.section([0, 1], [3, 1])
      # c.print
      c = b.section([0, 2], [3, 1])
      # c.print

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "allow array reshaping" do

      # reshape the array in place
      # [[0 1 2 3 4]
      # [5 6 7 8 9]
      # [10 11 12 13 14]]
      @a.reshape!([3, 5])
      assert_equal(2, @a.ndim)
      assert_equal([3, 5], @a.shape)
      assert_equal(0, @a[0, 0])
      assert_equal(5, @a[1, 0])
      assert_equal(12, @a[2, 2])
      assert_raise ( RuntimeError ) { @a[3, 4] }
      
      # reshape the array without copy
      b = @a.reshape([15])
      b[0] = 15
      assert_equal(15, b[0])
      assert_equal(15, @a[0, 0])

      # reshape the array with copy
      c = b.reshape([3, 5], true)
      assert_equal(15, c[0, 0])
      c[0, 1] = 20
      assert_equal(20, c[0, 1])
      assert_equal(1, b[1])

    end

  end

end
