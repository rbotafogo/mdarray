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

class Colt

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.processors
    Java::EduEmoryMathcsUtils::ConcurrencyUtils.get_number_of_processors
  end
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.threads
    Java::EduEmoryMathcsUtils::ConcurrencyUtils.get_number_of_threads
  end
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  
end # Colt

##########################################################################################
# Reopens class MDArray so that we can add helper methods to interface with Colt
##########################################################################################

class MDArray

  attr_reader :double_array_list

  #------------------------------------------------------------------------------------
  # Converts the mdarray to an DoubleArrayList usable by Parallel Colt
  #------------------------------------------------------------------------------------

  def to_double_array_list
    
    base_array = @nc_array.get1DJavaArray(Java::double.java_class)
    @double_array_list = Java::CernColtListTdouble::DoubleArrayList.new(base_array)

  end

end # MDArray

require_relative 'double_descriptive'

# MDArray.functions = "CernFunctions"

