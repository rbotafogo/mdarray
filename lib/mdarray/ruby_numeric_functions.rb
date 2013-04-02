
##########################################################################################
#
##########################################################################################

module NumericFunctions
  include_package "ucar.ma2.MAMath"

  extend FunctionCreation
  extend RubyFunctions

  @add = Proc.new { |val1, val2| val1 + val2 }
  @sub = Proc.new { |val1, val2| val1 - val2 }
  @mul = Proc.new { |val1, val2| val1 * val2 }
  @div = Proc.new { |val1, val2| val1 / val2 }
  @power = Proc.new { |val1, val2| val1 ** val2 }
  @abs = Proc.new { |val| val.abs }
  @ceil = Proc.new { |val| val.ceil }
  @floor = Proc.new { |val| val.floor }
  @truncate = Proc.new { |val| val.truncate }
  @is_zero = Proc.new { |val| val.zero }
  @square = Proc.new { |val| val ** 2 }
  @cube = Proc.new { |val| val ** 3 }
  @fourth = Proc.new { |val| val ** 4 }
  
  @min = Proc.new { |val1, val2| val1 < val2 ? val1 : val2 }
  @max = Proc.new { |val1, val2| val1 > val2 ? val1 : val2 }
  
  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def zero?(val)
    @is_zero.call(val)
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def fast_add(other_val)
    arr = Java::UcarMa2::MAMath.add(@nc_array, other_val.nc_array)
  end
  
  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------


  @binary_methods = [:add, :sub, :mul, :div, :power, :min, :max]
  
  @unary_methods = [:abs, :ceil, :floor, :truncate, :is_zero, :square, 
                    :cube, :fourth]
  
  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  @binary_methods.each do |method|
    make_binary_operators(method.to_s,
                          ruby_binary_function("#{method.to_s}_ruby", 
                                               instance_variable_get("@#{method.to_s}")))
  end
  
  @unary_methods.each do |method|
    make_unary_operators(method.to_s,
                         ruby_unary_function("#{method.to_s}_ruby", 
                                             instance_variable_get("@#{method.to_s}")))
  end

  #======================================================================================
  # Arithmetic
  #======================================================================================

  alias :+ :add
  alias :- :sub
  alias :* :mul
  alias :/ :div
  alias :** :power
  alias :addAssign :add!
  alias :subAssign :sub!
  alias :mulAssign :mul!
  alias :powAssign :power!

end # NumericFunctions

##########################################################################################
#
##########################################################################################

module ComparisonOperators
  extend FunctionCreation
  extend RubyFunctions

  @ge = Proc.new { |val1, val2| val1 >= val2 ? true : false}
  @gt = Proc.new { |val1, val2| val1 > val2 ? true : false}
  @le = Proc.new { |val1, val2| val1 <= val2 ? true : false}
  @lt = Proc.new { |val1, val2| val1 < val2 ? true : false}
  @eq = Proc.new { |val1, val2| val1 == val2 ? true : false}

  @binary_methods = [:ge, :gt, :le, :lt, :eq]

  @binary_methods.each do |method|
    make_comparison_op(method.to_s,
                       ruby_binary_function("#{method.to_s}_ruby", 
                                            instance_variable_get("@#{method.to_s}")))
  end

  alias :>= :ge
  alias :> :gt
  alias :<= :le
  alias :< :lt
  alias :== :eq

end # ComparisonOperators

##########################################################################################
#
##########################################################################################

module BitwiseOperators
  extend FunctionCreation
  extend RubyFunctions

  @binary_and = Proc.new { |val1, val2| val1 & val2 }
  @binary_or = Proc.new { |val1, val2| val1 | val2 }
  @binary_xor = Proc.new { |val1, val2| val1 ^ val2 }
  @binary_left_shift = Proc.new { |val1, val2| val1 << val2 }
  @binary_right_shift = Proc.new { |val1, val2| val1 >> val2 }

  @binary_ones_complement = Proc.new { |val| ~val }
  
  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------


  @binary_methods = [:binary_and, :binary_or, :binary_xor, :binary_left_shift,
                     :binary_right_shift]
  
  @unary_methods = [:binary_ones_complement]
  
  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  @binary_methods.each do |method|
    make_binary_operators(method.to_s,
                          ruby_binary_function("#{method.to_s}_ruby", 
                                               instance_variable_get("@#{method.to_s}")))
  end
  
  @unary_methods.each do |method|
    make_unary_operators(method.to_s,
                         ruby_unary_function("#{method.to_s}_ruby", 
                                             instance_variable_get("@#{method.to_s}")))
  end

  alias :& :binary_and
  alias :| :binary_or
  alias :^ :binary_xor
  alias :~ :binary_ones_complement
  alias :<< :binary_left_shift
  alias :>> :binary_right_shift

end # BitwiseOperators

##########################################################################################
#
##########################################################################################

class NumericalMDArray

  include NumericFunctions
  include ComparisonOperators

end # NumericalMDArray

##########################################################################################
#
##########################################################################################

class LongMDArray

  include BitwiseOperators

end # LongMDArray
