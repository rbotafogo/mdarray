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

require 'java'

##########################################################################################
#
##########################################################################################

class Java::CernJetMathTint::IntFunctions
  include_package "cern.jet.math.tint"

  cern_methods = [:abs, :compare, :div, :divNeg, :equals, :isEqual, :isGreater, :isLess,
                  :max, :min, :minus, :mod, :mult, :multNeg, :multSquare, :neg, :plus, 
                  :plusAbs, :pow, :sign, :square,
                  :and, :dec, :factorial, :inc, :not, :or, :shiftLeft,
                  :shiftRightSigned, :shiftRightUnsigned, :xor]

  # methods that also exist for types double and float
  java_alias :unary_compare, :compare, [Java::int]
  java_alias :unary_div, :div, [Java::int]
  java_alias :unary_equals, :equals, [Java::int]
  java_alias :unary_isEqual, :isEqual, [Java::int]
  java_alias :unary_isGreater, :isGreater, [Java::int]
  java_alias :unary_isLess, :isLess, [Java::int]
  java_alias :unary_max, :max, [Java::int]
  java_alias :unary_min, :min, [Java::int]
  java_alias :unary_minus, :minus, [Java::int]
  java_alias :unary_mod, :mod, [Java::int]
  java_alias :unary_mult, :mult, [Java::int]
  java_alias :unary_plus, :plus, [Java::int]
  java_alias :unary_pow, :pow, [Java::int]

  # methods that only exist for types long and int
  java_alias :unary_and, :and, [Java::int]
  java_alias :unary_or, :or, [Java::int]
  java_alias :unary_shiftLeft, :shiftLeft, [Java::int]
  java_alias :unary_shiftRightSigned, :shiftRightSigned, [Java::int]
  java_alias :unary_shiftRightUnsigned, :shiftRightUnsigned, [Java::int]
  java_alias :unary_xor, :xor, [Java::int]

  
  cern_methods.each do |method|
    field_reader(method)
    attr_reader(":#{method}")
  end
  
end

##########################################################################################
#
##########################################################################################

module CernIntFunctions
  include_package "cern.jet.math.tint"
  extend FunctionCreation
  extend CernFunctions
  
  binary_methods = [:compare, :div, :divNeg, :equals, :minus, :mod, :mult, :multNeg, 
                    :multSquare, :plus, :plusAbs, :pow, 
                    :and, :or, :shiftLeft, :shiftRightSigned, :shiftRightUnsigned, :xor]

  unary_methods = [:abs, :neg, :sign, :square, :dec, :factorial, :inc, :not]

  comparison_methods = [:isEqual, :isGreater, :isLess]

  binary_conflict_methods = [:max, :min]

  binary_methods.each do |method|
    make_binary_operators(method.to_s,
                          cern_binary_function(method.to_s, "#{method}_int", 
                                               Java::CernJetMathTint.IntFunctions,
                                               "int"))
  end

  unary_methods.each do |method|
    make_unary_operators(method.to_s, 
                         cern_unary_function(method.to_s, "#{method}_int", 
                                             Java::CernJetMathTint.IntFunctions,
                                             "int"))
  end

  comparison_methods.each do |method|
    make_comparison_operator(method.to_s, 
                             cern_comparison_function(method.to_s, "#{method}_double", 
                                                      Java::CernJetMathTint.IntFunctions,
                                                      "int"))
  end
  
  binary_conflict_methods.each do |method|
    make_binary_operators("cern_#{method}",
                          cern_binary_function(method.to_s, "cern_#{method}_double", 
                                               Java::CernJetMathTint.IntFunctions,
                                               "int"))
  end
  
  def self.register(als, name, int_name, type)
    map = cern_binary_function(name, int_name, Java::CernJetMathTint.IntFunctions,
                               type)
    MDArray.register_function(als, map, 2, CernFunctions.binary_helper)
  end

  alias :div_neg :divNeg
  alias :is_equal :isEqual
  alias :is_greater :isGreater
  alias :is_less :isLess
  alias :mult_neg :multNeg
  alias :mult_square :multSquare
  alias :plus_abs :plusAbs
  alias :shift_left :shiftLeft
  alias :shift_right_signed :shiftRightSigned
  alias :shift_right_unsigned :shiftRightUnsigned

  register(:add, :plus, :plus_int, "int")
  register(:sub, :minus, :minus_int, "int")
  register(:mul, :mult, :mult_int, "int")
  register(:power, :pow, :pow_int, "int")
  register(:eq, :equals, :equals_int, "int")
  register(:gt, :isGreater, :is_greater_int, "int")
  register(:lt, :isLess, :is_less_int, "int")
  register(:binary_left_shift, :shiftLeft, :shift_left_int, "int")
  register(:binary_right_shift, :shiftRightSigned, :shift_right_int, "int")

end

##########################################################################################
#
##########################################################################################

class IntMDArray

  include CernIntFunctions
      
end # IntMDArray
