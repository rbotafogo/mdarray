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

class NumericalMDArray < MDArray

  def coerce(num)
    coerced_mdarray = coerced_build(@type, @nc_array)
    [coerced_mdarray, num]
  end

end # NumericalMDArray

##########################################################################################
#
##########################################################################################

class DoubleMDArray < NumericalMDArray

end # DoubleMDArray

##########################################################################################
#
##########################################################################################

class FloatMDArray < DoubleMDArray

end # FloatMDArray

##########################################################################################
#
##########################################################################################

class LongMDArray < FloatMDArray

end # LongMDArray

##########################################################################################
#
##########################################################################################

class IntMDArray < LongMDArray

end # IntMDArray

##########################################################################################
#
##########################################################################################

class ShortMDArray < IntMDArray

end # ShortMDArray

##########################################################################################
#
##########################################################################################

class ByteMDArray < ShortMDArray

end # ByteMDArray



##########################################################################################
#
##########################################################################################

# Non numerical arrays

##########################################################################################
#
##########################################################################################

class NonNumericalMDArray < MDArray

end

##########################################################################################
#
##########################################################################################

class BooleanMDArray < NonNumericalMDArray
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.make_boolean_op(name, func)
    define_method(name) do |other_val|
      boolean_op(other_val, func)
    end
  end
  
  #---------------------------------------------------------------------------------------
  # 
  #---------------------------------------------------------------------------------------

  def boolean_op(other_val, method)
    result = MDArray.build("boolean", shape)
    exec_boolean_op(result, other_val, method)
  end

  #======================================================================================
  # Logical
  #======================================================================================

  def self.and(val1, val2)
    val1 and val2
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.or(val1, val2)
    val1 or val2
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.not(val1)
    !val1
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  # make_binary_methods("and", BooleanMDArray.method(:and))
  # make_binary_methods("or", BooleanMDArray.method(:or))

  make_boolean_op("and", BooleanMDArray.method(:and))
  make_boolean_op("or", BooleanMDArray.method(:or))

  alias :| :or
    alias :& :and
    
end

##########################################################################################
#
##########################################################################################

class StringMDArray < NonNumericalMDArray
    
end

##########################################################################################
#
##########################################################################################

class StructureMDArray < NonNumericalMDArray
    
end
