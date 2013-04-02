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

##########################################################################################
#
##########################################################################################

class FastBoolean < BooleanMDArray


  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def initialize(storage, section = false)
    super("boolean", storage, section)
  end

  #---------------------------------------------------------------------------------------
  # Executes a boolean operator.  Valid boolean operators are: and, or.  Only applicable
  # to boolean operands
  #---------------------------------------------------------------------------------------

  def exec_boolean_op(dest, other_val, method)

    proc = Proc.new { |elmt, value| method.call(elmt, value) }

    if ((other_val.is_a? TrueClass) || (other_val.is_a? FalseClass))
      @helper.send("booleanOperationWithBool", dest.nc_array, @nc_array, other_val, proc)
    elsif (other_val.is_a? MDArray)
      if (compatible(other_val))
        @helper.send("booleanOperationWithArray", dest.nc_array, @nc_array, 
                     other_val.nc_array, proc)
      else
        raise "Invalid operation - arrays are incompatible"
      end
    else
      raise "Invalid operation with: #{other_val}"
    end
    
    return dest
    
  end

  #---------------------------------------------------------------------------------------
  # Executes a boolean operator.  Valid boolean operators are: and, or.  Only applicable
  # to boolean operands
  #---------------------------------------------------------------------------------------

  def exec_bin_op(op1, op2, proc, base)

    args = Array.new
    args << @nc_array
    (op1)? args << op1.nc_array : nil

    if (op2.is_a? Numeric)
      name = base + "WithNumber"
      args << op2
    elsif (op2.is_a? NumericalMDArray)
      if (compatible(op2))
        name = base + "WithArray"
        args << op2.nc_array
      else
        raise "Invalid operation - arrays are incompatible"
      end
    else
      raise "Invalid operation with: #{op2}"
=begin
      # *TODO: make it more general using coerce if other_val type is not recognized
      if (arg is not recognized)
        self_equiv, arg_equiv = arg.coerce(self)
        self_equiv * arg_equiv
      end
=end
    end
    
    args << proc
    @helper.send(make_function_name(name), *args)
    return self

  end

end # FastBoolean

