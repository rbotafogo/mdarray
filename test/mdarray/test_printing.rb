require 'rubygems'
require "test/unit"
require 'shoulda'

require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "Printing Tests" do

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
      @f = MDArray.fromfunction("double", [2, 2, 2, 2]) do |x, y, z, w|
        9.57 * x + y + z + w
      end
      @g = MDArray.fromfunction("double", [3, 2, 3, 2, 3]) do |x, y, z, w, k|
        9.57 * x + y + z + w + k
      end
            
    end # setup
    
    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "print 1D array" do
      @a.print
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------
    
    should "print nD array" do
      @d.print
      @e.print
      @f.print
      @g.print
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "print output to csv" do
      @e.to_csv
    end

  end

end
