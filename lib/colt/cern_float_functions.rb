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

# require 'jruby/core_ext'

##########################################################################################
#
##########################################################################################

class Java::CernJetMathTfloat::FloatFunctions
  include_package "cern.jet.math.tfloat"

  cern_methods = [:abs, :acos, :asin, :atan, :atan2, :ceil, :compare, :cos, 
                  :div, :divNeg, :equals, :exp, :floor, :greater, :identity,
                  :IEEEremainder, :inv, :isEqual, :isGreater, :isLess, :less, :lg, 
                  :log, :log2, :max, :min, :minus, :mod, :mult, :multNeg, 
                  :multSquare, :neg, :plus, :plusAbs, :pow, :rint, :sign, :sin, 
                  :sqrt, :square, :tan]

  # java_alias :unary_atan2, :atan2, [Java::float]
  java_alias :unary_compare, :compare, [Java::float]
  java_alias :unary_div, :div, [Java::float]
  # java_alias :unary_div_neg, :divNeg, [Java::float]
  java_alias :unary_equals, :equals, [Java::float]
  java_alias :unary_greater, :greater, [Java::float]
  java_alias :unary_ieee_remainder, :IEEEremainder, [Java::float]
  java_alias :unary_is_equal, :isEqual, [Java::float]
  java_alias :unary_is_greater, :isGreater, [Java::float]
  java_alias :unary_is_less, :isLess, [Java::float]
  java_alias :unary_less, :less, [Java::float]
  java_alias :unary_lg, :lg, [Java::float]
  # java_alias :unary_log2, :log2, [Java::float]
  java_alias :unary_mod, :mod, [Java::float]
  java_alias :unary_max, :max, [Java::float]
  java_alias :unary_min, :min, [Java::float]
  java_alias :unary_minus, :minus, [Java::float]
  java_alias :unary_mult, :mult, [Java::float]
  # java_alias :unary_mult_neg, :multNeg, [Java::float]
  # java_alias :unary_mult_square, :multSquare, [Java::float]
  java_alias :unary_plus, :plus, [Java::float]
  # java_alias :unary_plus_abs, :plusAbs, [Java::float]
  java_alias :unary_pow, :pow, [Java::float]
  
  cern_methods.each do |method|
    field_reader(method)
    attr_reader(":#{method}")
  end

end

##########################################################################################
#
##########################################################################################

module CernFloatFunctions
  include_package "cern.jet.math.tfloat"
  extend FunctionCreation
  extend CernFunctions

  binary_methods = [:atan2, :compare, :div, :divNeg, :equals, :greater, :IEEEremainder,
                    :less, :lg, :mod, :minus, :mult, :multNeg, :multSquare, :plus, 
                    :plusAbs, :pow]

  unary_methods = [:abs, :acos, :asin, :atan, :ceil, :cos, :exp, :floor, :identity, :inv, 
                   :log, :neg, :rint, :sign, :sin, :sqrt, :square, :tan]

  comparison_methods = [:isEqual, :isGreater, :isLess]

  binary_conflict_methods = [:max, :min]

  unary_conflict_methods = [:log2]

  binary_methods.each do |method|
    make_binary_operators(method.to_s,
                          cern_binary_function(method.to_s, "#{method}_float", 
                                               Java::CernJetMathTfloat.FloatFunctions,
                                               "float"))
  end
  
  unary_methods.each do |method|
    make_unary_operators(method.to_s, 
                         cern_unary_function(method.to_s, "#{method}_float", 
                                             Java::CernJetMathTfloat.FloatFunctions,
                                             "float"))
  end
  
  comparison_methods.each do |method|
    make_comparison_operator(method.to_s, 
                             cern_comparison_function(method.to_s, "#{method}_float", 
                                                      Java::CernJetMathTfloat.FloatFunctions,
                                                      "float"))
  end
  
  binary_conflict_methods.each do |method|
    make_binary_operators("cern_#{method}",
                          cern_binary_function(method.to_s, "cern_#{method}_float", 
                                               Java::CernJetMathTfloat.FloatFunctions,
                                               "float"))
  end

  unary_conflict_methods.each do |method|
    make_unary_operators("cern_#{method}",
                         cern_unary_function(method.to_s, "cern_#{method}_float", 
                                             Java::CernJetMathTfloat.FloatFunctions,
                                             "float"))
  end

  def self.register(als, name, long_name, type)
    map = cern_binary_function(name, long_name, Java::CernJetMathTfloat.FloatFunctions,
                               type)
    MDArray.register_function(als, map, 2, CernFunctions.binary_helper)
  end

  alias :div_neg :divNeg
  alias :is_equal :isEqual
  alias :is_greater :isGreater
  alias :is_less :isLess
  alias :mult_neg :multNeg
  alias :mult_square :multSquare
  alias :ieee_remainder :IEEEremainder
  alias :plus_abs :plusAbs

  register(:add, :plus, :plus_float, "float")
  register(:sub, :minus, :minus_float, "float")
  register(:mul, :mult, :mult_float, "float")
  register(:power, :pow, :pow_float, "float")
  register(:eq, :equals, :equals_float, "float")
  register(:gt, :isGreater, :is_greater_float, "float")
  register(:lt, :isLess, :is_less_float, "float")
  register(:div_neg, :divNeg, :div_neg_float, "float")
  register(:ieee_remainder, :IEEEremainder, :ieee_remainder_float, "float")
  register(:mult_neg, :multNeg, :mult_neg_float, "float")
  register(:mult_square, :multSquare, :mult_square_float, "float")
  register(:plus_abs, :plusAbs, :plus_abs_float, "float")

  register(:is_equal, :isEqual, :is_equal_float, "float")
  register(:is_greater, :isGreater, :is_greater_float, "float")
  register(:is_less, :isLess, :is_less_float, "float")

  # methods bellow are defined as ruby methods and are slower than the above methods. 
  # there are no similar methods defined in Colt/Parallel Colt.  If performance is
  # needed, then this methods need to be defined in Java.
  # @acosh = RubyMath::Acosh
  # @asinh = RubyMath::Asinh
  # @atanh = RubyMath::Atanh
  # @cbrt = RubyMath::Cbrt
  # @cosh = RubyMath::Cosh
  # @erf = RubyMath::Erf
  # @erfc = RubyMath::Erfc
  # @gamma = RubyMath::Gamma
  # @hypot = RubyMath::Hypot
  # @ldexp = RubyMath::Ldexp
  # @log10 = RubyMath::Log10
  # @sinh = RubyMath::Sinh
  # @tanh = RubyMath::Tanh

  # @truncate = NumericFunctions::Truncate
  # @is_zero = NumericFunctions::IsZero
  # @cube = NumericFunctions::Cube
  # @fourth = NumericFunctions::Fourth
  # @ge = ComparisonOperators::Ge
  # @le = ComparisonOperators::Le

end

##########################################################################################
#
##########################################################################################

class FloatMDArray

  include CernFloatFunctions
      
end # FloatMDArray
