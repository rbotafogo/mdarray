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

require 'java'

class MDMatrix
  include_package "cern.colt.matrix.tdouble.impl"
  include_package "cern.colt.matrix.tdouble.algo"

  include_package "cern.colt.matrix.tfloat.impl"
  include_package "cern.colt.matrix.tfloat.algo"

  include_package "cern.colt.matrix.tlong.impl"
  include_package "cern.colt.matrix.tlong.algo"

  include_package "cern.colt.matrix.tint.impl"
  include_package "cern.colt.matrix.tint.algo"


  attr_reader :colt_matrix
  attr_reader :colt_algebra
  attr_reader :colt_property
  attr_reader :mdarray

  #------------------------------------------------------------------------------------
  # Reshapes the Matrix. Not working yet.
  #------------------------------------------------------------------------------------

  def reshape!(shape)
    @mdarray.reshape!(shape)
    @colt_matrix = MDMatrix.from_mdarray(@mdarray).colt_matrix
  end

  #------------------------------------------------------------------------------------
  # Fills the array with the given value
  #------------------------------------------------------------------------------------

  def fill(val, func = nil)

    if (func)
      return MDMatrix.from_colt_matrix(@colt_matrix.assign(val.colt_matrix, func))
    end

    if ((val.is_a? Numeric) || (val.is_a? Proc) || (val.is_a? Class))
      MDMatrix.from_colt_matrix(@colt_matrix.assign(val))
    elsif (val.is_a? MDMatrix)
      MDMatrix.from_colt_matrix(@colt_matrix.assign(val.colt_matrix))
    else
      raise "Cannot fill a Matrix with the given value"
    end
  end

  #------------------------------------------------------------------------------------
  # Fills the matrix based on a given condition
  #------------------------------------------------------------------------------------

  def fill_cond(cond, val)
    return MDMatrix.from_colt_matrix(@colt_matrix.assign(cond, val))
  end

  #------------------------------------------------------------------------------------
  # Applies a function to each cell and aggregates the results. Returns a value v such 
  # that v==a(size()) where a(i) == aggr( a(i-1), f(get(row,column)) ) and terminators 
  # are a(1) == f(get(0,0)), a(0)==Double.NaN. 
  #------------------------------------------------------------------------------------

  def reduce(aggr, func, cond = nil)
    (cond)? @colt_matrix.aggregate(aggr, func, cond) : 
      @colt_matrix.aggregate(aggr, func)
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def set(row, column, val)
    @colt_matrix.set(row, column, val)
  end

  alias :[]= :set

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def get(*index)
    @colt_matrix.get(*index)
  end

  alias :[] :get

  #------------------------------------------------------------------------------------
  # Create a new Array using same backing store as this Array, by flipping the index 
  # so that it runs from shape[index]-1 to 0.
  #------------------------------------------------------------------------------------
  
  def flip(dim)
    MDMatrix.from_mdarray(@mdarray.flip(dim))
  end
  
  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def normalize!
    @colt_matrix.normalize
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def rank
    @mdarray.rank
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def shape
    @mdarray.shape
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def size
    @mdarray.size
  end

  #------------------------------------------------------------------------------------
  # Makes a view of this array based on the given parameters
  # shape
  # origin
  # size
  # stride
  # range
  # section
  # spec
  #------------------------------------------------------------------------------------
  
  def region(*args)
    MDMatrix.from_mdarray(@mdarray.region(*args))
  end
  
  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------
  
  def sum
    @colt_matrix.zSum
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def print

    case mdarray.type

    when "double"
      formatter = DoubleFormatter.new
    when "float"
      formatter = FloatFormatter.new
    when "long"
      formatter = LongFormatter.new
    when "int"
      formatter = IntFormatter.new

    end

    printf(formatter.toString(@colt_matrix))

  end

end # MDMatrix

require_relative 'creation'
require_relative 'hierarchy'
require_relative 'algebra'
require_relative 'property'
