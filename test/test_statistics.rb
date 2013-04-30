require 'rubygems'
require "test/unit"
require 'shoulda'

require 'mdarray'

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

      # MDArray.binary_operator = RubyBinaryOperator

      # in order to use statistics we need to reset_statistics on array @a.  This breaks
      # version 0.4.3 statistics that did not require a call to reset_statistics.
      @a.reset_statistics

      assert_equal(49995000, @a.sum)
      assert_equal(0, @a.min)
      assert_equal(9999, @a.max)
      assert_equal(4999.5, @a.mean)
      assert_equal(6666.333333333333, @a.weighted_mean(@weight))

    end

  end

end
