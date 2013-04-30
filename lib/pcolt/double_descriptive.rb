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

    to_double_array_list
    fast_reset

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def fast_reset

    @kurtosis = nil
    @durbin_watson = nil
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
    @sample_variance = nil
    @list_size = nil
    @skew = nil
    @sorted_data = nil
    @standard_deviation = nil
    @standard_error = nil
    @sum = nil
    @sum_of_inversions = nil
    @sum_of_logarithms = nil
    @sum_of_squares = nil
    @sum_of_squared_deviations = nil
    @variance = nil

  end

  #------------------------------------------------------------------------------------
  # @param lag lag between the two measures to auto correlate
  #------------------------------------------------------------------------------------

  def auto_correlation(lag)
    DoubleDescriptive.autoCorrelation(@double_array_list, lag, mean, variance)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def correlation(other_val)
    other_val.reset_statistics
    DoubleDescriptive.correlation(@double_array_list, standard_deviation, 
                                  other_val.double_array_list, 
                                  other_val.standard_deviation)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def covariance(other_val)
    other_val.reset_statistics
    DoubleDescriptive.covariance(@double_array_list, other_val.double_array_list)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def durbin_watson
    @durbin_watson ||= DoubleDescriptive.durbinWatson(@double_array_list)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def frequencies

    distinct_values = Java::CernColtListTdouble::DoubleArrayList.new
    frequencies = Java::CernColtListTint::IntArrayList.new
    DoubleDescriptive.frequencies(sorted_data, distinct_values, frequencies)
    {:distinct_values => distinct_values.elements().to_a, 
      :frequencies => frequencies.elements().to_a}

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def geometric_mean
    @geometric_mean ||= DoubleDescriptive.geometricMean(@double_array_list)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def harmonic_mean
    @harmonic_mean ||= DoubleDescriptive.harmoniMean(list_size, sum_of_inversions)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def kurtosis
    @kurtosis ||=
      DoubleDescriptive.kurtosis(moment4, standard_deviation)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def lag1
    @lag1 ||= DoubleDescriptive.lag1(@double_array_list, mean)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def max
    @max ||= DoubleDescriptive.max(@double_array_list)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def mean
    @mean ||= DoubleDescriptive.mean(@double_array_list)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def mean_deviation
    @mean_deviation ||= DoubleDescriptive.meanDeviation(@double_array_list, mean)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def median
    @median ||= DoubleDescriptive.median(sorted_data)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def min
    @min ||= DoubleDescriptive.min(@double_array_list)
  end

  #------------------------------------------------------------------------------------
  # @param k integer
  # @param c double
  #------------------------------------------------------------------------------------

  def moment(k, c)
    DoubleDescriptive.moment(@double_array_list, k, c)
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
  #
  #------------------------------------------------------------------------------------

  def pooled_mean(other_val)
    other_val.reset_statistics
    DoubleDescriptive.pooledMean(list_size, mean, other_val.list_size, other_val.mean)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def pooled_variance(other_val)
    other_val.reset_statistics
    DoubleDescriptive.pooledVariance(list_size, vairance, other_val.list_size, 
                                     other_val.variance)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def product
    @product ||= DoubleDescriptive.product(@double_array_list)
  end

  #------------------------------------------------------------------------------------
  # @param phi double
  #------------------------------------------------------------------------------------

  def quantile(phi)
    DoubleDescriptive.quantile(sorted_data, phi)
  end

  #------------------------------------------------------------------------------------
  # @param elmt double
  #------------------------------------------------------------------------------------

  def quantile_inverse(elmt)
    DoubleDescriptive.quantileInverse(sorted_data, elmt)
  end

  #------------------------------------------------------------------------------------
  # @param elmt double
  #------------------------------------------------------------------------------------

  def rank_interpolated(elmt)
    DoubleDescriptive.rankInterpolated(sorted_data, elmt)
  end

  #------------------------------------------------------------------------------------
  # Root mean square
  #------------------------------------------------------------------------------------

  def rms
    @rms ||= DoubleDescriptive.rms(list_size, sum_of_squares)
  end

  #------------------------------------------------------------------------------------
  # @param mean double
  # @param sample_variance double
  #------------------------------------------------------------------------------------

  def sample_kurtosis
    @sample_kurtosis ||= 
      DoubleDescriptive.sampleKurtosis(list_size, moment4, sample_variance)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def sample_kurtosis_standard_error
    @sample_kurtosis_standard_error ||=
      DoubleDescriptive.sampleKurtosisStandardError(list_size)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def sample_skew
    @sample_skew ||= 
      DoubleDescriptive.sampleSkew(list_size, moment3, sample_variance)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def sample_skew_standard_error
    @sample_skew_standard_error ||=
      DoubleDescriptive.sampleSkewStandardError(list_size)
  end

  #------------------------------------------------------------------------------------
  #
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
  #
  #------------------------------------------------------------------------------------

  def sorted_data

    if (@sorted_data)
      return @sorted_data
    end

    list = @double_array_list.clone().elements()
    comp = Proc.new { |val1, val2| val1 <=> val2 }
    Java::CernColt::Sorting.parallelQuickSort(list, 0, list.size, comp)
    @sorted_data = Java::CernColtListTdouble::DoubleArrayList.new(list)

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def standard_deviation
    @standard_deviation ||= DoubleDescriptive.standardDeviation(variance)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def standard_error
    @standard_error ||= DoubleDescriptive.standardError(list_size, variance)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def standardize
    p "not implemented yet"
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def sum
    @sum ||= DoubleDescriptive.sum(@double_array_list)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def sum_of_inversions
    @sum_of_inversions ||= DoubleDescriptive.sumOfInversions(@double_array_list)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def sum_of_logarithms
    @sum_of_logarithms ||= DoubleDescriptive.sumOfLogarithms(@double_array_list)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def sum_of_power_deviations(k, c)
    DoubleDescriptive.sumOfPowerDeviations(@double_array_list, k, c)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def sum_of_powers(k)
    DoubleDescriptive.sumOfPowers(@double_array_list, k)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def sum_of_square
    @sum_of_square ||= DoubleDescriptive.sumOfSquares(@double_array_list)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def sum_of_squared_deviations
    @sum_of_squared_deviations ||= 
      DoubleDescriptive.sumOfSquaredDeviations(list_size, variance)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def sum_of_squares
    @sum_of_squares ||= DoubleDescriptive.sumOfSquares(@double_array_list)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def trimmed_mean(left, right)
    DoubleDescriptive.trimmedMean(sorted_data, mean, left, right)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def variance
    @variance ||= 
      DoubleDescriptive.variance(list_size, sum, sum_of_square)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def weighted_mean(weights)
    weights.reset_statistics
    DoubleDescriptive.weightedMean(@double_array_list, weights.double_array_list)
  end

  #------------------------------------------------------------------------------------
  #
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
    @list_size ||= @double_array_list.size
  end

end # DoubleDescriptive


##########################################################################################
#
##########################################################################################

class DoubleMDArray

  include DDescriptive

end # DoubleMDArray
