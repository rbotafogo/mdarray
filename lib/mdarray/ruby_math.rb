##########################################################################################
#
##########################################################################################

module RubyMath
  extend FunctionCreation
  extend RubyFunctions
  
  @acos = Proc.new { |val| Math.acos(val) }
  @acosh = Proc.new { |val| Math.acosh(val) }
  @asin = Proc.new { |val| Math.asin(val) }
  @asinh = Proc.new { |val| Math.asinh(val) }
  @atan = Proc.new { |val| Math.atan(val) }
  @atan2 = Proc.new { |val| Math.atan2(val) }
  @atanh = Proc.new { |val| Math.atanh(val) }
  @cbrt = Proc.new { |val| Math.cbrt(val) }
  @cos = Proc.new { |val| Math.cos(val) }
  @cosh = Proc.new { |val| Math.cosh(val) }
  @erf = Proc.new { |val| Math.erf(val) }
  @erfc = Proc.new { |val| Math.erfc(val) }
  @exp = Proc.new { |val| Math.exp(val) }
  @gamma = Proc.new { |val| Math.gamma(val) }
  @hypot = Proc.new { |val| Math.hypotn(val) }
  @ldexp = Proc.new { |val| Math.ldexp(val) }
  @log = Proc.new { |val| Math.log(val) }
  @log10 = Proc.new { |val| Math.log10(val) }
  @log2 = Proc.new { |val| Math.log2(val) }
  @sin = Proc.new { |val| Math.sin(val) }
  @sinh = Proc.new { |val| Math.sinh(val) }
  @sqrt = Proc.new { |val| Math.sqrt(val) }
  @tan = Proc.new { |val| Math.tan(val) }
  @tanh = Proc.new { |val| Math.tanh(val) }
  @neg = Proc.new { |val| -1 * val }

  @unary_methods = [:acos, :acosh, :asin, :asinh, :atan, :atan2, 
                    :atanh, :cbrt, :cos, :erf, :exp, :gamma, :hypot, :ldexp, 
                    :log, :log10, :log2, :sin, :sinh, :sqrt, :tan, :tanh, :neg]

  @unary_methods.each do |method|
    make_unary_operators(method.to_s,
                         ruby_unary_function("#{method.to_s}_ruby", 
                                             instance_variable_get("@#{method.to_s}")))
  end

  alias :-@ :neg

end # RubyMath

##########################################################################################
#
##########################################################################################

class NumericalMDArray

  include RubyMath
  
end # NumericalMDArray
