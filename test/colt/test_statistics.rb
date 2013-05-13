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

      @e = MDArray.fromfunction("double", [4, 5, 6]) do |x, y, z|
        3.21 * (x + y + z)
      end

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
      
      # getting descriptive statistics for the open value.  open is a new MDArray, so
      # we need to reset_statistics for open as well.
      open.reset_statistics

      p "auto_correlation: #{open.auto_correlation(10)}"
      p "Correlation (open x high): #{open.correlation(high)}"
      p "Covariance (open x high): #{open.covariance(high)}"
      p "Durbin Watson: #{open.durbin_watson}"
      p "Frequencies: "
      p "Geometric mean: #{open.geometric_mean}"
      p "Harmonic mean: #{open.harmonic_mean}"
      p "Kurtosis: #{open.kurtosis}"
      p "Lag1: #{open.lag1}"
      p "Max: #{open.max}"
      p "Mean: #{open.mean}"
      p "Mean deviation: #{open.mean_deviation}"
      p "Median: #{open.median}"
      p "Min: #{open.min}"
      p "Moment3: #{open.moment3}"
      p "Moment4: #{open.moment4}"
      p "Pooled mean: #{open.pooled_mean(high)}"
      p "Pooled variance: #{open.pooled_variance(high)}"
      p "Product: #{open.product}"
      p "Quantile (20%): #{open.quantile(0.2)}"
      p "Quantile inverse: #{open.quantile_inverse(35.0)}"
      p "Rank interporlated (33.0): #{open.rank_interpolated(33.0)}"
      p "RMS: #{open.rms}"
      p "Sample kurtosis: #{open.sample_kurtosis}"
      p "Sample covariance (open x high): #{open.sample_covariance(high)}"
      p "Sample kurtosis standard error: #{open.sample_kurtosis_standard_error}"
      p "Sample skew: #{open.sample_skew}"
      p "Sample skew standard error: #{open.sample_skew_standard_error}"
      p "Sample standard deviation: #{open.sample_standard_deviation}"
      p "Sample variance: #{open.sample_variance}"
      p "Skew: #{open.skew}"
      p "Standard deviation: #{open.standard_deviation}"
      p "Standard error: #{open.standard_error}"
      p "Sum: #{open.sum}"
      p "Sum of inversions: #{open.sum_of_inversions}"
      p "Sum of logarithms: #{open.sum_of_logarithms}"
      p "Sum of power deviations: #{open.sum_of_power_deviations(0, 2)}"
      p "Sum of powers (2.0): #{open.sum_of_powers(2)}"
      p "Sum of squares: #{open.sum_of_squares}"
      p "Sum of squared deviations: #{open.sum_of_squared_deviations}"
      p "Trimmed mean (2, 2): #{open.trimmed_mean(2, 2)}"
      p "Variance: #{open.variance}"
      p "Weighted mean: "
      p "Weighted rms: "
      p "Winsorized mean (2, 2): #{open.winsorized_mean(2, 2)}"

    end

  end

end

=begin
      assert_equal(49995000, @a.sum)
      assert_equal(0, @a.min)
      assert_equal(9999, @a.max)
      assert_equal(4999.5, @a.mean)
      assert_equal(6666.333333333333, @a.weighted_mean(@weight))
=end

