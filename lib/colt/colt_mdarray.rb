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
# Reopens class MDArray so that we can add helper methods to interface with Colt
##########################################################################################


class DoubleMDArray

  attr_reader :stat_list

  #------------------------------------------------------------------------------------
  # Converts the mdarray to an DoubleArrayList usable by Parallel Colt
  #------------------------------------------------------------------------------------

  def reset_statistics
    
    base_array = @nc_array.get1DJavaArray(Java::double.java_class)
    double_array_list = Java::CernColtListTdouble::DoubleArrayList.new(base_array)
    @stat_list = DoubleStatList.new(double_array_list)

  end
    
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  private 

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.colt_stats

    stats = [:auto_correlation, :correlation, :covariance, :durbin_watson, :frequencies, 
             :geometric_mean, :harmonic_mean, :kurtosis, :lag1, :max, :mean, 
             :mean_deviation, :median, :min, :moment, :moment3, :moment4, :pooled_mean, 
             :pooled_variance, :product, :quantile, :quantile_inverse, 
             :rank_interpolated, :rms, :sample_kurtosis, :sample_kurtosis_standard_error, 
             :sample_skew, :sample_skew_standard_error, :sample_standard_deviation,
             :sample_variance, :sample_weighted_variance, :skew, :split, 
             :standard_deviation, :standard_error, :standardize, :sum, 
             :sum_of_inversions, :sum_of_logarithms, :sum_of_power_deviations, 
             :sum_of_powers, :sum_of_squares, :sum_of_squared_deviations, :trimmed_mean,
             :variance, :weighted_mean, :weighted_rms, :winsorized_mean]

=begin
    # undefine all methods.  Need for now, on furture versions we should be able to
    # have many ways of executing the same method, so there should be no need to 
    # undef a method.
    stats.each do |method|
      remove_method(:max)
    end
=end

    # define all statistics methods from colt
    stats.each do |method|
      define_method(method) { |*args| @stat_list.send(method, *args) }
    end

  end

  self.colt_stats

end # MDArray

