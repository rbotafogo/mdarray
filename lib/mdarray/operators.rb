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

# example of how to access a protected field on the java superclass
# class Java::OrgJquantlibMathMatrixutilities::Array
#   field_accessor :addr
# end

##########################################################################################
#
##########################################################################################

class Const

  attr_reader :value

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def initialize(value)
    @value = value
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def get_iterator_fast
    return self
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def get_next
    @value
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def get_current
    @value
  end

end # Const

##########################################################################################
#
##########################################################################################

class Operator

  attr_reader :name
  attr_reader :type  # resulting type of the operation
  attr_reader :arity # number of arguments to the operator
  attr_reader :exec_type # type of operator execution, e.g., default, in_place, numeric
  attr_reader :force_type  # force this type as the result type
  attr_reader :pre_condition  # proc to be executed before the operator's execution
  attr_reader :post_condition  # proc to be executed after the operator's execution

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def initialize(name, arity, exec_type, force_type = nil, pre_condition = nil, 
                 post_condition = nil)

    @name = name
    @arity = arity
    @exec_type = exec_type
    @force_type = force_type
    @pre_condition = pre_condition  # proc to be executed before the main loop
    @pre_condition_result = nil
    @post_condition = post_condition # proc to be executed after the main loop

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def exec(*args)

    @pre_condition_result = @pre_condition.call(*args) if @pre_condition
    result = method(@exec_type).call(*args)
    (@post_condition)? @post_condition.call(result, *args) : result

  end

end # Operator

##########################################################################################
#
##########################################################################################

class BinaryOperator < Operator

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  private
  
  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def parse_args(*args)

    @op1 = args.shift
    @op2 = args.shift
    requested_type = args.shift
    @type = (@force_type)? @force_type : (requested_type)? requested_type : 
      @op1.get_type(@op2)
    @coerced = @op1.coerced
    func = MDArray.select_function(@name, MDArray.functions, @type)
    if (func.is_a? Proc)
      @do_func = func.dup
    else
      @do_func = func
    end
    @other_args = args

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def get_args(*args)

    parse_args(*args)
    if (@op2.is_a? Numeric)
      op2_iterator = Const.new(@op2)
    elsif (@op2.is_a? NumericalMDArray)
      if (@op1.compatible(@op2))
        op2_iterator = @op2.get_iterator_fast
      else
        raise "Invalid operation - arrays are incompatible"
      end
    else
      false
      # *TODO: make it more general using coerce if other_val type is not recognized
      # if (arg is not recognized)
      #  self_equiv, arg_equiv = arg.coerce(self)
      #  self_equiv * arg_equiv
      # end
    end

    yield @op1.get_iterator_fast, op2_iterator, @op1.shape, *@other_args

  end

end # BinaryOperator

##########################################################################################
#
##########################################################################################

class UnaryOperator < Operator
  
  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  private

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def parse_args(*args)

    @op = args.shift
    requested_type = args.shift
    @type = (@force_type)? @force_type : (requested_type)? requested_type : @op.type
    func = MDArray.select_function(@name, MDArray.functions, @type)
    if (func.is_a? Proc)
      @do_func = func.dup
    else
      @do_func = func
    end
    @other_args = args

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def get_args(*args)

    parse_args(*args)
    yield @op.get_iterator_fast, @op.shape, *@other_args

  end

end # UnaryOperator
