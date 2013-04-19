require 'java'

$CLASSPATH << "#{File.dirname(__FILE__)}/../vendor/"

Dir["#{File.dirname(__FILE__)}/../vendor/*.jar"].each do |jar|
   require jar
end
