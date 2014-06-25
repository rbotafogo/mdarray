
##########################################################################################
#
##########################################################################################

module NumericFunctions
  include_package "ucar.ma2.MAMath"
  extend FunctionCreation
  extend RubyFunctions

  class Add
    def self.apply(val1, val2)
      val1 + val2
    end
  end

  class Sub
    def self.apply(val1, val2)
      val1 - val2
    end
  end

  class Mul
    def self.apply(val1, val2)
      val1 * val2
    end
  end

  class Div
    def self.apply(val1, val2)
      val1 / val2
    end
  end

  class Power
    def self.apply(val1, val2)
      val1 ** val2
    end
  end

  class Abs
    def self.apply(val)
      val.abs
    end
  end

  class Ceil
    def self.apply(val)
      val.ceil
    end
  end

  class Floor
    def self.apply(val)
      val.floor
    end
  end

  class Truncate
    def self.apply(val)
      val.truncate
    end
  end

  class IsZero
    def self.apply(val)
      val.zero
    end
  end

  class Square
    def self.apply(val)
      val * val
    end
  end

  class Cube
    def self.apply(val)
      val1 * val * val
    end
  end

  class Fourth
    def self.apply(val)
      val * val * val * val
    end
  end

  class Min
    def self.apply(val1, val2)
      val1 < val2 ? val1 : val2
    end
  end

  class Max
    def self.apply(val1, val2)
      val1 > val2 ? val1 : val2
    end
  end

  @add = NumericFunctions::Add
  @sub = NumericFunctions::Sub
  @mul = NumericFunctions::Mul
  @div = NumericFunctions::Div
  @power = NumericFunctions::Power
  @abs = NumericFunctions::Abs
  @ceil = NumericFunctions::Ceil
  @floor = NumericFunctions::Floor
  @truncate = NumericFunctions::Truncate
  @is_zero = NumericFunctions::IsZero
  @square = NumericFunctions::Square
  @cube = NumericFunctions::Cube
  @fourth = NumericFunctions::Fourth
  @min = NumericFunctions::Min
  @max = NumericFunctions::Max

=begin
  Using Proc is much more inefficient than using classes as defined above

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
=end

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

  class Ge
    def self.apply(val1, val2)
      val1 >= val2 ? true : false
    end
  end

  class Gt
    def self.apply(val1, val2)
      val1 > val2 ? true : false
    end
  end

  class Le
    def self.apply(val1, val2)
      val1 <= val2 ? true : false
    end
  end

  class Lt
    def self.apply(val1, val2)
      val1 < val2 ? true : false
    end
  end

  class Eq
    def self.apply(val1, val2)
      val1 == val2 ? true : false
    end
  end

  @ge = ComparisonOperators::Ge
  @gt = ComparisonOperators::Gt
  @le = ComparisonOperators::Le
  @lt = ComparisonOperators::Lt
  @eq = ComparisonOperators::Eq

=begin
  @ge = Proc.new { |val1, val2| val1 >= val2 ? true : false}
  @gt = Proc.new { |val1, val2| val1 > val2 ? true : false}
  @le = Proc.new { |val1, val2| val1 <= val2 ? true : false}
  @lt = Proc.new { |val1, val2| val1 < val2 ? true : false}
  @eq = Proc.new { |val1, val2| val1 == val2 ? true : false}
=end

  @binary_methods = [:ge, :gt, :le, :lt, :eq]

  @binary_methods.each do |method|
    make_comparison_operator(method.to_s,
                             ruby_binary_function("#{method.to_s}_ruby", 
                                                  instance_variable_get("@#{method.to_s}")))
  end

  alias :>= :ge
  alias :> :gt
  alias :<= :le
  alias :< :lt
  alias :== :eq
  
=begin
  def ==(arg)
    return false if arg == nil
    eq(self, arg)
  end
=end

end # ComparisonOperators

##########################################################################################
#
##########################################################################################

module BitwiseOperators
  extend FunctionCreation
  extend RubyFunctions

  class BinaryAnd
    def self.apply(val1, val2)
      val1 & val2
    end
  end

  class BinaryOr
    def self.apply(val1, val2)
      val1 | val2
    end
  end

  class BinaryXor
    def self.apply(val1, val2)
      val1 ^ val2
    end
  end

  class BinaryLeftShift
    def self.apply(val1, val2)
      val1 << val2
    end
  end

  class BinaryRightShift
    def self.apply(val1, val2)
      val1 >> val2
    end
  end

  class BinaryOnesComplement
    def self.apply(val)
      ~val1
    end
  end

  @binary_and = BitwiseOperators::BinaryAnd
  @binary_or = BitwiseOperators::BinaryOr
  @binary_xor = BitwiseOperators::BinaryXor
  @binary_left_shift = BitwiseOperators::BinaryLeftShift
  @binary_right_shift = BitwiseOperators::BinaryRightShift
  @binary_ones_complement = BitwiseOperators::BinaryOnesComplement

=begin
  @binary_and = Proc.new { |val1, val2| val1 & val2 }
  @binary_or = Proc.new { |val1, val2| val1 | val2 }
  @binary_xor = Proc.new { |val1, val2| val1 ^ val2 }
  @binary_left_shift = Proc.new { |val1, val2| val1 << val2 }
  @binary_right_shift = Proc.new { |val1, val2| val1 >> val2 }
  @binary_ones_complement = Proc.new { |val| ~val }
=end

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
