require 'rubygems'
require "test/unit"
require 'shoulda'
require 'jruby/profiler'

require 'benchmark'
require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "Speed Tests" do

    setup do
      
      p "starting performance testing"
      
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "be faster lazy than eager" do

      @a = MDArray.typed_arange("double", 10_000_000)
      @b = MDArray.typed_arange("double", 10_000_000)
      # @c = MDArray.arange(100_000_000)
      # @d = MDArray.arange(100_000_000)

#=end

      MDArray.lazy = true
      puts "Benchmarking: 4 element expression lazyly"

      profile_data = JRuby::Profiler.profile do
        puts Benchmark.measure {
          c = (@a + @b + @a + @b * @b * @b * @b * @b * @b * @b)[]
          # c = (@a + @b * @c - @d)[]
          # c = (@a + @b)[]
          # c = (@a * @a + @b * @b + @a * @b)[]
        }
      end

      profile_printer = JRuby::Profiler::FlatProfilePrinter.new(profile_data)
      profile_printer.printProfile(STDOUT)

      MDArray.lazy = false

#=begin
      puts "========================="
      puts "Benchmarking: 4 element expression eagerly"

      profile_data = JRuby::Profiler.profile do
        puts Benchmark.measure {
          # c = (@a * @a + @b * @b + @a * @b)
          #c = @a + @b + @c + @d
          c = @a + @b + @a + @b * @b * @b * @b * @b * @b * @b
        }
      end

      profile_printer = JRuby::Profiler::FlatProfilePrinter.new(profile_data)
      profile_printer.printProfile(STDOUT)

=begin
      profile_data = JRuby::Profiler.profile do
        c = (@a + @b * @c - @d)
        c[]
      end
=end

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

=begin
    should "test basic operations" do

      @a = MDArray.typed_arange("double", 10_000_000)
      @b = MDArray.typed_arange("double", 10_000_000)
      @c = MDArray.arange(10_000_000)
      @d = MDArray.arange(10_000_000)

      binary_operators = [RubyBinaryOperator, FastBinaryOperator]
      unary_operators = [RubyUnaryOperator, FastUnaryOperator]

      puts "FastBinaryOperator and FastUnaryOperator are the default operator for MDArray" 
      puts "and those are the expected execution times. "
      puts "FastBinaryOperator sends loops to Java for performance improvement."
      puts "RubyBinaryOperator and RubyUnaryOperator are left in the code for testing purposes"
      puts "only and to compare how much improvement can be obtained."
      puts "In the future, if Ruby becomes more efficient there might be no reason to"
      puts "implement loops in Java."
      puts
      puts "Note that huge improvement (fast_add) can be obtained by implementing operator "
      puts "methods completely in Java."

      binary_operators.each do |operator|

        MDArray.binary_operator = operator

        puts "========================="
        puts "Benchmarking: #{operator}"

        puts "Benchmarking double operations"
        puts "Benchmarking addition of two large arrays of size 10_000_000"
        puts Benchmark.measure {
          c = @a + @b
        }
        
        puts "Benchmarking subtraction of two large arrays of size 10_000_000"
        puts Benchmark.measure {
          c = @a - @b
        }
        
        puts "Benchmarking addition of two large arrays of size 10_000_000"
        puts "Checking if compiler still does improvements after 20_000_000 operations"
        puts Benchmark.measure {
          c = @a + @b
        }
        
        puts "========================="
        puts "Benchmarking fast_add.  fast_add is a Java method to add the two double arrays."
        puts "Notice that performance can be greatly improved by implementing methods in Java"
        puts Benchmark.measure {
          c = @a.fast_add(@b)
        }
        puts "========================="
        
        puts "Benchmarking int operations"
        puts "In my machine, there is very little performance difference between double and int"
        puts "Benchmarking addition of two large arrays of size 10_000_000"
        puts Benchmark.measure {
          c = @c + @d
        }
        
        puts "Benchmarking subtraction of two large arrays of size 10_000_000"
        puts Benchmark.measure {
          c = @c - @d
        }
        
        puts "Benchmarking addition of two large arrays of size 10_000_000"
        puts "Checking if compiler still does improvements after 20_000_000 operations"
        puts Benchmark.measure {
          c = @c + @d
        }

      end

    end
=end

=begin
    should "test inner product" do

      @a = MDArray.typed_arange("double", 10_000_000)
      @b = MDArray.typed_arange("double", 10_000_000)

      # define inner_product for the whole hierarchy as it defines it for double
      UserFunction.binary_operator("inner_product", "reduce", 
                                   Proc.new { |sum, val1, val2| sum + (val1 * val2) }, 
                                   "double", nil, Proc.new { 0 })

      puts "Measuring inner_product of two arrays of size: 10.000.000 in seconds"
      puts "Since inner product is more complex than a simple addition or subtraction there"
      puts "should be a performance impact.  However, this should not be too large"
      puts Benchmark.measure {
        @a.inner_product(@b)
      }
      
    end
=end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------
 
=begin
   should "execute fromfunction" do

      # creates an array from a function (actually a block).  The name fromfunction
      # is preserved to maintain API compatibility with NumPy (is it necessary?)
      # requires 105.981s to run the following block
      # requires 92.343s to run the following block
      # requires 34.096s to run the following block in Java 7 with invokedynamics
      # requires 5s to run with loop transfered to java

      puts "measuring fromfunction of size: #{7*500*20*320} in seconds"
      puts Benchmark.measure {
        @a = MDArray.fromfunction("double", [7, 500, 20, 320]) do |x, y, z, k|
          # counter[0] + counter[1] + counter[2] + counter[3]
          x + y + z + k
        end
      }

    end
=end

=begin
      @a = MDArray.double([7, 500, 20, 320])
      # @a.unary_operator = UnaryOperator
      @a.fill do |x, y, z, k|
        # counter[0] + counter[1] + counter[2] + counter[3]
        x + y + z + k
      end

      assert_equal(0, @a[0, 0, 0, 0])
      assert_equal(50, @a[5, 10, 15, 20])

    end
=end


=begin
    should "do binary operations in place fast" do

      # @a.fromfunction = 5s (fast), @b.fromfunction = 5s
      # inplace add requires @a and @b loops each taking a little over 6s.
      @a = MDArray.fromfunction("double", [7, 500, 20, 320]) do |x, y, z, k|
      # @a = MDArray.fromfunction("double", [2, 2, 2, 2]) do |x, y, z, k|
        (x + y + z + k) * -1.2345
      end

      @b = MDArray.fromfunction("double", [7, 500, 20, 320]) do |x, y, z, k|
      # @b = MDArray.fromfunction("double", [2, 2, 2, 2]) do |x, y, z, k|
        (x + y + z + k) * -1.2345
      end
      
      @a.add!(@b)
      # b = 100 + @a
      # @a.print
      # c.print

    end

=end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

=begin
    should "iterate fast" do
      @a = MDArray.double([7, 500, 20, 320])
      @a.set_all do |counter| 
        counter[0] + counter[1] + counter[2] + counter[3]
      end

      p @a[0, 0, 0, 0]
      p @a[1, 120, 10, 300]

    end

=end

=begin
 
    # executes in 8.37s
    should "iterate fast" do

      profile_data = JRuby::Profiler.profile do
        @a = MDArray.fromfunction("double", [7, 500, 20, 320]) do |counter|
          counter[0] + counter[1] + counter[2] + counter[3]
          # x + y + z + k
        end
      end
        
      profile_printer = JRuby::Profiler::FlatProfilePrinter.new(profile_data)
      profile_printer.printProfile(STDOUT)

      p @a[0, 0, 0, 0]
      p @a[1, 120, 10, 300]

    end

=end

=begin
  
    should "iterate fast" do

      @a = MDArray.fromfunction("int", [7, 500, 20, 320]) do |x, y, z, k|
        x + y + z + k
      end

      p @a[0, 0, 0, 0]
      p @a[1, 120, 10, 300]


      @a = MDArray.fromfunction("double", [7, 500, 20, 320]) do |x, y, z, k|
        x + y + z + k
      end

      p @a[0, 0, 0, 0]
      p @a[1, 120, 10, 300]

    end

=end

=begin
    should "do unary operations fast" do

      # first test of unary operation 15.258s.  fromfunction takes 5.097s, so simple
      # unary operation is taking 10s, should not take more than fromfunction!
      # second test of unary operation 10.187s.  fromfunction takes 5.097s, so simple
      # unary operation is taking 5s.  OK.
      @a = MDArray.fromfunction("double", [7, 500, 20, 320]) do |x, y, z, k|
      # @a = MDArray.fromfunction("double", [2, 2, 2, 2]) do |x, y, z, k|
        (x + y + z + k) * -1.2345
      end

      b = @a.abs
      # @a.print
      # b.print

    end
=end

=begin
    should "do binary operations fast" do

      # first test of unary operation 15.258s.  fromfunction takes 5.097s, so simple
      # unary operation is taking 10s, should not take more than fromfunction!
      # second test of unary operation 10.187s.  fromfunction takes 5.097s, so simple
      # unary operation is taking 5s.  OK.
      @a = MDArray.fromfunction("double", [7, 500, 20, 320]) do |x, y, z, k|
      # @a = MDArray.fromfunction("double", [2, 2, 2, 2]) do |x, y, z, k|
        (x + y + z + k) * -1.2345
      end

      @b = MDArray.fromfunction("double", [7, 500, 20, 320]) do |x, y, z, k|
      # @b = MDArray.fromfunction("double", [2, 2, 2, 2]) do |x, y, z, k|
        (x + y + z + k) * -1.2345
      end
      
      c = @a + @b
      # b = 100 + @a
      # @a.print
      # c.print

    end
=end

=begin
    should "do binary operations fast with arrays of different types" do

      # first test of unary operation 15.258s.  fromfunction takes 5.097s, so simple
      # unary operation is taking 10s, should not take more than fromfunction!
      # second test of unary operation 10.187s.  fromfunction takes 5.097s, so simple
      # unary operation is taking 5s.  OK.
      @a = MDArray.fromfunction("double", [7, 500, 20, 320]) do |x, y, z, k|
      # @a = MDArray.fromfunction("double", [2, 2, 2, 2]) do |x, y, z, k|
        (x + y + z + k) * -1.2345
      end

      @b = MDArray.fromfunction("float", [7, 500, 20, 320]) do |x, y, z, k|
      # @b = MDArray.fromfunction("double", [2, 2, 2, 2]) do |x, y, z, k|
        (x + y + z + k) * -1.2345
      end
      
      c = @a + @b
      # b = 100 + @a
      # @a.print
      # c.print

    end
=end

=begin
    should "do comparison operations fast" do

      # first test of unary operation 15.258s.  fromfunction takes 5.097s, so simple
      # unary operation is taking 10s, should not take more than fromfunction!
      # second test of unary operation 10.187s.  fromfunction takes 5.097s, so simple
      # unary operation is taking 5s.  OK.
      @a = MDArray.fromfunction("double", [7, 500, 20, 320]) do |x, y, z, k|
      # @a = MDArray.fromfunction("double", [2, 2, 2, 2]) do |x, y, z, k|
        (x + y + z + k) * -1.2345
      end

      @b = MDArray.fromfunction("double", [7, 500, 20, 320]) do |x, y, z, k|
      # @b = MDArray.fromfunction("double", [2, 2, 2, 2]) do |x, y, z, k|
        (x + y + z + k) * -1.2345
      end
      
      c = @a > @b
      # b = 100 + @a
      # @a.print
      # c.print

    end
=end

  end
  
end

