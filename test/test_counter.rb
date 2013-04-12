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
  
  context "Building blocks" do
    
    setup do

      # creates an array from a function (actually a block).  The name fromfunction
      # is preserved to maintain API compatibility with NumPy (is it necessary?)

      # Testing for the financial market.  We have 5 values (open, high, low, close, volume)
      # 3 securities, each with 60 working days, for 2 years. For those
      # parameters we need to change the Java heap size.
      @a = MDArray.fromfunction("double", [2, 60, 3, 5]) do |x, y, z, k|
        x + y + z + k
      end

      @b = MDArray.int([2, 2])

      # can get counter by either calling get_counter on the array, or Counter.new passing 
      # the array

    end # setup

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "allow random access to elements through counters" do

      counter = MDArray::Counter.new(@a)
      # access the array element by indexing the array with the index
      assert_equal(1 + 1 + 2 + 2, counter.get([1, 1, 2, 2]))
      # access the array element by indexing the array with the index
      assert_equal(1 + 1 + 2 + 2, counter[1, 1, 2, 2])
      # can use negative values for counters
      assert_equal(1 + 1 + 2 + 2, counter[-1, 1, -1, 2])

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "do proper counter checking" do

      counter = MDArray::Counter.new(@a)

      # When using get, counter is check against shape.  If not compatible, raises a 
      # runtime error
      assert_raise ( RangeError ) { counter.get([1, 2, 5, 2]) }
      # When usign [], counter is not check against shape.  This is faster access.
      # When not compatible, will get a RangeError.
      assert_raise ( RuntimeError ) { counter[1, 2, 5, 2] }
      assert_raise ( RuntimeError ) { counter[1, 2] }


    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "walk the index in cannonical order" do

      # canonical access using index.  The use of index for cannonical order walking
      # is probably slower than using access directly through the array, as the
      # example bellow
      counter = MDArray::Counter.new(@a)

      counter.each do |elmt|
        # access the array element by indexing the array with get method
        assert_equal(elmt[0] + elmt[1] + elmt[2] + elmt[3], @a.get(elmt))
        # access the array element by indexing the array with []. Need to use
        # *elmt as elmt is an array
        assert_equal(elmt[0] + elmt[1] + elmt[2] + elmt[3], @a[*elmt])
        # access the array element directly through the index
        assert_equal(elmt[0] + elmt[1] + elmt[2] + elmt[3], counter.get_current)
      end
      
      # cannonical access using direct access through the array
      @a.each_with_counter do |elmt, index|
        assert_equal(index[0] + index[1] + index[2] + index[3], elmt)
      end
      
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "allow access through axes" do

      counter = MDArray::Counter.new(@a)
      counter.each_along_axes([0, 2]) do |counter|
        counter
      end

      counter.each_along_axes([0, 1, 2]) do |counter|
        counter
      end

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------
    
  end
  
end

=begin
    should "allow partial access to the array" do

      index = MDArray::Index.new(@a)

      index.set_start([1, 1, 1, 1])
      assert_raise ( RuntimeError ) { index.set_finish([0, 1, 0, 0]) }
      assert_raise ( RuntimeError ) { index.set_finish([1, 1, 0, 0]) }

      index.set_finish([1, 1, 1, 1])
      index.each do |elmt|
        assert_equal([1, 1, 1, 1], elmt)
      end

      index.set_start([0, 1, 2, 2])
      index.set_finish([1, 1, 1, 2])

      index.each do |elmt|
        # access the array element directly through the index
        # p index.counter
        assert_equal(elmt[0] + elmt[1] + elmt[2] + elmt[3], index.get_current)
      end

      index.each_along_axes([0, 2, 3]) do |counter|
        p counter
      end

    end
=end
