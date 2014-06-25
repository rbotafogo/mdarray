# -*- coding: utf-8 -*-

##########################################################################################
# Copyright © 2013 Rodrigo Botafogo. All Rights Reserved. Permission to use, copy, modify, 
# and distribute this software and its documentation for educational, research, and 
# not-for-profit purposes, without fee and without a signed licensing agreement, is hereby 
# granted, provided that the above copyright notice, this paragraph and the following two 
# paragraphs appear in all copies, modifications, and distributions. Contact Rodrigo
# Botafogo - rodrigo.a.botafogo@gmail.com for commercial licensing opportunities.
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

##########################################################################################
#
##########################################################################################

class FastBinaryOperator < BinaryOperator

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def get_args(*args)

    parse_args(*args)

    if (@op1.is_a? NumericalMDArray)
      if (@op2.is_a? Numeric)
        arg2 = @op2
      elsif (@op2.is_a? NumericalMDArray)
        if (!@op1.compatible(@op2))
          raise "Invalid operation - arrays are incompatible"
        end
        arg2 = @op2.nc_array
      else # Operation with another user defined type
        false
        # *TODO: make it more general using coerce if other_val type is not recognized
        # if (arg is not recognized)
        #  self_equiv, arg_equiv = arg.coerce(self)
        #  self_equiv * arg_equiv
        # end
      end
      
    else  # NonNumericalMDArray
      if (!@op1.compatible(@op2))
        raise "Invalid operation - arrays are incompatible"
      end

      # Will not work if we have subclasses!!!!
      if (@op1.class != @op2.class)
        raise "Invalid operation - array are not of compatible types"
      end

      arg2 = @op2.nc_array
    end

    yield @op1.nc_array, arg2, @op1.shape, *args

  end

  #---------------------------------------------------------------------------------------
  # A default binary operator takes two arrays where one array can be degenerated (a 
  # number and loops through all elements of the arrays applying a given method to them.  
  # For instance, operator '+' in a + b is a default binary operator.
  #---------------------------------------------------------------------------------------

  def default(*args)

    calc = nil
    get_args(*args) do |op1, op2, shape, *other_args|
      calc = MDArray.build(@type, shape)
      if (@coerced)
        helper = @helper::CoerceBinaryOperator
        helper.send("apply", calc.nc_array, op1, op2, @do_func)
      elsif (@op1.is_a? NumericalMDArray)
        helper = @helper::DefaultBinaryOperator
        helper.send("apply", calc.nc_array, op1, op2, @do_func)
      else
        helper = @helper::DefaultBinaryOperator
        helper.send("apply#{@op1.class}", calc.nc_array, op1, op2, @do_func)
      end
    end
    return calc

  end

  #---------------------------------------------------------------------------------------
  # A fill binary operator takes two arrays where one array can be degenerated (a number)
  # and loops through all elements of the arrays, setting the value of the first array
  # to the values of the second.
  #---------------------------------------------------------------------------------------

  def fill(*args)

    get_args(*args) do |op1, op2, shape, *other_args|
      helper = @helper::FillBinaryOperator
      helper.send("apply", op1, op2)

    end

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def in_place(*args)

    get_args(*args) do |op1, op2, shape, *other_args|
      helper = @helper::InplaceBinaryOperator
      helper.send("apply", op1, op2, @do_func)
    end

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def reduce(*args)

    calc = nil

    get_args(*args) do |op1, op2, shape, *other_args|
      # return nil if op2 == nil
      helper = @helper::ReduceBinaryOperator
      calc = @pre_condition_result
      calc = helper.send("apply", calc, op1, op2, @do_func)
    end

    return calc

  end
  
  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def complex_reduce(*args)

    calc = nil

    get_args(*args) do |op1, op2, shape, *other_args|
      # return nil if op2 == nil
      helper = @helper::ComplexReduceBinaryOperator
      calc = @pre_condition_result
      calc = helper.send("apply", calc, op1, op2, @do_func)
    end

    return calc

  end

end # FastBinaryOperator

##########################################################################################
#
##########################################################################################

class FastUnaryOperator < UnaryOperator

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def get_args(*args)

    parse_args(*args)
    yield @op.nc_array, @op.shape, *@other_args

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def set_block(*args)

    get_args(*args) do |op1, shape, *other_args|
      block = other_args[0]
      helper = @helper::SetAll
      func = (shape.size <= 7)? "apply#{shape.size}" : "apply"
      helper.send(func, op1, &block) if block
    end
    
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def default(*args)
    
    calc = nil
    get_args(*args) do |op1, shape, *other_args|
      calc = MDArray.build(@type, shape)
      helper = @helper::DefaultUnaryOperator
      helper.send("apply", calc.nc_array, op1, @do_func)
    end
    return calc

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def in_place(*args)

    get_args(*args) do |op1, shape, *other_args|
      helper = @helper::InplaceUnaryOperator
      helper.send("apply", op1, @do_func)
    end

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def reduce(*args)

    calc = nil

    get_args(*args) do |op1, shape, *other_args|
      helper = @helper::ReduceUnaryOperator
      calc = @pre_condition_result
      calc = helper.send("apply", calc, op1, @do_func)
    end

    return calc

  end
  
end # UnaryOperator

MDArray.binary_operator = FastBinaryOperator
MDArray.unary_operator = FastUnaryOperator
