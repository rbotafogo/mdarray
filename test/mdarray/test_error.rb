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
      @bool = MDArray.boolean([4], [true, true, false, false])

      @trig = MDArray.typed_arange("double", 90)
      @long = MDArray.typed_arange("long", 5)
            
    end # setup

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "correct error!" do

      arr = MDArray.double("VALE3_short.csv", true)
      arr.print

      arr = MDArray.float("VALE3_short.csv", true)
      arr.print

      arr = MDArray.int("VALE3_short.csv", true)
      arr.print

    end
    
  end

end
