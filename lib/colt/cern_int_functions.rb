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

  cern_methods = [:and, :compare, :div, :equals, :isEqual, :isGreater, :isLess,
                  :max, :min, :minus, :mod, :mult, :or, :plus, :pow, :shiftLeft,
                  :shiftRightSigned, :shiftRightUnsigned, :xor,
                  :abs, :dec, :factorial, :identity, :inc, :neg, :not, :sign, :square]

  java_alias :unary_and, :and, [Java::int]
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
  java_alias :unary_or, :or, [Java::int]
  java_alias :unary_plus, :plus, [Java::int]
  java_alias :unary_pow, :pow, [Java::int]
  java_alias :unary_shiftLeft, :shiftLeft, [Java::int]
  java_alias :unary_shiftRightSigned, :shiftRightSigned, [Java::int]
  java_alias :unary_shiftRightUnsigned, :shiftRightUnsigned, [Java::int]
  java_alias :unary_xor, :xor, [Java::int]
  
  cern_methods.each do |method|
    field_reader(method)
  end
  
end

##########################################################################################
#
##########################################################################################

module CernIntFunctions
  include_package "cern.jet.math.tint"
  
  class << self
    
    attr_reader :binary_methods
    attr_reader :unary_methods

  end
  
  @binary_methods = [:and, :compare, :div, :equals, :isEqual, :isGreater, :isLess,
                     :max, :min, :minus, :mod, :mult, :or, :plus, :pow, :shiftLeft,
                     :shiftRightSigned, :shiftRightUnsigned, :xor]

  @unary_methods = [:abs, :dec, :factorial, :identity, :inc, :neg, :not, :sign, :square]

  @binary_methods.each do |method|
    attr_reader(":#{method}")
  end

  @unary_methods.each do |method|
    attr_reader(":#{method}")
  end

  def self.double_binary_function(short_name, long_name, module_name)
    [long_name, "CernFunctions", module_name.send(short_name), "int", "int", "int"]
  end

  def self.double_unary_function(short_name, long_name, module_name)
    [long_name, "CernFunctions", module_name.send(short_name), "int", "int", "void"]
  end

  CernIntFunctions.binary_methods.each do |method|
    NumericalMDArray.new_binary_method(method.to_s, 
                                       double_binary_function(method.to_s, "#{method}_int", 
                                                              Java::CernJetMathTint.IntFunctions))
  end

  CernIntFunctions.unary_methods.each do |method|
    NumericalMDArray.new_unary_method(method.to_s, 
                                      double_unary_function(method.to_s, "#{method}_double", 
                                                            Java::CernJetMathTint.IntFunctions))
  end

end

##########################################################################################
#
##########################################################################################

class IntMDArray
  include CernIntFunctions
      
end # IntMDArray
