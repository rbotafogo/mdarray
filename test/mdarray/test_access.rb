# -*- coding: utf-8 -*-

##########################################################################################
# Copyright © 2013 Rodrigo Botafogo. All Rights Reserved. Permission to use, copy, modify, 
# and distribute this software and its documentation for educational, research, and 
# not-for-profit purposes, without fee and without a signed licensing agreement, is hereby 
# granted, provided that the above copyright notice, this paragraph and the following two 
# paragraphs appear in all copies, modifications, and distributions. Contact Rodrigo
# Botafogo - rodrigo.a.botafogo@gmail.com for commercial licensing opportunities.
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

  context "Access Tests" do

    setup do

      # create a byte array filled with 0's
      @a = MDArray.byte([2, 3, 4])

      # create double array
      @b = MDArray.double([2, 3, 4])

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "allow data assignment and retrieval" do

      assert_equal(0, @a[1, 2, 3])
      # assign values to a using [] operator
      @a[0, 0, 0] = 10
      @a[0, 1, 2] = 10
      @a[0, 1, 3] = 10
      assert_equal(10, @a[0, 0, 0])
      assert_equal(10, @a[0, 1, 2])
      assert_equal(10, @a[0, 1, 3])
      assert_equal(0, @a[0, 0, 1])

      # assigning a float value to a byte array type will truncate the data
      @a[0, 0, 0] = 1.5
      assert_equal(1, @a[0, 0, 0])

      assert_equal(0.0, @b[1, 1, 1])

      # assign values to b using set method 
      @b.set([1, 1, 1], 5.25)
      assert_equal(5.25, @b.get([1, 1, 1]))

      assert_equal(1, @a.get)
      assert_equal(1, @a.get_as(:int))
      assert_equal(1, @a.get_as(:int, [0, 0, 0]))
      assert_equal(1, @a.get_as(:double, [0, 0, 0]))

      assert_equal(5.25, @b[1, 1, 1])
      assert_raise (RuntimeError) { @b.get_as(:boolean, [1, 1, 1]) }
      assert_equal(5, @b.get_as(:byte, [1, 1, 1]))
      assert_equal(5, @b.get_as(:char, [1, 1, 1]))
      assert_equal(5, @b.get_as(:short, [1, 1, 1]))
      assert_equal(5, @b.get_as(:int, [1, 1, 1]))
      assert_equal(5, @b.get_as(:long, [1, 1, 1]))
      assert_equal(5.25, @b.get_as(:float, [1, 1, 1]))
      assert_equal(5.25, @b.get_as(:object, [1, 1, 1]))

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "generate RuntimeError and RangeError when counter is wrong" do

      # When counter error in [], we get a RuntimeError.
      # RuntimeError... dimension error on b
      assert_raise ( RuntimeError ) { @b[0, 0, 0, 0] = 11.34 }
      # RuntimeError... shape of first dimension too big
      assert_raise ( RuntimeError ) { @b[5, 1, 1] = 7.32 }
      # RangeError... shape of second dimension too big
      assert_raise ( RuntimeError ) { @b[1, 3, 1] = 7.32 }

      # When counter error is in get, we get a RangeError.  Method get is faster than
      # method [] as get does not do any counter validation nor convertion. [] does 
      # counter validation and convertion allowing for the use of negative counter
      # and range.
      assert_raise ( RangeError ) { @b.set([0, 0, 0, 0], 11.34) }
      assert_raise ( RangeError ) { @b.set([5, 1, 1], 7.32) }
      assert_raise ( RangeError ) { @b.set([1, 3, 1], 7.32) }

    end

    #-------------------------------------------------------------------------------------
    # It is possible to use negative indexing by using methods set and get. Indexing with
    # Unlike NumPy, [] does not allow negative indices. Accessing an array with [] is 
    # faster than using get as [] does not require convertion of negative indices to 
    # positive ones.
    #-------------------------------------------------------------------------------------

    should "allow working with negative indices" do

      @b[1, -1, -1] =  4.20
      assert_equal(4.20, @b[1, 2, 3])
      @b[-1, -1, -1] = 10.35

      # using negative indices with set raises an exeption...
      assert_raise ( RangeError ) { @b.set([-1, -1, -1], 11.40) }
      # but works with []
      assert_equal(10.35, @b[-1, -1, -1])
      assert_equal(@b[-1, -1, -1], 10.35)

      # using negative indices with get raises an exeption
      assert_raise ( RangeError ) { @b.get([-1, -1, -1]) }
      assert_equal(10.35, @b[1, 2, 3])

      # RuntimeError... shape of first dimension too big (on the negative side)
      assert_raise ( RangeError ) { @b.set([-5, 1, 1], 7.32) }
      # RuntimeError... shape of second dimension too big (on the negative side)
      assert_raise ( RangeError ) { @b.set([1, -4, 1], 7.32) }

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "output data in string format" do
      
      a = MDArray.arange(10)
      assert_equal("0 1 2 3 4 5 6 7 8 9 ", a.to_string)

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "allow array traversal in cannonical order" do

      a = MDArray.arange(10)

      # set the value at the current index position. Raise an exception as there
      # is no currently defined position.  Note that a[] refers to the current counter
      # position
      assert_raise ( RuntimeError ) { a[] = 18.25 }

      # gets the value at the current index position.  Raises an exception as 
      # current position not defined
      assert_raise ( RuntimeError) { a[] }

      # reset_traversal initializes the traversal, but leaves the counter in an invalid
      # position
      a.reset_traversal
      # move to the first position
      a.next
      assert_equal(0, a[])
      # sets the value at the current position.  No need to give the counter.
      a[] = 10
      assert_equal(10, a[])
      # move to the next position
      a.next
      assert_equal(1, a[])
      # get_next returns the next position and moves the counter. Method get_next and
      # set_next are "fast" methods in the sense that they do not require any counter
      # correction.
      assert_equal(2, a.get_next)
      assert_equal(2, a[])
      assert_equal(3, a.get_next)
      assert_equal(4, a.get_next)

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "allow array traversal using each like methods" do

      a = MDArray.arange(10)

      counter = 0

      a.each do |elmt|
        assert_equal(counter, elmt)
        counter += 1
      end

      a.reset_traversal
      a.next
      assert_equal(0, a[])

      # continues the each from where the counter stoped previously
      counter = 1
      a.each_cont do |elmt|
        assert_equal(counter, elmt)
        counter += 1
      end
      
      # each_with_counter returns the elmt and it's index
      a.reshape!([5, 2])
      counter = 0
      a.each_with_index do |elmt, index|
        assert_equal(counter, elmt)
        counter += 1
      end

      # Collect returns a one dimensional ruby array
      b = a.collect { |val| val * 2}

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------
=begin
    should "traverse the array over given axes" do

      @b.each_over_axes([0]) do |elmt|
        p elmt
      end

    end
=end
    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "have the right precision for the type" do

      b = MDArray.float([2, 3], [0, 1, 2, 3, 4, 5])
      assert_equal(1.0, b[0, 1])

      # float should work with 1 decimal precision
      b[0, 1] = 1.5
      assert_equal(1.5, b[0, 1])

      c = MDArray.build("double", [2, 3], [0, 1, 2, 3, 4, 5])
      c[0, 0] = 1.51
      assert_equal(1.51, c[0, 0])

    end

  end
  
end
