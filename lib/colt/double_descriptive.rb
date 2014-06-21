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
  #
  #------------------------------------------------------------------------------------

  def reset_statistics

    @distinct_values = nil
    @durbin_watson = nil
    @frequencies = nil
    @geometric_mean = nil
    @kurtosis = nil
    @lag1 = nil
    @max = nil
    @mean = nil
    @mean_deviation = nil
    @median = nil
    @min = nil
    @moment3 = nil
    @moment4 = nil
    @product = nil
    @sample_kurtosis = nil
    @sample_kurtosis_standard_error = nil
    @sample_skew = nil
    @sample_skew_standard_error = nil
    @sample_standard_deviation = nil
    @sample_variance = nil
    @sample_weighted_variance = nil
    @list_size = nil
    @skew = nil
    @sorted_data = nil
    @standard_deviation = nil
    @standard_error = nil
    @sum = nil
    @sum_of_inversions = nil
    @sum_of_logarithms = nil
    @sum_of_squared_deviations = nil
    @sum_of_squares = nil
    @variance = nil
    @weighted_rms = nil

  end

  #------------------------------------------------------------------------------------
  # Returns the auto-correlation of a data sequence.
  # @param lag lag between the two measures to auto correlate
  #------------------------------------------------------------------------------------

  def auto_correlation(lag)
    DoubleDescriptive.autoCorrelation(@array_list, lag, mean, variance)
  end

  #------------------------------------------------------------------------------------
  # Returns the correlation of two data sequences. 
  # That is covariance(data1,data2)/(standardDev1*standardDev2).
  #------------------------------------------------------------------------------------

  def correlation(other_val)
    covariance(other_val) / (standard_deviation * other_val.standard_deviation)
  end

  #------------------------------------------------------------------------------------
  # Returns the covariance of two data sequences. 
  # That is cov(x,y) = Sum((x[i]-mean(x)) * (y[i]-mean(y))) / size().
  #------------------------------------------------------------------------------------

  def covariance(other_val)
    sample_covariance(other_val) * (list_size - 1) / list_size
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
    
    if (@frequencies == nil)
      distinct_values = Java::CernColtListTdouble::DoubleArrayList.new
      frequencies = Java::CernColtListTint::IntArrayList.new
      DoubleDescriptive.frequencies(sorted_data, distinct_values, frequencies)
      distinct_values.trimToSize()
      frequencies.trimToSize()
      @distinct_values = distinct_values.elements().to_a
      @frequencies = frequencies.elements().to_a
    end

      { :distinct_values => @distinct_values, :frequencies => @frequencies}
    
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
    @harmonic_mean ||= DoubleDescriptive.harmonicMean(list_size, sum_of_inversions)
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
  # Returns the lag-1 autocorrelation of a dataset; Note that this method has semantics 
  # different from autoCorrelation(..., 1);
  #------------------------------------------------------------------------------------

  def lag1
    @lag1 ||= DoubleDescriptive.lag1(@array_list, mean)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def list_size
    @list_size ||= @array_list.size
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
  # The third central moment.  That is: moment(data,3,mean)
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
  # That is (size1 * mean1 + size2 * mean2) / (size1 + size2).
  #------------------------------------------------------------------------------------

  def pooled_mean(other_val)
    other_val.reset_statistics
    DoubleDescriptive.pooledMean(list_size, mean, other_val.list_size, other_val.mean)
  end

  #------------------------------------------------------------------------------------
  # Returns the pooled variance of two data sequences.
  # That is: size1 * variance1 + size2 * variance2) / (size1 + size2)
  #------------------------------------------------------------------------------------

  def pooled_variance(other_val)
    other_val.reset_statistics
    DoubleDescriptive.pooledVariance(list_size, variance, other_val.list_size, 
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
  # @param percentages the percentages for which quantiles are to be computed. Each 
  # percentage must be in the interval [0.0,1.0].
  #------------------------------------------------------------------------------------

  def quantiles(percs)

    percs = Java::CernColtListTdouble::DoubleArrayList.new(percs.to_java(Java::double))
    res = DoubleDescriptive.quantiles(sorted_data, percs)
    res.elements().to_a

  end

  #------------------------------------------------------------------------------------
  # Returns the linearly interpolated number of elements in a list less or equal to a 
  # given element. The rank is the number of elements <= element. Ranks are of the form 
  # {0, 1, 2,..., sortedList.size()}. If no element is <= element, then the rank is 
  # zero. If the element lies in between two contained elements, then linear 
  # interpolation is used and a non integer value is returned.
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
  # Returns the sample covariance of two data sequences. 
  # That is cov(x,y) = (1/(size()-1)) * Sum((x[i]-mean(x)) * (y[i]-mean(y))) .
  #------------------------------------------------------------------------------------

  def sample_covariance(other_val)
    other_val.reset_statistics
    DoubleDescriptive.covariance(@array_list, other_val.array_list)
  end

  #------------------------------------------------------------------------------------
  # Returns the sample kurtosis (aka excess) of a data sequence.
  #------------------------------------------------------------------------------------

  def sample_kurtosis
    @sample_kurtosis ||= 
      DoubleDescriptive.sampleKurtosis(list_size, moment4, sample_variance)
  end

  #------------------------------------------------------------------------------------
  # Return the standard error of the sample kurtosis. Ref: R.R. Sokal, F.J. Rohlf, 
  # Biometry: the principles and practice of statistics in biological research (W.H. 
  # Freeman and Company, New York, 1998, 3rd edition) p. 138.
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
  # Return the standard error of the sample skew. Ref: R.R. Sokal, F.J. Rohlf, 
  # Biometry: the principles and practice of statistics in biological research (W.H. 
  # Freeman and Company, New York, 1998, 3rd edition) p. 138.
  #------------------------------------------------------------------------------------

  def sample_skew_standard_error
    @sample_skew_standard_error ||=
      DoubleDescriptive.sampleSkewStandardError(list_size)
  end

  #------------------------------------------------------------------------------------
  # Returns the sample standard deviation. Ref: R.R. Sokal, F.J. Rohlf, Biometry: the 
  # principles and practice of statistics in biological research (W.H. Freeman and 
  # Company, New York, 1998, 3rd edition) p. 53. The standard deviation calculated as 
  # the sqrt of the variance underestimates the unbiased standard deviation. It needs 
  # to be multiplied by this correction factor: 
  # 1) if (n > 30): Cn = 1+1/(4*(n-1)), else
  # 2) Cn = Math.sqrt((n - 1) * 0.5) * Gamma.gamma((n - 1) * 0.5) / Gamma.gamma(n * 0.5)
  # The sample standard deviation is Cn * size
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
  #   That is (sum_of_squared_products - sum_of_products * sum_of_products / 
  #   sum_of_weights) / (sum_of_weights - 1)
  # where:
  #   sum_of_weights = Sum ( weights[i] )
  #   sum_of_products = Sum ( data[i] * weights[i] )
  #   sum_of_squared_products = Sum( data[i] * data[i] * weights[i] )
  #------------------------------------------------------------------------------------

  def sample_weighted_variance(weights)

    weights = Java::CernColtListTdouble::DoubleArrayList.new(weights.to_java(Java::double))
    sum_of_weights = DoubleDescriptive.sum(weights)
    sum_of_products, sum_of_squared_products = weighted_sums(weights)
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
  # Splits (partitions) a list into sublists such that each sublist contains the 
  # elements with a given range. splitters= (a,b,c,...,y,z) defines the ranges [-inf,a), 
  # [a,b), [b,c), ..., [y,z), [z,inf].
  # Examples:
  #   data = (1,2,3,4,5,8,8,8,10,11). 
  #   splitters=(2,8) yields 3 bins: (1), (2,3,4,5) (8,8,8,10,11). 
  #   splitters=() yields 1 bin: (1,2,3,4,5,8,8,8,10,11). 
  #   splitters=(-5) yields 2 bins: (), (1,2,3,4,5,8,8,8,10,11). 
  #   splitters=(100) yields 2 bins: (1,2,3,4,5,8,8,8,10,11), ().
  # @para splitters - the points at which the list shall be partitioned (must be sorted 
  #   ascending).
  # @return the sublists (an array with length == splitters.size() + 1. Each sublist is 
  #   returned sorted ascending.
  #------------------------------------------------------------------------------------
  
  def split(splitters)

    split = Java::CernColtListTdouble::DoubleArrayList.new(splitters.to_java(Java::double))
    res = DoubleDescriptive.split(sorted_data, split)
    lists = res.to_a
    bins = Array.new

    lists.each do |list|
      list.trimToSize()
      bins << list.elements().to_a
    end
    
    bins

  end

  #------------------------------------------------------------------------------------
  # Returns a list with the sorted elements
  #------------------------------------------------------------------------------------

  def sort
    sorted_data
    @sorted_data.trimToSize()
    @sorted_data.elements.to_a
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
  # Modifies a data sequence to be standardized. Changes each element data[i] as 
  # follows: data[i] = (data[i]-mean)/standardDeviation.
  #------------------------------------------------------------------------------------

  def standardize!
    DoubleDescriptive.standardize(@array_list, mean, standard_deviation)
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

  def sum_of_inversions(from = 0, to = list_size - 1)
    @sum_of_inversions ||= DoubleDescriptive.sumOfInversions(@array_list, from, to)
  end

  #------------------------------------------------------------------------------------
  # Returns the sum of logarithms of a data sequence, which is Sum( Log(data[i]).
  #------------------------------------------------------------------------------------

  def sum_of_logarithms(from = 0, to = list_size - 1)
    @sum_of_logarithms ||= DoubleDescriptive.sumOfLogarithms(@array_list, from, to)
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
  # Returns the sum of the product with another array.T
  # hat is, Sum( data[i] * other_val[i] )
  # @param other_val: ruby array or a CernColtListTdouble::DoubleArrayList (when called
  # internally.
  #------------------------------------------------------------------------------------

  def weighted_sums(other_val, from = 0, to = list_size - 1)

    if (other_val.is_a? Array)
      weights = Java::CernColtListTdouble::DoubleArrayList.new(other_val.to_java(Java::double))
    elsif (other_val.is_a? Java::CernColtListTdouble::DoubleArrayList)
      weights = other_val
    else
      raise "#{other_val} is not a valid weight array"
    end

    in_out = [0.0, 0.0].to_java Java::double
    DoubleDescriptive.incrementalWeightedUpdate(@array_list, weights, from, to, in_out)
    [in_out[0], in_out[1]]

  end

  #------------------------------------------------------------------------------------
  # Returns the sum of squared mean deviation of of a data sequence.
  #------------------------------------------------------------------------------------

  def sum_of_squared_deviations
    @sum_of_square_deviations ||=
      DoubleDescriptive.sumOfSquaredDeviations(list_size, variance)
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

  def trimmed_mean(left = 0, right = 0)
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
    weights = Java::CernColtListTdouble::DoubleArrayList.new(weights.to_java(Java::double))
    DoubleDescriptive.weightedMean(@array_list, weights)
  end

  #------------------------------------------------------------------------------------
  # Returns the weighted RMS (Root-Mean-Square) of a data sequence.
  #------------------------------------------------------------------------------------

  def weighted_rms(weights)

    weights = Java::CernColtListTdouble::DoubleArrayList.new(weights.to_java(Java::double))
    sum_of_products, sum_of_squared_products = weighted_sums(weights)
    DoubleDescriptive.weightedRMS(sum_of_products, sum_of_squared_products)

  end

  #------------------------------------------------------------------------------------
  # Returns the winsorized mean of a sorted data sequence.
  #------------------------------------------------------------------------------------

  def winsorized_mean(left, right)
    DoubleDescriptive.winsorizedMean(sorted_data, mean, left, right)
  end

end # DoubleDescriptive
