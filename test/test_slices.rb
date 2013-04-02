require 'rubygems'
require "test/unit"
require 'shoulda'

require 'env'
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
      
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------
=begin
    should "get section with range" do

      @b[/1:2:3/, /1:5/, /3:4/, 1]

    end
=end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "slice array along axes" do

      @a.each_along_axes([3]) do |slice|
        slice.print
        print "\n"
      end

      # each_along_axes returns sub-arrays (sections) of the original array. Each section
      # is taken by walking along the given axis and getting the all elements of the
      # axis that were not given.  For instance, array @a shape is [1, 20, 10, 7].  Slicing
      # along axes [0, 2] will get the following sections of @a: 
      # section([0, 0, 0, 0], [1, 20, 1, 7]), section ([0, 0, 1, 0], [1, 20, 1, 7]),
      # section([0, 0, 2, 0], [1, 20, 1, 7])...
      # This is actually getting all values for every security for the 20 days.

      @a.each_along_axes([0, 2]) do |slice|
        slice.print
        p slice.cum_op(MDArray.method(:add))
        print "\n"
      end

      # Here we are getting 7 arrays for "open", "close", "High", "Low", etc. each
      # containing all the 20 days for each security.  So, the first array has 20 elements
      # each with the "open" value for the first security. The second array returns 
      # has 20 elements, each with the "close" value for the first security.
      @a.each_along_axes([2, 3]) do |slice|
        slice.print
        print "\n"
      end

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------
  
    should "get array section" do

      # 1 -> first year (only 1 year)
      # 20 -> 20 days
      # 10 -> number os secs
      # 7 - > number of values

      # b is a section of @a, starting a position (0) and taking only the first two 
      # elements of the first dimension.  Getting all values, for all secs for the first
      # 2 days
      b = @a.section([0, 0, 0, 0], [1, 2, 10, 7])
      assert_equal(true, b.section?)
      assert_equal([1, 2, 10, 7], b.shape)
      ind = b.get_index
      ind.each do |elmt|
        assert_equal(@a.get(elmt), b.get(elmt))
      end

      # getting "open" for the first 2 days of the 3rd sec 
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
    
  end
  
end
