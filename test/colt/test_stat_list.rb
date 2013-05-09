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

      # Creates a DoubleStatList of size 10
      @list = DoubleStatList.new(10)

      @list.add(2.25)
      @list.add(5.0)

      @list.print

      p @list[0]
      p @list[1]
      p @list.mean

      # Search for element in the list
      p "binary search"
      p @list.binary_search(5)
      
      p @list.index_of(5.0)

      p @list.last_index_of(5.0)

      @list.shuffle
      @list.print

      list2 = @list.copy
      
      @list.print
      list2.print

      # changing the value of @list
      @list[0] = 10
      @list.print

      # list2 is unchanged
      list2.print

      # mean is now wrong... we've added an element to the list
      p @list.mean
      # to make it right we need to reset_statistics.  Whenever an element on the 
      # list is changed it is required to call reset_statistics
      @list.reset_statistics
      p @list.mean




      # Creates a DoubleStatList with given initial capacity
      @list = DoubleStatList.new(20)
      p @list.elements

      @list.trim_to_size
      p @list.elements



    end
    
  end

end
