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

class Java::CernJetMathTdouble::DoubleFunctions
  include_package "cern.jet.math.tdouble"

  cern_methods = [:abs, :acos, :asin, :atan, :atan2, :ceil, :compare, :cos, 
                  :div, :divNeg, :equals, :exp, :floor, :greater, :identity, 
                  :IEEEremainder, :inv, :isEqual, :isGreater, :isLess, :less, :lg, 
                  :log, :log2, :max, :min, :minus, :mod, :mult, :multNeg, 
                  :multSquare, :neg, :plus, :plusAbs, :pow, :rint, :sign, :sin, 
                  :sqrt, :square, :tan]

  java_alias :unary_compare, :compare, [Java::double]
  java_alias :unary_equals, :equals, [Java::double]
  java_alias :unary_greater, :greater, [Java::double]
  java_alias :unary_less, :less, [Java::double]
  java_alias :unary_is_equal, :isEqual, [Java::double]
  java_alias :unary_is_greater, :isGreater, [Java::double]
  java_alias :unary_is_less, :isLess, [Java::double]
  java_alias :unary_ieee_remainder, :IEEEremainder, [Java::double]
  java_alias :unary_div, :div, [Java::double]
  java_alias :unary_plus, :plus, [Java::double]
  java_alias :unary_minus, :minus, [Java::double]
  java_alias :unary_mod, :mod, [Java::double]
  java_alias :unary_mult, :mult, [Java::double]
  java_alias :unary_pow, :pow, [Java::double]
  java_alias :unary_lg, :lg, [Java::double]
  
  cern_methods.each do |method|
    field_reader(method)
  end

end

##########################################################################################
#
##########################################################################################

module CernDoubleFunctions
  include_package "cern.jet.math.tdouble"
  extend FunctionCreation
  extend CernFunctions
  
  @binary_methods = [:compare, :div, :divNeg, :equals, :greater, :isEqual, :isGreater, 
                     :isLess, :less, :mod, :max, :min, :mult, :multNeg, :multSquare, 
                     :plus, :pow, :square]

  @unary_methods = [:abs, :acos, :asin, :atan, :atan2, :ceil, :cos, :exp, :floor, 
                    :identity, :IEEEremainder, :inv, :lg, :log, :log2, :minus, :neg, 
                    :plusAbs, :rint, :sign, :sin, :sqrt, :tan]

  @binary_methods.each do |method|
    attr_reader(":#{method}")
  end

  @unary_methods.each do |method|
    attr_reader(":#{method}")
  end

  @binary_methods.each do |method|
    make_binary_operators(method.to_s,
                          cern_binary_function(method.to_s, "#{method}_double", 
                                               Java::CernJetMathTdouble.DoubleFunctions,
                                               "double"))
  end

  @unary_methods.each do |method|
    make_unary_operators(method.to_s, 
                         cern_unary_function(method.to_s, "#{method}_double", 
                                             Java::CernJetMathTdouble.DoubleFunctions,
                                             "double"))
  end

  # making add an alias to plus
  map = cern_binary_function("plus", "plus_double", Java::CernJetMathTdouble.DoubleFunctions,
                             "double")
  MDArray.register_function("add", map, 2, CernFunctions.binary_helper)


end

##########################################################################################
#
##########################################################################################

class DoubleMDArray

  include CernDoubleFunctions
      
end # DoubleMDArray
