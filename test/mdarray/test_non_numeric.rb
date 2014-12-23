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

require_relative '../env'
require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "Non-numeric Array Creation" do

    #-------------------------------------------------------------------------------------
    # array creation always requires the type and shape, differently from NumPy 
    # narray in which the type and shape can be inferred from the initialization
    # data.  MDArray can be numerical and non-numerical.  Numerical MDArrays can be of 
    # type: byte, short, int, long, double.  Non-numerical MDArrays can be of type
    # boolean, char, string.
    #-------------------------------------------------------------------------------------

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
      sarray.print

      sarray2 = MDArray.string([], ["hello, this is a string array"])
      p sarray2.shape
      sarray2.print

      sarray3 = MDArray.string([3], 
                               ["No pairs of ladies stockings!",
                                "One pair of ladies stockings!",
                                "Two pairs of ladies stockings!"])
      p sarray3.shape
      sarray3.print

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

  end

end
