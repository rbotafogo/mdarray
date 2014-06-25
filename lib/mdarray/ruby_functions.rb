# -*- coding: utf-8 -*-

##########################################################################################
# Copyright © 2013 Rodrigo Botafogo. All Rights Reserved. Permission to use, copy, modify, 
# and distribute this software and its documentation, without fee and without a signed 
# licensing agreement, is hereby granted, provided that the above copyright notice, this 
# paragraph and the following two paragraphs appear in all copies, modifications, and 
# distributions.
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

module RubyFunctions

  class << self
    attr_reader :binary_helper
    attr_reader :unary_helper
  end

  @binary_helper = Java::RbMdarrayLoopsBinops
  @unary_helper = Java::RbMdarrayLoopsUnops

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def make_binary_operators(name, func, default = true, in_place = true)

    if (default)
      make_binary_op(name, :default, func, RubyFunctions.binary_helper)
    end
    if (in_place)
      make_binary_op(name + "!", :in_place, func, RubyFunctions.binary_helper)
    end

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def make_binary_operator(name, type, func)
    make_binary_op(name, type, func, RubyFunctions.binary_helper)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def make_unary_operators(name, func, default = true, in_place = true)

    if (default)
      make_unary_op(name, :default, func, RubyFunctions.unary_helper)
    end
    if (in_place)
      make_unary_op(name + "!", :in_place, func, RubyFunctions.unary_helper)
    end

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def make_unary_operator(name, type, func)
    make_unary_op(name, type, func, RubyFunctions.unary_helper)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def make_comparison_operator(name, func)

    make_binary_op("_#{name}", "default", func, RubyFunctions.binary_helper, "boolean")

    define_method(name) do |op2, requested_type = nil, *args|
      return false if op2 == nil
      self.send("_#{name}", op2, requested_type, *args)
    end

  end
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def ruby_binary_function(long_name, proc)
    [long_name, "RubyFunctions", proc, "*", "*", "*"]
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def ruby_unary_function(long_name, proc)
    [long_name, "RubyFunctions", proc, "*", "*", "*"]
  end

end # RubyFunctions

##########################################################################################
#
##########################################################################################

module UserFunction
  extend RubyFunctions

  #---------------------------------------------------------------------------------------
  # Creates a binary operator in the given class.  For direct creation of operators
  # directly by the user.
  #---------------------------------------------------------------------------------------

  def self.binary_operator(name, exec_type, func, where, force_type = nil, 
                           pre_condition = nil, post_condition = nil)

    function = ruby_binary_function("#{name}_user", func)
    klass = Object.const_get("#{where.capitalize}MDArray")
    klass.make_binary_op(name, exec_type, function, RubyFunctions.binary_helper, 
                         force_type, pre_condition, post_condition)

  end

  #---------------------------------------------------------------------------------------
  # Creates a unary operator in the given class.  For direct creation of operators
  # directly by the user.
  #---------------------------------------------------------------------------------------

  def self.unary_operator(name, exec_type, func, where, force_type = nil, 
                          pre_condition = nil, post_condition = nil)

    function = ruby_unary_function("#{name}_user", func)
    klass = Object.const_get("#{where.capitalize}MDArray")
    klass.make_unary_op(name, exec_type, function, RubyFunctions.unary_helper, force_type, 
                        pre_condition, post_condition)

  end

end # UserFunction

require_relative 'ruby_generic_functions'
require_relative 'ruby_numeric_functions'
require_relative 'ruby_math'
require_relative 'ruby_boolean_functions'
require_relative 'ruby_stats'

MDArray.functions = "RubyFunctions"
