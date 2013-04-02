require 'rubygems'
require "test/unit"
require 'shoulda'

require 'env'
require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "Arithmetic Tests" do

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
      @f = MDArray.fromfunction("double", [4, 5, 6]) do |x, y, z|
        9.57 * x + y + z
      end

      @bool1 = MDArray.boolean([4], [true, false, true, false])
      @bool2 = MDArray.boolean([4], [false, false, true, true])
            
    end # setup

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "work with boolean arrays and operators" do

      # elementwise boolean operations supported
      result = @bool1.and(@bool2)
      assert_equal("false false true false ", result.to_string)

      result = @bool2.and(@bool1)
      assert_equal("false false true false ", result.to_string)

      # Cannot overload and, so using & as an alias to and
      result = @bool1 & @bool2
      assert_equal("false false true false ", result.to_string)

      result = @bool2.or(@bool1)
      assert_equal("true false true true ", result.to_string)

      # Cannot overload or, so using | as an alias to or
      result = @bool2 | @bool1
      assert_equal("true false true true ", result.to_string)

      #result = !@bool1
      #assert_equal("false true false true ", result.to_string)
      
    end

  end

end
