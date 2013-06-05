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

class LazyBinaryOperator < BinaryOperator

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def get_args(*args)

    @op1 = args.shift
    @op2 = args.shift
    @other_args = args

  end

  #---------------------------------------------------------------------------------------
  # A default binary operator takes two arrays where one array can be degenerated (a 
  # number and loops through all elements of the arrays applying a given method to them.  
  # For instance, operator '+' in a + b is a default binary operator.
  #---------------------------------------------------------------------------------------

  def default(*args)

    get_args(*args)
    lazy = @op1

    if (@op1.is_a? LazyMDArray)
      lazy.push(@op2)
      lazy.push(self)
    else
      lazy = LazyMDArray.new
      lazy.push(@op1)
      lazy.push(@op2)
      lazy.push(self)
    end

    return lazy

  end

  #---------------------------------------------------------------------------------------
  # A fill binary operator takes two arrays where one array can be degenerated (a number)
  # and loops through all elements of the arrays, setting the value of the first array
  # to the values of the second.
  #---------------------------------------------------------------------------------------

  def fill(*args)
    raise "Cannot fill array lazyly"
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def in_place(*args)
    raise "Cannot operate in_place lazyly"
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def reduce(*args)
    raise "Cannot reduce array in lazy operation"
  end
  
  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def complex_reduce(*args)
    raise "Cannot reduce array in lazy operation"
  end

end # LazyBinaryOperator

##########################################################################################
#
##########################################################################################

class LazyUnaryOperator < UnaryOperator

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def get_args(*args)

    @op = args.shift
    @other_args = args

  end

  #---------------------------------------------------------------------------------------
  # A default unary operator takes one arrays and loops through all elements of the array
  # applying a given method to it.  For instance, operator 'log' in a.log is a default 
  # unary operator.
  #---------------------------------------------------------------------------------------

  def default(*args)

    get_args(*args)
    lazy = @op

    if (@op.is_a? LazyMDArray)
      lazy.push(self)
    else
      lazy = LazyMDArray.new
      lazy.push(@op)
      lazy.push(self)
    end

    return lazy

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def in_place(*args)
    raise "Cannot operate in_place lazyly"
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def reduce(*args)
    raise "Cannot reduce array in lazy operation"
  end
  
  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def complex_reduce(*args)
    raise "Cannot reduce array in lazy operation"
  end

end # LazyUnaryOperator
