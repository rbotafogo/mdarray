# -*- coding: utf-8 -*-

##########################################################################################
# Copyright © 2013 Rodrigo Botafogo. All Rights Reserved. Permission to use, copy, modify, 
# and distribute this software and its documentation for educational, research, and 
# not-for-profit purposes, without fee and without a signed licensing agreement, is hereby 
# granted, provided that the above copyright notice, this paragraph and the following two 
# paragraphs appear in all copies, modifications, and distributions. Contact Rodrigo
# Botafogo - rodrigo.a.botafogo@gmail.com for commercial licensing opportunities.
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

##########################################################################################
#
##########################################################################################

require 'java'

module DDescriptive
  include_package "cern.jet.stat.tdouble"

  #------------------------------------------------------------------------------------
  # Returns the auto-correlation of a data sequence.
  # @param lag lag between the two measures to auto correlate
  #------------------------------------------------------------------------------------

  def auto_correlation(lag)
    DoubleDescriptive.autoCorrelation(@array_list, lag, mean, variance)
  end

  #------------------------------------------------------------------------------------
  # Returns the correlation of two data sequences.
  #------------------------------------------------------------------------------------

  def correlation(other_val)
    other_val.reset_statistics
    DoubleDescriptive.correlation(@array_list, standard_deviation, 
                                  other_val.double_array_list, 
                                  other_val.standard_deviation)
  end

  #------------------------------------------------------------------------------------
  # Returns the covariance of two data sequences, which is cov(x,y) = (1/(size()-1)) * 
  # Sum((x[i]-mean(x)) * (y[i]-mean(y))) .
  #------------------------------------------------------------------------------------

  def covariance(other_val)
    other_val.reset_statistics
    DoubleDescriptive.covariance(@array_list, other_val.double_array_list)
  end

  #------------------------------------------------------------------------------------
  # Durbin-Watson computation.
  #------------------------------------------------------------------------------------

  def durbin_watson
    @durbin_watson ||= DoubleDescriptive.durbinWatson(@array_list)
  end

  #------------------------------------------------------------------------------------
  # Computes the frequency (number of occurances, count) of each distinct value in the 
  # given sorted data.
  #------------------------------------------------------------------------------------

  def frequencies

    distinct_values = Java::CernColtListTdouble::DoubleArrayList.new
    frequencies = Java::CernColtListTint::IntArrayList.new
    DoubleDescriptive.frequencies(sorted_data, distinct_values, frequencies)
    {:distinct_values => distinct_values.elements().to_a, 
      :frequencies => frequencies.elements().to_a}

  end

  #------------------------------------------------------------------------------------
  # Returns the geometric mean of a data sequence.
  #------------------------------------------------------------------------------------

  def geometric_mean
    @geometric_mean ||= DoubleDescriptive.geometricMean(@array_list)
  end

  #------------------------------------------------------------------------------------
  # Returns the harmonic mean of a data sequence.
  #------------------------------------------------------------------------------------

  def harmonic_mean
    @harmonic_mean ||= DoubleDescriptive.harmoniMean(list_size, sum_of_inversions)
  end

  #------------------------------------------------------------------------------------
  # Returns the kurtosis (aka excess) of a data sequence, which is -3 + 
  # moment(data,4,mean) / standardDeviation4.
  #------------------------------------------------------------------------------------

  def kurtosis
    @kurtosis ||=
      DoubleDescriptive.kurtosis(moment4, standard_deviation)
  end

  #------------------------------------------------------------------------------------
  # Returns the lag-1 autocorrelation of a dataset.
  #------------------------------------------------------------------------------------

  def lag1
    @lag1 ||= DoubleDescriptive.lag1(@array_list, mean)
  end

  #------------------------------------------------------------------------------------
  # Returns the largest member of a data sequence.
  #------------------------------------------------------------------------------------

  def max
    @max ||= DoubleDescriptive.max(@array_list)
  end

  #------------------------------------------------------------------------------------
  # Returns the arithmetic mean of a data sequence; That is Sum( data[i] ) / data.size()
  #------------------------------------------------------------------------------------

  def mean
    @mean ||= DoubleDescriptive.mean(@array_list)
  end

  #------------------------------------------------------------------------------------
  # Returns the mean deviation of a dataset.
  #------------------------------------------------------------------------------------

  def mean_deviation
    @mean_deviation ||= DoubleDescriptive.meanDeviation(@array_list, mean)
  end

  #------------------------------------------------------------------------------------
  # Returns the median of a sorted data sequence.
  #------------------------------------------------------------------------------------

  def median
    @median ||= DoubleDescriptive.median(sorted_data)
  end

  #------------------------------------------------------------------------------------
  # Returns the smallest member of a data sequence.
  #------------------------------------------------------------------------------------

  def min
    @min ||= DoubleDescriptive.min(@array_list)
  end

  #------------------------------------------------------------------------------------
  # Returns the moment of k-th order with constant c of a data sequence, which is 
  # Sum( (data[i]-c)k ) / data.size().
  # @param k integer
  # @param c double
  #------------------------------------------------------------------------------------

  def moment(k, c)
    DoubleDescriptive.moment(@array_list, k, c)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def moment3
    @moment3 ||= moment(3, mean)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def moment4
    @moment4 ||= moment(4, mean)
  end

  #------------------------------------------------------------------------------------
  # Returns the pooled mean of two data sequences.
  #------------------------------------------------------------------------------------

  def pooled_mean(other_val)
    other_val.reset_statistics
    DoubleDescriptive.pooledMean(list_size, mean, other_val.list_size, other_val.mean)
  end

  #------------------------------------------------------------------------------------
  # Returns the pooled variance of two data sequences.
  #------------------------------------------------------------------------------------

  def pooled_variance(other_val)
    other_val.reset_statistics
    DoubleDescriptive.pooledVariance(list_size, vairance, other_val.list_size, 
                                     other_val.variance)
  end

  #------------------------------------------------------------------------------------
  # Returns the product of a data sequence, which is Prod( data[i] ) .
  #------------------------------------------------------------------------------------

  def product
    @product ||= DoubleDescriptive.product(@array_list)
  end

  #------------------------------------------------------------------------------------
  # Returns the phi-quantile; that is, an element elem for which holds that phi percent 
  # of data elements are less than elem.
  # @param phi double
  #------------------------------------------------------------------------------------

  def quantile(phi)
    DoubleDescriptive.quantile(sorted_data, phi)
  end

  #------------------------------------------------------------------------------------
  # Returns how many percent of the elements contained in the receiver are <= element.
  # @param elmt double
  #------------------------------------------------------------------------------------

  def quantile_inverse(elmt)
    DoubleDescriptive.quantileInverse(sorted_data, elmt)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def quantiles

  end

  #------------------------------------------------------------------------------------
  # Returns the linearly interpolated number of elements in a list less or equal to a 
  # given element.
  # @param elmt double
  #------------------------------------------------------------------------------------

  def rank_interpolated(elmt)
    DoubleDescriptive.rankInterpolated(sorted_data, elmt)
  end

  #------------------------------------------------------------------------------------
  # Returns the RMS (Root-Mean-Square) of a data sequence.
  #------------------------------------------------------------------------------------

  def rms
    @rms ||= DoubleDescriptive.rms(list_size, sum_of_squares)
  end

  #------------------------------------------------------------------------------------
  # Returns the sample kurtosis (aka excess) of a data sequence.
  #------------------------------------------------------------------------------------

  def sample_kurtosis
    @sample_kurtosis ||= 
      DoubleDescriptive.sampleKurtosis(list_size, moment4, sample_variance)
  end

  #------------------------------------------------------------------------------------
  # Return the standard error of the sample kurtosis.
  #------------------------------------------------------------------------------------
  
  def sample_kurtosis_standard_error
    @sample_kurtosis_standard_error ||=
      DoubleDescriptive.sampleKurtosisStandardError(list_size)
  end

  #------------------------------------------------------------------------------------
  # Returns the sample skew of a data sequence.
  #------------------------------------------------------------------------------------

  def sample_skew
    @sample_skew ||= 
      DoubleDescriptive.sampleSkew(list_size, moment3, sample_variance)
  end

  #------------------------------------------------------------------------------------
  # Return the standard error of the sample skew.
  #------------------------------------------------------------------------------------

  def sample_skew_standard_error
    @sample_skew_standard_error ||=
      DoubleDescriptive.sampleSkewStandardError(list_size)
  end

  #------------------------------------------------------------------------------------
  # Returns the sample standard deviation.
  #------------------------------------------------------------------------------------
  def sample_standard_deviation
    @sample_standard_deviation ||=
      DoubleDescriptive.sampleStandardDeviation(list_size, sample_variance)
  end

  #------------------------------------------------------------------------------------
  # Returns the sample variance of a data sequence.
  #------------------------------------------------------------------------------------

  def sample_variance
    @sample_variance ||=
      DoubleDescriptive.sampleVariance(list_size, sum, sum_of_squares)
  end

  #------------------------------------------------------------------------------------
  # Returns the sample weighted variance of a data sequence.
  #------------------------------------------------------------------------------------

  def sample_weighted_variance
    @sample_weighted_variance ||=
      DoubleDescriptive.sampleWeightedVariance(sum_of_weights, sum_of_products, 
                                               sum_of_squared_products)
  end

  #------------------------------------------------------------------------------------
  # Returns the skew of a data sequence, which is moment(data,3,mean) / 
  # standardDeviation.
  #------------------------------------------------------------------------------------

  def skew
    @skew ||= DoubleDescriptive.skew(moment3, standard_deviation)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def split

  end

  #------------------------------------------------------------------------------------
  # ??
  #------------------------------------------------------------------------------------

  def sort
    @sorted_data.elements.trimToSize.to_a
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def sorted_data

    if (@sorted_data)
      return @sorted_data
    end

    list = @array_list.clone().elements()
    comp = Proc.new { |val1, val2| val1 <=> val2 }
    Java::CernColt::Sorting.parallelQuickSort(list, 0, @array_list.size(), comp)
    @sorted_data = Java::CernColtListTdouble::DoubleArrayList.new(list)

  end

  #------------------------------------------------------------------------------------
  # Returns the standard deviation from a variance.
  #------------------------------------------------------------------------------------

  def standard_deviation
    @standard_deviation ||= DoubleDescriptive.standardDeviation(variance)
  end

  #------------------------------------------------------------------------------------
  # Returns the standard error of a data sequence.
  #------------------------------------------------------------------------------------

  def standard_error
    @standard_error ||= DoubleDescriptive.standardError(list_size, variance)
  end

  #------------------------------------------------------------------------------------
  # Modifies a data sequence to be standardized.
  #------------------------------------------------------------------------------------

  def standardize
    p "not implemented yet"
  end

  #------------------------------------------------------------------------------------
  # Returns the sum of a data sequence.
  #------------------------------------------------------------------------------------

  def sum
    @sum ||= DoubleDescriptive.sum(@array_list)
  end

  #------------------------------------------------------------------------------------
  # Returns the sum of inversions of a data sequence, which is Sum( 1.0 / data[i]).
  #------------------------------------------------------------------------------------

  def sum_of_inversions
    @sum_of_inversions ||= DoubleDescriptive.sumOfInversions(@array_list)
  end

  #------------------------------------------------------------------------------------
  # Returns the sum of logarithms of a data sequence, which is Sum( Log(data[i]).
  #------------------------------------------------------------------------------------

  def sum_of_logarithms
    @sum_of_logarithms ||= DoubleDescriptive.sumOfLogarithms(@array_list)
  end

  #------------------------------------------------------------------------------------
  # Returns Sum( (data[i]-c)k ); optimized for common parameters like c == 0.0 and/or
  # k == -2
  #------------------------------------------------------------------------------------

  def sum_of_power_deviations(k, c)
    DoubleDescriptive.sumOfPowerDeviations(@array_list, k, c)
  end

  #------------------------------------------------------------------------------------
  # Returns the sum of powers of a data sequence, which is Sum ( data[i]k ).
  #------------------------------------------------------------------------------------

  def sum_of_powers(k)
    DoubleDescriptive.sumOfPowers(@array_list, k)
  end

  #------------------------------------------------------------------------------------
  # Returns the sum of squared mean deviation of of a data sequence.
  #------------------------------------------------------------------------------------

  def sum_of_squared_deviations
    @sum_of_square_deviations ||=
      DoubleDescriptive.sumOfSquareDeviations(list_size, variance)
  end

  #------------------------------------------------------------------------------------
  # Returns the sum of squares of a data sequence.
  #------------------------------------------------------------------------------------

  def sum_of_squares
    @sum_of_squares ||= DoubleDescriptive.sumOfSquares(@array_list)
  end

  #------------------------------------------------------------------------------------
  # Returns the trimmed mean of a sorted data sequence.
  #------------------------------------------------------------------------------------

  def trimmed_mean(left, right)
    DoubleDescriptive.trimmedMean(sorted_data, mean, left, right)
  end

  #------------------------------------------------------------------------------------
  # Returns the variance from a standard deviation.
  #------------------------------------------------------------------------------------

  def variance
    @variance ||= 
      DoubleDescriptive.variance(list_size, sum, sum_of_squares)
  end

  #------------------------------------------------------------------------------------
  # Returns the weighted mean of a data sequence.
  #------------------------------------------------------------------------------------

  def weighted_mean(weights)
    weights.reset_statistics
    DoubleDescriptive.weightedMean(@array_list, weights.double_array_list)
  end

  #------------------------------------------------------------------------------------
  # Returns the weighted RMS (Root-Mean-Square) of a data sequence.
  #------------------------------------------------------------------------------------

  def weighted_rms
    @weighted_rms ||=
      DoubleDescriptive.weightedRMS(sum_of_products, sum_of_squared_products)
  end

  #------------------------------------------------------------------------------------
  # Returns the winsorized mean of a sorted data sequence.
  #------------------------------------------------------------------------------------

  def winsorized_mean(left, right)
    DoubleDescriptive.winsorizedMean(sorted_data, mean, left, right)
  end
 
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  private

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def list_size
    @list_size ||= @array_list.size
  end

end # DoubleDescriptive
