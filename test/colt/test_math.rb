require 'rubygems'
require "test/unit"
require 'shoulda'

$INSTALL_DIR = "/home/zxb3/Desenv/MDArray"
require '../env.rb'

require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "Statistics Tests" do

    setup do

      @byte = MDArray.typed_arange("byte", 1, 10)
      @short = MDArray.typed_arange("short", 1, 10)
      @int = MDArray.typed_arange("int", 1, 10)
      @long = MDArray.typed_arange("long", 1, 10)
      @float = MDArray.typed_arange("float", 1, 10)
      @double = MDArray.typed_arange("double", 1, 10)

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "math operations with colt methods" do

      @byte + @short
      @double + @double

    end

  end

end
