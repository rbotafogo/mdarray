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
#
##########################################################################################

module CernFunctions

  class << self
    attr_reader :binary_helper
    attr_reader :unary_helper
  end

  @binary_helper = Java::RbColtLoopsBinops
  @unary_helper = Java::RbColtLoopsUnops

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def make_binary_operators(name, func, default = true, in_place = true)

    if (default)
      make_binary_op(name, :default, func, CernFunctions.binary_helper)
    end
    if (in_place)
      make_binary_op(name + "!", :in_place, func, CernFunctions.binary_helper)
    end

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def make_binary_operator(name, type, func)
    make_binary_op(name, type, func, CernFunctions.binary_helper)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def make_unary_operators(name, func, default = true, in_place = true)

    if (default)
      make_unary_op(name, :default, func, CernFunctions.unary_helper)
    end
    if (in_place)
      make_unary_op(name + "!", :in_place, func, CernFunctions.unary_helper)
    end

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def make_unary_operator(name, type, func)
    make_unary_op(name, type, func, CernFunctions.unary_helper)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def make_comparison_operator(name, func)
    make_binary_op(name, "default", func, CernFunctions.binary_helper, "boolean")
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def cern_binary_function(short_name, long_name, module_name, type)
    [long_name, "CernFunctions", module_name.send(short_name), type, type, type]
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def cern_unary_function(short_name, long_name, module_name, type)
    [long_name, "CernFunctions", module_name.send(short_name), type, type, "void"]
  end

end # CernFunctions

##########################################################################################
#
##########################################################################################

require_relative 'stat_list'
require_relative 'colt_mdarray'
require_relative 'cern_double_functions'

MDArray.functions = "CernFunctions"

