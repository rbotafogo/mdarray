##########################################################################################
#
##########################################################################################

module RubyStats
  extend FunctionCreation
  extend RubyFunctions

  #======================================================================================
  # Statistics
  #======================================================================================


  #---------------------------------------------------------------------------------------
  # Sums all values
  #---------------------------------------------------------------------------------------

  func = ["ruby_sum", "RubyFunction", Proc.new { |sum, val| sum + val }, "*", "*", "void"] 
  make_unary_op("sum", "reduce", func, nil, Proc.new { 0 })

  #---------------------------------------------------------------------------------------
  # calculates the minimum
  #---------------------------------------------------------------------------------------

  pre_calc = Proc.new { |arr1, *args| arr1[0] }
  calc = Proc.new { |min, val| min = ((min < val)? min : val) } 
  func = ["ruby_min", "RubyFunction", calc, "*", "*", "void"] 
  make_unary_op("min", :reduce, func, nil, pre_calc)

  #---------------------------------------------------------------------------------------
  # calculates the maximum
  #---------------------------------------------------------------------------------------

  pre_calc = Proc.new { |arr1, *args| arr1[0] }
  calc = Proc.new { |max, val| max = (max > val)? max : val }
  func = ["ruby_max", "RubyFunction", calc, "*", "*", "void"] 
  make_unary_op("max", :reduce, func, nil, pre_calc)

  #---------------------------------------------------------------------------------------
  # calculates the mean
  #---------------------------------------------------------------------------------------

  pre_calc = Proc.new { 0 }
  calc = Proc.new { |start, val| start += val }
  post_calc = Proc.new do |result, *args|
    arr = args.shift
    if (arr.size == 0)
      next nil
    end
    result / arr.size
  end
  func = ["ruby_mean", "RubyFunction", calc, "*", "*", "void"] 
  make_unary_op("mean", :reduce, func, nil, pre_calc, post_calc)

  #---------------------------------------------------------------------------------------
  # calculates the weighted mean
  #---------------------------------------------------------------------------------------

  pre_calc = Proc.new { [0, 0] }
  calc = Proc.new do |result, val, weight|
    result[0] += (val * weight)
    result[1] += weight
    result
  end
  post_calc = Proc.new do |result, *args|
    arr = args.shift
    if (arr.size == 0)
      next [nil, nil]
    end
    [result[0] / result[1], arr.size] 
  end
  func = ["ruby_weighted_mean", "RubyFunction", calc, "*", "*", "void"] 
  make_binary_op("weighted_mean", :complex_reduce, func, nil, pre_calc, post_calc)
  
end # RubyStats

##########################################################################################
#
##########################################################################################

class DoubleMDArray

  include RubyStats
  
end



=begin
  #---------------------------------------------------------------------------------------
  # Expectation value
  #---------------------------------------------------------------------------------------

  pre_calc = Proc.new do |*args|
    arr = args.shift
    mean = arr.mean
    method = MDArray.method(:square).to_proc * MDArray.method(:sub).to_proc.bind2nd(mean)
    [0, 0, method]
  end

  calc = Proc.new do |result, val, method|
    result[0] += (method.call(val) * weight)
    result[1] += weight
    result
  end
  
  post_calc = Proc.new do |result, *args|
    arr = args.shift
    if (arr.size == 0)
      next nil
    end
    result / arr.size
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def mean
    expectation_value(Proc.identity, Proc.everywhere)[0]
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def variance

    s2 = expectation_value(MDArray.method(:square).to_proc * 
                           MDArray.method(:sub).to_proc.bind2nd(mean),
                           Proc.everywhere)[0]
    return s2*size/(size-1)
    
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def expectation_value(method, in_range, weight = nil)

    num = 0
    den = 0
    n = 0
    each do |elmt|
      if (in_range.call(elmt))
        num += method.call(elmt)
        den += 1
        n += 1
      end
    end
    if (n == 0)
      return [nil, nil]
    else
      return [num / den, n]
    end

  end

  # calculates the mean

=end
