require 'rubygems'
require "test/unit"
require 'shoulda'

require '../../config' if @platform == nil
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
      @g = MDArray.byte([1], [60])
      @h = MDArray.byte([1], [13])
      @i = MDArray.double([4], [2.0, 6.0, 5.0, 9.0])

      @bool1 = MDArray.boolean([4], [true, false, true, false])
      @bool2 = MDArray.boolean([4], [false, false, true, true])
      
    end # setup

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------
    
    should "correct error!" do

      # define inner_product for the whole hierarchy as it defines it for double
      UserFunction.binary_operator("inner_product", "reduce", 
                                   Proc.new { |sum, val1, val2| sum + (val1 * val2) }, 
                                   "double", nil, Proc.new { 0 })

      c = @a.inner_product(@c)
      assert_equal(926.8, c)

    end
    
  end

end
