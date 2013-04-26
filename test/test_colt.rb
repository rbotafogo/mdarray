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

require_relative 'env.rb'

require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "Parrallel Colt Integration" do

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
      @f = MDArray.fromfunction("double", [100, 100, 100]) do |x, y, z|
        9.57 * x + y + z
      end
      @g = MDArray.byte([1], [60])
      @h = MDArray.byte([1], [13])
      @i = MDArray.double([4], [2.0, 6.0, 5.0, 9.0])

      @bool1 = MDArray.boolean([4], [true, false, true, false])
      @bool2 = MDArray.boolean([4], [false, false, true, true])

    end # setup

    #-------------------------------------------------------------------------------------
    # array creation always requires the type and shape, differently from NumPy 
    # narray in which the type and shape can be inferred from the initialization
    # data.  MDArray can be numerical and non-numerical.  Numerical MDArrays can be of 
    # type: byte, short, int, long, double.  Non-numerical MDArrays can be of type
    # boolean, char, string.
    #-------------------------------------------------------------------------------------

    should "convert array to double list" do

      @e.reset_statistics
      res = @e.frequencies
      p res[:distinct_values]
      p res[:frequencies]

      p @e.median

      @f.reset_statistics

      p @f.kurtosis
      p @f.mean
      p @f.standard_deviation
      p @f.variance

      p @f.auto_correlation(5)

      p @f.durbin_watson
      p @f.geometric_mean
      p @f.mean
      p @f.standard_deviation
      p @f.kurtosis
      p @f.lag1
      p @f.max
      p @f.mean_deviation
      p @f.min
      p @f.moment(2, 0.5)
      p @f.product

    end

  end

end
