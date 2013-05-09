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

require_relative 'double_descriptive'

##########################################################################################
#
##########################################################################################

class StatList

  attr_reader :array_list

  #------------------------------------------------------------------------------------
  # Appends the specified element to the end of this list.
  #------------------------------------------------------------------------------------

  def add(element)
    @array_list.add(element)
  end

  #------------------------------------------------------------------------------------
  # Inserts the specified element before the specified position into the receiver.
  #------------------------------------------------------------------------------------

  def before_insert(index, element)
    @array_list.beforeInsert(index, element)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def binary_search(key, from = 0, to = @array_list.size() - 1)
    sorted_data.binarySearchFromTo(key, from, to)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def copy
    DoubleStatList.new(@array_list.copy)
  end

  #------------------------------------------------------------------------------------
  # Returns the elements currently stored, including invalid elements between size and 
  # capacity, if any.
  #------------------------------------------------------------------------------------

  def elements
    @array_list.elements().to_a
  end

  #------------------------------------------------------------------------------------
  # Returns the element at the specified position in the receiver.
  #------------------------------------------------------------------------------------

  def get(index)
    @array_list.get(index)
  end

  alias :[] :get

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def index_of(element, from = 0, to = @array_list.size() - 1)
    @array_list.indexOfFromTo(element, from, to)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def last_index_of(element, from = 0, to = @array_list.size() - 1)
    @array_list.lastIndexOfFromTo(element, from, to)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def reverse
    @array_list.reverse()
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def set(index, element)
    @array_list.set(index, element)
  end

  alias :[]= :set

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def shuffle(from = 0, to = @array_list.size() - 1)
    @array_list.shuffleFromTo(from, to)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def trim_to_size
    @array_list.trimToSize()
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def print
    puts @array_list.toString()
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def to_s
    print
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def reset_statistics

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
  #
  #------------------------------------------------------------------------------------

  private

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def initialize(value = nil)
    reset_statistics
  end

end


##########################################################################################
#
##########################################################################################

class DoubleStatList < StatList
  include DDescriptive

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def initialize(value = nil)

    super(value)

    if (value == nil)
      @array_list = Java::CernColtListTdouble::DoubleArrayList.new()
    elsif (value.is_a? Integer)
      @array_list = Java::CernColtListTdouble::DoubleArrayList.new(value)
    else # Receiving a DoubleArrayList
      @array_list = value
    end

  end

end # StatList
