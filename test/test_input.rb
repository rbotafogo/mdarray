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

require_relative 'env'

require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "Input Tests" do

    setup do

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "read data" do
      
      array = Csv.read("VALE3.csv")
      # array.print

      
      slice = array.slice(1,1)

      slice.reset_statistics
      p "======Examine the opening price======"
      p "mean: #{slice.mean}"
      p "max: #{slice.max}"
      p "min: #{slice.min}"
      p "stdv: #{slice.standard_deviation}"
      p "kurtosis: #{slice.kurtosis}"
      p "median: #{slice.median}"


      slice = array.slice(1,2)

      slice.reset_statistics
      p "======Examine the closing price======"
      p "mean: #{slice.mean}"
      p "max: #{slice.max}"
      p "min: #{slice.min}"
      p "stdv: #{slice.standard_deviation}"
      p "kurtosis: #{slice.kurtosis}"
      p "median: #{slice.median}"

    end

  end

end
