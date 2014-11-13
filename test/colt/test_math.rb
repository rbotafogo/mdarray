# -*- coding: utf-8 -*-

##########################################################################################
# Copyright © 2013 Rodrigo Botafogo. All Rights Reserved. Permission to use, copy, modify, 
# and distribute this software and its documentation, without fee and without a signed 
# licensing agreement, is hereby granted, provided that the above copyright notice, this 
# paragraph and the following two paragraphs appear in all copies, modifications, and 
# distributions.
#
# IN NO EVENT SHALL RODRIGO BOTAFOGO BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF 
# THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF RODRIGO BOTAFOGO HAS BEEN ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
#
# RODRIGO BOTAFOGO SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE 
# SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED HEREUNDER IS PROVIDED "AS IS". 
# RODRIGO BOTAFOGO HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, 
# OR MODIFICATIONS.
##########################################################################################

require 'rubygems'
require "test/unit"
require 'shoulda'

require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "Colt Functions Tests" do

    setup do

      @byte = MDArray.typed_arange("byte", 1, 10)
      @short = MDArray.typed_arange("short", 1, 10)
      @int = MDArray.typed_arange("int", 1, 10)
      @long = MDArray.typed_arange("long", 1, 10)
      @float = MDArray.typed_arange("float", 1, 10)
      @double = MDArray.linspace("double", 0, 1, 10)

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------
=begin
    should "math operations with colt methods" do

      @byte + @short
      @double + @double
      @double * @double
      @double * @int
      @double - @double
      @double - @byte
      @int - @int
      @int - @double

    end
=end
    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "work with Parallel Colt double methods" do

      p "testing Parallel Colt double methods" 

      (@double.abs).print
      (@double.acos).print
      (@double.asin).print
      (@double.atan).print
      (@double.atan2(@double)).print
      (@double.ceil).print
      (@double.compare(@double)).print
      @double.cos
      @double.div(@double)
      @double.div_neg(@double)
      @double.equals(@double)
      @double.exp
      @double.floor
      @double.greater(@double)
      @double.identity
      @double.ieee_remainder(@double)
      @double.inv
      @double.is_equal(@double)
      @double == @double
      @double.is_less(@double)
      @double < @double
      @double.is_greater(@double)
      @double > @double
      @double.less(@double)
      @double.lg(@double)
      @double.log
      @double.cern_log2
      @double.minus(@double)
      @double - @double
      @double.mod(@double)
      @double * @double
      @double.mult_neg(@double)
      @double.mult_square(@double)
      @double.neg
      @double + @double
      @double.plus_abs(@double)
      @double.pow(@double)
      @double.rint
      @double.sign
      @double.sin
      @double.sqrt
      @double.square
      @double.tan
      
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "work with Parallel Colt float methods" do

      p "testing Parallel Colt float methods" 

      (@float.abs).print
      (@float.acos).print
      (@float.asin).print
      (@float.atan).print
      (@float.atan2(@float)).print
      (@float.ceil).print
      (@float.compare(@float)).print
      @float.cos
      @float.div(@float)
      @float.div_neg(@float)
      @float.equals(@float)
      @float.exp
      @float.floor
      @float.greater(@float)
      @float.identity
      @float.ieee_remainder(@float)
      @float.inv
      @float.is_equal(@float)
      @float == @float
      @float.is_less(@float)
      @float < @float
      @float.is_greater(@float)
      @float > @float
      @float.less(@float)
      @float.lg(@float)
      @float.log
      @float.cern_log2
      @float.minus(@float)
      @float - @float
      @float.mod(@float)
      @float * @float
      @float.mult_neg(@float)
      @float.mult_square(@float)
      @float.neg
      @float + @float
      @float.plus_abs(@float)
      @float.pow(@float)
      @float.rint
      @float.sign
      @float.sin
      @float.sqrt
      @float.square
      @float.tan
      
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "work with Parallel Colt long methods" do

      p "testing Parallel Colt long methods" 

      (@long.abs).print
      (@long.compare(@long)).print
      @long.div(@long)
      @long.div_neg(@long)
      @long.equals(@long)
      @long.is_equal(@long)
      @long == @long
      @long.is_less(@long)
      @long < @long
      @long.is_greater(@long)
      @long > @long
      @long.cern_max(@long)
      @long.cern_min(@long)
      @long.minus(@long)
      @long - @long
      @long.mod(@long)
      @long * @long
      @long.mult_neg(@long)
      @long.mult_square(@long)
      @long.neg
      @long + @long
      @long.plus(@long)
      @long.plus_abs(@long)
      @long.pow(@long)
      @long.sign
      @long.square

      @long.and(@long)
      @long.dec
      @long.factorial
      @long.inc
      @long.not
        @long.or(@long)
      @long.shift_left(@long)
      @long.shift_right_signed(@long)
      @long.binary_right_shift(@long)
      @long.binary_left_shift(@long)
      @long.shift_right_unsigned(@long)
      @long.xor(@long)
      
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "work with Parallel Colt int methods" do

      p "testing Parallel Colt int methods" 

      (@int.abs).print
      (@int.compare(@int)).print
      @int.div(@int)
      @int.div_neg(@int)
      @int.equals(@int)
      @int.is_equal(@int)
      @int == @int
      @int.is_less(@int)
      @int < @int
      @int.is_greater(@int)
      @int > @int
      @int.cern_max(@int)
      @int.cern_min(@int)
      @int.minus(@int)
      @int - @int
      @int.mod(@int)
      @int * @int
      @int.mult_neg(@int)
      @int.mult_square(@int)
      @int.neg
      @int + @int
      @int.plus(@int)
      @int.plus_abs(@int)
      @int.pow(@int)
      @int.sign
      @int.square

      @int.and(@int)
      @int.dec
      @int.factorial
      @int.inc
      @int.not
        @int.or(@int)
      @int.shift_left(@int)
      @int.shift_right_signed(@int)
      @int.binary_right_shift(@int)
      @int.binary_left_shift(@int)
      @int.shift_right_unsigned(@int)
      @int.xor(@int)
      
    end

  end

end
