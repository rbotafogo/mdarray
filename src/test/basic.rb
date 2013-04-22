require 'java'
require 'mdarray'

$CLASSPATH << "#{File.dirname(__FILE__)}/../vendor/"

Dir["#{File.dirname(__FILE__)}/../../vendor/*.jar"].each do |jar|
  require jar
end

Dir["#{File.dirname(__FILE__)}/../../target/*.jar"].each do |jar|
  require jar
end


def test
  arr = Java::UcarMa2::Array
  p arr

  bin_op = Java::RbMdarrayLoopsBinops::DefaultBinaryOperator
  a = MDArray.int([2,3,4])
  b = MDArray.int([2,3,4])
  c = MDArray.int([2,3,4])
  bin_op.apply(c, a, b, Proc.new { |val1, val2| val1 + val2 })

end

test
