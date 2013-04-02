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

class RubyBinaryOperator < BinaryOperator

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def initialize(name, exec_type, force_type = nil, pre_condition = nil, 
                 post_condition = nil)
    super(name, 2, exec_type, force_type, pre_condition, post_condition)
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def default(*args)

    get_args(*args) do |op1_iterator, op2_iterator, shape, *other_args|
      result = MDArray.build(@type, shape)
      res_iterator = result.get_iterator_fast
      if (@coerced)
        while (res_iterator.has_next?)
          res_iterator.set_next(@do_func.call(op2_iterator.get_next, 
                                              op1_iterator.get_next))
        end
      else
        while (res_iterator.has_next?)
          res_iterator.set_next(@do_func.call(op1_iterator.get_next, 
                                              op2_iterator.get_next))
        end
      end
      return result
    end

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def fill(*args)

    get_args(*args) do |op1_iterator, op2_iterator, shape, *other_args|
      while (op1_iterator.has_next?)
        op1_iterator.set_next(op2_iterator.get_next)
      end
      return self
    end

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------
  
  def in_place(*args)

    get_args(*args) do |op1_iterator, op2_iterator, shape, *other_args|
      while (op1_iterator.has_next?)
        op1_iterator.set_current(@do_func.call(op1_iterator.get_next, 
                                               op2_iterator.get_next))
      end
      return self
    end

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def reduce(*args)

    get_args(*args) do |op1_iterator, op2_iterator, shape, *other_args|
      result = @pre_condition_result
      while (op1_iterator.has_next?)
        result = @do_func.call(result, op1_iterator.get_next, op2_iterator.get_next)
      end
      return result
    end
    
  end

end # RubyBinaryOperator

##########################################################################################
#
##########################################################################################

class RubyUnaryOperator < UnaryOperator

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def initialize(name, exec_type, force_type = nil, pre_condition = nil, 
                 post_condition = nil)
    super(name, 1, exec_type, force_type, pre_condition, post_condition)
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def default(*args)

    get_args(*args) do |op_iterator, shape, *other_args|
      result = MDArray.build(@type, shape)
      res_iterator = result.get_iterator_fast
      while (res_iterator.has_next?)
        res_iterator.set_next(@do_func.call(op_iterator.get_next))
      end
      return result
    end

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def set_block(*args)

    get_args(*args) do |op_iterator, shape, *other_args|
      block = other_args[0]
      while (op_iterator.has_next?)
        op_iterator.next
        if (shape.size < 8)
          op_iterator.set_current(block.call(*op_iterator.get_current_counter))
        else
          op_iterator.set_current(block.call(op_iterator.get_current_counter))
        end
      end if block
    end

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def in_place(*args)

    get_args(*args) do |op_iterator, *other_args|
      while (op_iterator.has_next?)
        op_iterator.set_current(@do_func.call(op_iterator.get_next))
      end
      return self
    end

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def reduce(*args)

    get_args(*args) do |op_iterator, shape, *other_args|
      result = @pre_condition_result
      while (op_iterator.has_next?)
        result = @do_func.call(result, op_iterator.get_next)
      end
      return result
    end

  end

end # RubyUnaryOperator

##########################################################################################
#
##########################################################################################

MDArray.binary_operator = RubyBinaryOperator
MDArray.unary_operator = RubyUnaryOperator
