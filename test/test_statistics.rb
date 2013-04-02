require 'rubygems'
require "test/unit"
require 'shoulda'

require 'env'
require 'mdarray'
require 'benchmark'

class MDArrayTest < Test::Unit::TestCase

  context "Statistics Tests" do

    setup do

      # create a byte array filled with 0's
      @a = MDArray.typed_arange("double", 10_000)
      @weight = MDArray.arange(10_000)

      # create double array
      @b = MDArray.double([2, 3, 4])

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "do stats operations" do

      # @a.unary_operator = FastUnaryOperator
      assert_equal(49995000, @a.sum)
      assert_equal(0, @a.min)
      assert_equal(9999, @a.max)
      assert_equal(4999.5, @a.mean)

      # @a.binary_operator = BinaryOperator
      puts Benchmark.measure {
        assert_equal(6666.333333333333, @a.weighted_mean(@weight)[0])
      }

    end

  end

end
