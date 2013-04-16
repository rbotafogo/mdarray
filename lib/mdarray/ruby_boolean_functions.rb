
##########################################################################################
#
##########################################################################################

module BooleanFunctions
  extend FunctionCreation
  extend RubyFunctions

  @and = Proc.new { |val1, val2| val1 and val2 }
  @or = Proc.new { |val1, val2| val1 or val2 }
  @not = Proc.new { |val1| !val1}

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
