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

  context "Parrallel Colt Integration" do

    setup do
            
    end # setup

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "work with stat_lists" do

      # Creates a DoubleStatList of capacity 10
      @list = DoubleStatList.new(10)

      @list.add(2.25)
      @list.add(5.0)

      assert_equal(2.25, @list[0])
      assert_equal(5.0, @list[1])
      assert_equal(3.625, @list.mean)

      # Search for element in the list
      assert_equal(1, @list.binary_search(5))
      assert_equal(1, @list.index_of(5.0))

      @list.add(3.0)
      @list.add(5.0)
      
      assert_equal(3, @list.last_index_of(5.0))

      list2 = @list.copy
      # changing the value of @list
      @list[0] = 10
      assert_equal(10, @list[0])
      # list2 is unchanged
      assert_equal(2.25, list2[0])

      @list.shuffle
      @list.print

      # mean is now wrong... we've added/changed elements in @list, but we still get the
      assert_equal(3.625, @list.mean)

      # to make it right we need to reset_statistics.  Whenever an element on the 
      # list is changed it is required to call reset_statistics
      @list.reset_statistics
      assert_equal(5.75, @list.mean)

    end
    
    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "be memory efficient when possible" do

      # read file VALE3.  This file has a header that we need to discard.  VALE3 
      # contains quote values from brazilian company VALE as obtained from Yahoo finance
      # (quote vale3.SA)
      vale3 = MDArray.double("#{$COLT_TEST_DIR}/VALE3_short.csv", true)

      # calling reset_statistics on vale3, creates a stat_list for vale3
      vale3.reset_statistics

      # get vale3 stat_list.  This should not copy any data... let's check it
      list = vale3.stat_list
      
      # let's change a value in list
      list[0] = 10
      assert_equal(10, list[0])
      assert_equal(10, vale3[0, 0])

      # Getting the open value
      open = vale3.slice(1, 1)
      
      # open and vale3 should use the same backing store
      open[0] = 5
      assert_equal(5, open[0])
      assert_equal(5, vale3[0,1])

      # now... doing reset_statistics on open will not use the same backing store
      # as open is not contigous in memory and copying is necessary.  This is the
      # cost integrating NetCDF and Parallel Colt.  It might actually be a good 
      # idea in some cases to make a copy and operate on contigous memory than using
      # indexing to move over the array.
      open.reset_statistics
      open_list = open.stat_list
      open_list[0] = 1000
      assert_equal(1000, open_list[0])
      assert_equal(5, open[0])

      

    end
    
  end
  
end
