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

require_relative '../env.rb'

require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "CSV Dimensions" do

    setup do

    end
    
    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------
#=begin
    should "Control one dimension" do

      p "smaller dimension"
      
      dimension = Csv::Dimension.new
      dimension.add_label("L1")
      assert_equal(0, dimension.add_label("L1"))
      assert_equal(0, dimension.add_label("L1"))
      dimension.add_label("L2")
      dimension.add_label("L3")
      p dimension.labels

      assert_equal(0, dimension.add_label("L1"))
      assert_equal(1, dimension.add_label("L2"))

      # dimension is frozen and we cannot add new label to it
      assert_raise (RuntimeError) { dimension.add_label("L4") }
      
      assert_equal(2, dimension.add_label("L3"))

      # dimension is frozen and order is now important.  Cannot go to label L2 without
      # first going to label L1
      assert_raise (RuntimeError) { dimension.add_label("L2") }

      assert_equal(0, dimension.add_label("L1"))
      assert_equal(0, dimension.add_label("L1"))
      assert_equal(0, dimension.add_label("L1"))
      assert_equal(1, dimension.add_label("L2"))
      assert_equal(1, dimension.add_label("L2"))
      
    end
#=end
    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "Control one dimension larger" do

      p "larger dimension"
      
      dimension = Csv::Dimension.new
      dimension.add_label("L1")
      assert_equal(0, dimension.add_label("L1"))
      assert_equal(0, dimension.add_label("L1"))
      dimension.add_label("L2")
      dimension.add_label("L3")
      assert_equal(2, dimension.add_label("L3"))
      dimension.add_label("L4")
      assert_raise (RuntimeError) { dimension.add_label("L2") }
      dimension.add_label("L5")
      p dimension.labels

      assert_equal(0, dimension.add_label("L1"))
      assert_equal(1, dimension.add_label("L2"))

      # dimension is frozen and we cannot add new label to it
      assert_raise (RuntimeError) { dimension.add_label("L4") }
      assert_raise (RuntimeError) { dimension.add_label("L6") }
      
      assert_equal(2, dimension.add_label("L3"))

      # dimension is frozen and order is now important.  Cannot go to label L2 without
      # first going to label L1
      assert_raise (RuntimeError) { dimension.add_label("L2") }

      assert_equal(0, dimension.add_label("L1"))
      assert_equal(0, dimension.add_label("L1"))
      assert_equal(0, dimension.add_label("L1"))
      assert_equal(1, dimension.add_label("L2"))
      assert_equal(1, dimension.add_label("L2"))
      
    end
    
  end

end
