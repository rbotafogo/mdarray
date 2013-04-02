require 'env'
# require 'JMDArray'

# p $CLASSPATH

obj = Object.new

def obj.greeting
  "how are you?"
end

# array = ArrayLoop.new

array_loop = JavaUtilities.get_proxy_class('ArrayLoop')
array_loop.new

p array_loop.new.f(obj) #=> "how are you?"
