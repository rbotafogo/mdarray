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


#=========================================================================================
# Proc methods 
#=========================================================================================

class Proc
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.compose(f, g)
    lambda { |*args| f[g[*args]] }
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def *(g)
    Proc.compose(self, g)
  end

  #------------------------------------------------------------------------------------
  # Builds a function that returns true
  # when 'f' returns false, and vice versa.
  #------------------------------------------------------------------------------------

  def self.complement f
    lambda {|*args| not f.call(*args) }
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def neg
    Proc.complement(self)
  end

  #------------------------------------------------------------------------------------
  # Builds a function which returns true
  # whenever _every_ function in 'predicates'
  # returns true.
  #------------------------------------------------------------------------------------

  def self.conjoin(*predicates)

    base = lambda {|*args| true }
    predicates.inject(base) do |built, pred|
      lambda do |*args|
        built.call(*args) && pred.call(*args)
      end
    end

  end

  #------------------------------------------------------------------------------------
  # Builds a function which returns true
  # whenever _any_ function in 'predicates'
  # returns true.
  #------------------------------------------------------------------------------------

  def self.disjoin(*predicates)

    base = lambda {|*args| false }
    predicates.inject(base) do |built, pred|
      lambda do |*args|
        built.call(*args) || pred.call(*args)
      end
    end

  end
  
  #------------------------------------------------------------------------------------
  # This method binds the 1st argument of a binary function to a scalar value,
  # effectively enabling a binary function to be called in a context intended for a 
  # unary function.
  #------------------------------------------------------------------------------------

  def bind1st(val)
    lambda { |arg| self.call(val, arg) }
  end

  #------------------------------------------------------------------------------------
  # This method binds the 2nd argument of a binary function to a scalar value, 
  # effectively enabling a binary function to be called in a context intended for a 
  # unary function.
  #------------------------------------------------------------------------------------

  def bind2nd(val)
    lambda { |arg| self.call(arg,val) }
  end

  #------------------------------------------------------------------------------------
  # This class verifies a condition and if true, returns the evaluation of a function, 
  # otherwise returns NaN.
  #------------------------------------------------------------------------------------

  def self.clipped(predicate, method)
    lambda { |*args| predicate.call(*args)? method.call(*args) : Float::NAN }
  end

  #------------------------------------------------------------------------------------
  # Returns a constant value
  #------------------------------------------------------------------------------------

  def self.constant(val)
    lambda { |arg| return val }
  end

  #------------------------------------------------------------------------------------
  # Always returns true
  #------------------------------------------------------------------------------------

  def self.everywhere
    lambda { |arg| return true}
  end

  #------------------------------------------------------------------------------------
  # Always returns false
  #------------------------------------------------------------------------------------

  def self.nowhere
    lambda { |arg| return false}
  end

  #------------------------------------------------------------------------------------
  # The identity function
  #------------------------------------------------------------------------------------

  def self.identity
    lambda { |arg| return arg }
  end

end # Proc


