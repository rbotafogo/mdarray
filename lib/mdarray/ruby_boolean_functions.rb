
##########################################################################################
#
##########################################################################################

module BooleanFunctions
  extend FunctionCreation
  extend RubyFunctions

  class And
    def self.apply(val1, val2)
      val1 and val2
    end
  end

  class Or
    def self.apply(val1, val2)
      val1 or val2
    end
  end

  class Not
    def self.apply(val)
      !val
    end
  end

  @and = BooleanFunctions::And
  @or = BooleanFunctions::Or
  @not = BooleanFunctions::Not

=begin
  @and = Proc.new { |val1, val2| val1 and val2 }
  @or = Proc.new { |val1, val2| val1 or val2 }
  @not = Proc.new { |val1| !val1}
=end

  @binary_methods = [:and, :or]
  
  @unary_methods = [:not]

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
  
  alias :| :or
    alias :& :and

end # BooleanFunctions

##########################################################################################
#
##########################################################################################

class BooleanMDArray

  include BooleanFunctions

end # BooleanMDArray
