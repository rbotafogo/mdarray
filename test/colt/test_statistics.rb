require 'rubygems'
require "test/unit"
require 'shoulda'

require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "Statistics Tests" do

    setup do

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "do stats operations" do

      # read file VALE3.  This file has a header that we need to discard.  VALE3 
      # contains quote values from brazilian company VALE as obtained from Yahoo finance
      # (quote vale3.SA)
      vale3 = MDArray.double("#{$COLT_TEST_DIR}/VALE3_short.csv", true)

      # in order to use statistics we need to reset_statistics on array vale3.  This 
      # breaks version 0.4.3 statistics that did not require a call to reset_statistics.
      # In future version we will keep both methods with reset_statistics and without
      # reset_statistics being required.
      vale3.reset_statistics

      # sum all values of vale3.  This does not make sense from a financial point of view.
      # suming all values including dates... Not doing anything with the value, just
      # checking that it does not crash.
      vale3.sum

      # lets get only the open price for the whole period. We slice the vale3 on the
      # second dimension and get the second column. 
      open = vale3.slice(1,1)
      
      # lets also get the high value.
      high = vale3.slice(1,2)

      # weights to be used for weighted operations
      weights = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14.0, 15, 16, 17, 18, 19]

      # splitters to be used to split the list
      splitters = [34.0, 36.0]

      # quantiles to be used to split the list
      percs = [0.20, 0.40, 0.60, 0.80, 1]

      # getting descriptive statistics for the open value.  open is a new MDArray, so
      # we need to reset_statistics for open as well.
      open.reset_statistics

      assert_equal(-0.30204751376121775, open.auto_correlation(10))
      assert_equal(0.8854362245369992, open.correlation(high))
      assert_equal(1.4367963988919659, open.covariance(high))
      assert_equal(0.00079607686762408, open.durbin_watson)
      assert_equal(33.837262944797345, open.geometric_mean)
      assert_equal(33.81400448777291, open.harmonic_mean)
      assert_equal(-0.925644222523478, open.kurtosis)
      assert_equal(0.681656774667894, open.lag1)
      assert_equal(36.43, open.max)
      assert_equal(33.86052631578948,open.mean)
      assert_equal(1.0889750692520779,open.mean_deviation)
      assert_equal(33.74,open.median)
      assert_equal(31.7,open.min)
      assert_equal(0.07736522466830013,open.moment3)
      assert_equal(5.147382269264963,open.moment4)
      assert_equal(34.17368421052632,open.pooled_mean(high))
      assert_equal(1.623413296398882,open.pooled_variance(high))
      assert_equal(1.1442193777839571e+29,open.product)
      assert_equal(32.498000000000005,open.quantile(0.2))
      assert_equal(0.8421052631578947,open.quantile_inverse(35.0))
      assert_equal(5.903846153846159,open.rank_interpolated(33.0))
      assert_equal(33.88377930514836,open.rms)
      assert_equal(-0.8280585298104861,open.sample_kurtosis)
      assert_equal(1.5166184210526306,open.sample_covariance(high))
      assert_equal(1.0142698435367294,open.sample_kurtosis_standard_error)
      assert_equal(0.042567930807996486,open.sample_skew)
      assert_equal(0.5237666950104207,open.sample_skew_standard_error)
      assert_equal(1.3075102994156926,open.sample_standard_deviation)
      assert_equal(1.6627719298244807,open.sample_variance)
      assert_equal(1.2035654385963137,open.sample_weighted_variance(weights))
      assert_equal(0.039130771304858564,open.skew)
      assert_equal(1.255092672964214,open.standard_deviation)
      assert_equal(0.28793800664365016,open.standard_error)
      assert_equal(643.35,open.sum)
      assert_equal(0.561897364355954,open.sum_of_inversions)
      assert_equal(66.90969033519778,open.sum_of_logarithms)
      assert_equal(29.92989473684211,open.sum_of_power_deviations(2, open.mean))
      assert_equal(740665.2440910001,open.sum_of_powers(3))
      assert_equal(21814.099500000004,open.sum_of_squares)
      assert_equal(28.354637119112198,open.sum_of_squared_deviations)
      assert_equal(33.862, open.trimmed_mean(2, 2))
      assert_equal(1.5752576177284554,open.variance)
      assert_equal(34.31689473684211,open.weighted_mean(weights))
      assert_equal(0.029110571117388302,open.weighted_rms(weights))
      assert_equal(33.816315789473684,open.winsorized_mean(1, 1))

      p "Distinct values: #{open.frequencies[:distinct_values]}"
      p "Frequencies: #{open.frequencies[:frequencies]}"
      p "Split: #{open.split(splitters)}"
      p "Quantiles: #{open.quantiles(percs)}"
      p "Sorted elements: #{open.sort}"
      p "Standardized elements: #{open.standardize}"

    end

  end

end
