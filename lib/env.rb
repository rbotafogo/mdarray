require 'java'
require_relative '../config.rb'

$CLASSPATH << "#{File.dirname(__FILE__)}/../vendor/"

Dir["#{File.dirname(__FILE__)}/../vendor/*.jar"].each do |jar|
  require jar
end

Dir["#{File.dirname(__FILE__)}/../target/*.jar"].each do |jar|
  require jar
end
