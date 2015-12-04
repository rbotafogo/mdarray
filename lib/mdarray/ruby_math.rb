##########################################################################################
#
##########################################################################################

module RubyMath
  extend FunctionCreation
  extend RubyFunctions

  class Acos
    def self.apply(val)
      Math.acos(val)
    end
  end

  class Acosh
    def self.apply(val)
      Math.acosh(val)
    end
  end

  class Asin
    def self.apply(val)
      Math.asin(val)
    end
  end

  class Asinh
    def self.apply(val)
      Math.asinh(val)
    end
  end

  class Atan
    def self.apply(val)
      Math.atan(val)
    end
  end

  class Atan2
    def self.apply(val)
      Math.atan2(val)
    end
  end

  class Atanh
    def self.apply(val)
      Math.atanh(val)
    end
  end

  class Cbrt
    def self.apply(val)
      Math.cbrt(val)
    end
  end

  class Cos
    def self.apply(val)
      Math.cos(val)
    end
  end

  class Cosh
    def self.apply(val)
      Math.cosh(val)
    end
  end

  class Erf
    def self.apply(val)
      Math.erf(val)
    end
  end

  class Erfc
    def self.apply(val)
      Math.erfc(val)
    end
  end

  class Exp
    def self.apply(val)
      Math.exp(val)
    end
  end

  class Gamma
    def self.apply(val)
      Math.gamma(val)
    end
  end

  class Hypot
    def self.apply(val)
      Math.hypot(val)
    end
  end

  class Ldexp
    def self.apply(val)
      Math.ldexp(val)
    end
  end

  class Log
    def self.apply(val)
      Math.log(val)
    end
  end

  class Log10
    def self.apply(val)
      Math.log10(val)
    end
  end

  class Log2
    def self.apply(val)
      Math.log2(val)
    end
  end

  class Sin
    def self.apply(val)
      Math.sin(val)
    end
  end

  class Sinh
    def self.apply(val)
      Math.sinh(val)
    end
  end

  class Sqrt
    def self.apply(val)
      Math.sqrt(val)
    end
  end

  class Tan
    def self.apply(val)
      Math.tan(val)
    end
  end

  class Tanh
    def self.apply(val)
      Math.tanh(val)
    end
  end

  class Neg
    def self.apply(val)
      -1 * val
    end
  end

  @acos = RubyMath::Acos
  @acosh = RubyMath::Acosh
  @asin = RubyMath::Asin
  @asinh = RubyMath::Asinh
  @atan = RubyMath::Atan
  @atan2 = RubyMath::Atan2
  @atanh = RubyMath::Atanh
  @cbrt = RubyMath::Cbrt
  @cos = RubyMath::Cos
  @cosh = RubyMath::Cosh
  @erf = RubyMath::Erf
  @erfc = RubyMath::Erfc
  @exp = RubyMath::Exp
  @gamma = RubyMath::Gamma
  @hypot = RubyMath::Hypot
  @ldexp = RubyMath::Ldexp
  @log = RubyMath::Log
  @log10 = RubyMath::Log10
  @log2 = RubyMath::Log2
  @sin = RubyMath::Sin
  @sinh = RubyMath::Sinh
  @sqrt = RubyMath::Sqrt
  @tan = RubyMath::Tan
  @tanh = RubyMath::Tanh
  @neg = RubyMath::Neg

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
