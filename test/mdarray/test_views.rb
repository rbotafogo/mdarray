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

  context "Slice Tests" do

    setup do
      
      # creates an array from a function (actually a block).  The name fromfunction
      # is preserved to maintain API compatibility with NumPy (is it necessary?)

      # simulating financial data: 1 year, 20 days, 10 securities, 7 values (open, 
      # close, high, low, volume, e1, e2)
      @a = MDArray.fromfunction("double", [1, 20, 10, 7]) do |x, y, z, k|
        0.5 * x + y + 10 * (z + 1) + Math.sin(k + x)
      end

      @b = MDArray.int([2, 2])
      @c = MDArray.fromfunction("double", [2, 3, 4]) do |x, y, z|
        x + y + z
      end
      
    end

    #-------------------------------------------------------------------------------------
    # Create a new Array using same backing store as this Array, by fixing the specified 
    # dimension at the specified index value. This reduces rank by 1.
    #-------------------------------------------------------------------------------------

    should "slice an array" do

      # @c rank is [2, 3, 4]. @c is the following array
      # [[[0.00 1.00 2.00 3.00]
      #  [1.00 2.00 3.00 4.00]
      #  [2.00 3.00 4.00 5.00]]
      # 
      # [[1.00 2.00 3.00 4.00]
      #  [2.00 3.00 4.00 5.00]
      #  [3.00 4.00 5.00 6.00]]]
      
      # take a slice of c on the first dimension (0) and taking only the first (0) index,
      # we should get the following array:
      # [[0.00 1.00 2.00 3.00]
      #  [1.00 2.00 3.00 4.00]
      #  [2.00 3.00 4.00 5.00]]
      arr = @c.slice(0, 0)
      assert_equal(1, arr[0, 1])
      assert_equal(4, arr[2, 2])
      assert_equal(5, arr[2, 3])

      # take a slice of c on the first dimension (0) and taking only the second (1) index,
      # we should get the following array:
      # [[1.00 2.00 3.00 4.00]
      #  [2.00 3.00 4.00 5.00]
      #  [3.00 4.00 5.00 6.00]]
      arr = @c.slice(0, 1)
      assert_equal(2, arr[0, 1])
      assert_equal(4, arr[0, 3])
      assert_equal(5, arr[1, 3])

      # take a slice of c on the second dimension (1) and taking only the second (1) index,
      # we should get the following array:
      # [[1.00 2.00 3.00 4.00]
      #  [2.00 3.00 4.00 5.00]]
      arr = @c.slice(1, 1)
      assert_equal(2, arr[0, 1])
      assert_equal(2, arr[1, 0])

      # take a slice of c on the third dimension (2) and taking only the third (2) index,
      # we should get the following array:
      # [[2.00 3.00 4.00]
      #  [3.00 4.00 5.00]]
      arr = @c.slice(2, 2)
      assert_equal(3, arr[0, 1])
      assert_equal(5, arr[1, 2])

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------
  
    should "get array section" do

      # 1 -> first year (only 1 year)
      # 20 -> 20 days
      # 10 -> number os secs
      # 7 - > number of values
      
      # b is a section of @a, starting at position (0) and taking only the first two 
      # elements of the first dimension.  Getting all values, for all secs for the first
      # 2 days
      b = @a.section([0, 0, 0, 0], [1, 2, 10, 7])
      assert_equal(true, b.section?)
      assert_equal([1, 2, 10, 7], b.shape)
      ind = b.get_index
      ind.each do |elmt|
        assert_equal(@a.get(elmt), b.get(elmt))
      end
      
      # getting "open" for the first 2 days of the 2nd sec.  Values are organized
      # as follows:
      # (open, close, high, low, volume, e1, e2).
      # Start at: [0, 0, 3, 0] => 
      #   0 -> first year, 0 -> first day, 3 -> 2nd sec, 0 -> first value 
      # Specification: [1, 2, 1, 1] =>
      #   1 -> get only first year, 2 -> take 2 days from day 0 to day 1, 
      #   1 -> take one security, already selected the 2nd one, 1 -> only one value
      #   in this case the first one was selected.
      b = @a.section([0, 0, 3, 0], [1, 2, 1, 1])
      assert_equal(40.00, b[0, 0, 0, 0])
      assert_equal(41.00, b[0, 1, 0, 0])

      # getting "close" (2nd) value of the 3rd sec for the second day with 
      # shape reduction. Note that in this case, with shape reduction, b is a 
      # number and not an array any more
      b = @a.section([0, 1, 2, 1], [1, 1, 1, 1], true)
      assert_equal(@a[0, 1, 2, 1], b)

      # getting the "close" (2nd) value of the 3rd sec for the second day without
      # shape reduction
      b = @a.section([0, 1, 2, 1], [1, 1, 1, 1])
      assert_equal([1, 1, 1, 1], b.shape)
      assert_equal(@a[0, 1, 2, 1], b[0, 0, 0, 0])

      # getting the "open" (1rst) value of the second secs for two days
      b = @a.section([0, 0, 0, 0], [1, 2, 1, 1])
      assert_equal([1, 2, 1, 1], b.shape)
      assert_equal(@a[0, 0, 0, 0], b[0, 0, 0, 0])
      assert_equal(@a[0, 1, 0, 0], b[0, 1, 0, 0])

      # getting the "open" (1rst) value of the second secs for two days with rank
      # reduction
      b = @a.section([0, 0, 0, 0], [1, 2, 1, 1], true)
      assert_equal([2], b.shape)
      assert_equal(@a[0, 0, 0, 0], b[0])
      assert_equal(@a[0, 1, 0, 0], b[1])

      # getting the first security, all values
      b = @a.section([0, 0, 0, 0], [1, 1, 1, 7])
      # b.print

      # getting the 2 security, all values
      b = @a.section([0, 0, 1, 0], [1, 1, 1, 7])
      # b.print

      # getting the 1 day, all then secs
      b = @a.section([0, 0, 0, 0], [1, 1, 10, 7])
      # b.print

      # getting the "open" (1st) value of all secs for the first day
      b = @a.section([0, 0, 0, 0], [1, 1, 10, 1])
      # b.print

    end
    
    #-------------------------------------------------------------------------------------
    # Regions and sections are the same functionality with a different interface
    #-------------------------------------------------------------------------------------
  
    should "get array regions" do

      # 1 -> first year (only 1 year)
      # 20 -> 20 days
      # 10 -> number os secs
      # 7 - > number of values
      
      # b is a section of @a, starting at position (0) and taking only the first two 
      # elements of the first dimension.  Getting all values, for all secs for the first
      # 2 days
      # b = @a.section([0, 0, 0, 0], [1, 2, 10, 7])
      b = @a.region(:spec => "0:0, 0:1, 0:9, 0:6")
      assert_equal(true, b.section?)
      assert_equal([1, 2, 10, 7], b.shape)
      ind = b.get_index
      ind.each do |elmt|
        assert_equal(@a.get(elmt), b.get(elmt))
      end


      # getting "open" for the first 2 days of the 2nd sec.  Values are organized
      # as follows:
      # (open, close, high, low, volume, e1, e2).
      # Start at: [0, 0, 3, 0] => 
      #   0 -> first year, 0 -> first day, 3 -> 2nd sec, 0 -> first value 
      # Specification: [1, 2, 1, 1] =>
      #   1 -> get only first year, 2 -> take 2 days from day 0 to day 1, 
      #   1 -> take one security, already selected the 2nd one, 1 -> only one value
      #   in this case the first one was selected.
      # b = @a.section([0, 0, 3, 0], [1, 2, 1, 1])
      b = @a.region(:spec => "0:0, 0:1, 3:3, 0:0")
      assert_equal(40.00, b[0, 0, 0, 0])
      assert_equal(41.00, b[0, 1, 0, 0])


      # getting "close" (2nd) value of the 3rd sec for the second day with 
      # shape reduction. Note that in this case, with shape reduction, b is a 
      # number and not an array any more
      # b = @a.section([0, 1, 2, 1], [1, 1, 1, 1], true)
      b = @a.region(:origin => [0, 1, 2, 1], :shape => [1, 1, 1, 1], :reduce => true)
      assert_equal(@a[0, 1, 2, 1], b)

      # getting the "close" (2nd) value of the 3rd sec for the second day without
      # shape reduction
      # b = @a.section([0, 1, 2, 1], [1, 1, 1, 1])
      b = @a.region(:origin => [0, 1, 2, 1], :size => [1, 1, 1, 1], :stride => [1, 1, 1, 1])
      assert_equal([1, 1, 1, 1], b.shape)
      assert_equal(@a[0, 1, 2, 1], b[0, 0, 0, 0])

    end

    #-------------------------------------------------------------------------------------
    # each_along_axes returns sub-arrays (sections) of the original array. Each section
    # is taken by walking along the given axis and getting all elements of the
    # axis that were not given.
    #-------------------------------------------------------------------------------------

    should "split array in subarrays with or without reduction" do

      # 1 -> first year (only 1 year)
      # 20 -> 20 days
      # 10 -> number os secs
      # 7 - > number of values

      # Should generate 1 array with all elements, since the first dimension has only 
      # one element.  For this test cannot reduce the array as this would have @a and 
      # slice have different dimensions
      @a.each_slice([0], false) do |slice|
        slice.each_with_counter do |value, counter|
          assert_equal(value, @a.get(counter))
        end
      end
 
      # Should generate 20 arrays one for each day.  Since slice uses the same backing
      # store as @a, there isn't much of memory waist.
      arrays = Array.new
      @a.each_slice([1]) do |slice|
        arrays << slice
      end
      
      arrays[0].reset_traversal
      @a.slice(1, 0).each do |val|
        assert_equal(val, arrays[0].get_next)
      end

      # Should generate 10 arrays one for each security
      arrays.clear
      @a.each_slice([2]) do |slice|
        arrays << slice
      end

      arrays[6].reset_traversal
      @a.slice(2, 6).each do |val|
        assert_equal(val, arrays[6].get_next)
      end

      # For instance, array @a shape is [1, 20, 10, 7].  Slicing along the fourth axes
      # (index 3) will get the following sections of @a:
      # section([0, 0, 0, 0], [1, 20, 10, 1], true), 
      #   section([0, 0, 0, 1], [1, 20, 10, 1], true),
      #   section([0, 0, 0, 2], [1, 20, 10, 1], true),
      #   ...
      #   section([0, 0, 0, 6], [1, 20, 10, 1], true),
      
      # In this case, we get 7 arrays.  First for all opens, sencond for all closes,
      #  third for all highs, fourth for all closes, etc.
      arrays.clear
      @a.each_slice([3]) do |slice|
        arrays << slice
      end
      assert_equal(7, arrays.size)


      # Although method slice only slices on one dimension, we can each_slice on multiple
      # dimensions

      # For instance, array @a shape is [1, 20, 10, 7].  Slicing
      # along axes [1, 2] will generate 200 arrays = 20 * 10. 20 days times 10 secs. In this
      # case we will have one array for every day and every securities quote (open, close, etc.)
      arrays.clear
      @a.each_slice([1, 2]) do |slice|
        arrays << slice
      end

      # We can get the equivalent of arrays[0] above by doing the following set of operations
      # @a.slice(1,0);
      # now slice it again at (1, 0), since now the second dimension has become the first
      # reduce the array so that only 1 dimension is left
      assert_equal(arrays[0].to_string, @a.slice(1, 0).slice(1, 0).reduce.to_string)


      # Changing the order of axis in the parameter list does change the final result as 
      # each_slice moves first the last axis in the array given.  In this example, it will
      # first increment axis 1 and then axis 2.  On the prvious example, axis 2 was
      # incremented prior to axis 1.
      arr2 = Array.new
      @a.each_slice([2, 1]) do |slice|
        arr2 << slice
      end

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "permute array indices" do

      # c shape is [2, 3, 4]
      # b is the same array as c... no permutation was done.
      # b shape still is [2, 3, 4].  Both b and @c point to the same backing store
      b = @c.permute([0, 1, 2])
      assert_equal([2, 3, 4], b.shape)
      # b shape is now [3, 2, 4]
      b = @c.permute([1, 0, 2])
      assert_equal([3, 2, 4], b.shape)
      # b shape is now [3, 4, 2]
      b = @c.permute([1, 2, 0])
      assert_equal([3, 4, 2], b.shape)

    end

    #-------------------------------------------------------------------------------------
    # Creates views of an array by transposing original arrays dimensions.  Uses the same
    # backing store as the original array.
    #-------------------------------------------------------------------------------------

    should "transpose array indices" do

      # c shape is [2, 3, 4]
      # b shape is now [3, 2, 4] by transposing the first two dimensions
      b = @c.transpose(0, 1)
      assert_equal([3, 2, 4], b.shape)

      # b shape is now [2, 4, 3]
      b = @c.transpose(1, 2)
      assert_equal([2, 4, 3], b.shape)

    end

  end

end
