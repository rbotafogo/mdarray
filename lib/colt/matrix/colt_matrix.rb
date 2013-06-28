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
  attr_reader :mdarray

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------
  
  def initialize(mdarray, colt_matrix)
    @mdarray = mdarray
    @colt_matrix = colt_matrix
  end

  #------------------------------------------------------------------------------------
  # Creates a MDMatrix from an MDArray.
  # (int rows, int columns, double[] elements, int rowZero, int columnZero, 
  # int rowStride, int columnStride, boolean isView)
  #------------------------------------------------------------------------------------

  def self.from_mdarray(mdarray)

    if (mdarray.rank > 2)
      raise "Cannot create matrix from array of rank greater than 2"
    end

    storage = mdarray.nc_array.getStorage()
    index = mdarray.nc_array.getIndex()
    shape = index.getShape()

    klass = index.getClass
    field = klass.getDeclaredField("stride0")
    field.setAccessible true
    stride0 = field.get(index)
    # p stride0

    field = klass.getDeclaredField("stride1")
    field.setAccessible true
    stride1 = field.get(index)
    # p stride1

    klass = klass.getSuperclass()
    field = klass.getDeclaredField("offset")
    field.setAccessible true
    offset = field.get(index)
    # p offset

    case mdarray.type
    when "double"
      colt_matrix = DenseDoubleMatrix2D.new(shape[0], shape[1], storage, offset, 0, 
                                            stride0, stride1, false)
      DoubleMDMatrix.new(mdarray, colt_matrix)
    when "float"
      colt_matrix = DenseFloatMatrix2D.new(shape[0], shape[1], storage, offset, 0, 
                                           stride0, stride1, false)
      FloatMDMatrix.new(mdarray, colt_matrix)
    when "long"
      colt_matrix = DenseLongMatrix2D.new(shape[0], shape[1], storage, offset, 0, 
                                          stride0, stride1, false)
      LongMDMatrix.new(mdarray, colt_matrix)
    when "int"
      colt_matrix = DenseIntMatrix2D.new(shape[0], shape[1], storage, offset, 0, 
                                         stride0, stride1, false)
      IntMDMatrix.new(mdarray, colt_matrix)
    end


  end

  #------------------------------------------------------------------------------------
  # Creates a new MDMatrix from a given colt_matrix
  #------------------------------------------------------------------------------------

  def self.from_colt_matrix(colt_matrix)

    if (colt_matrix.is_a? DenseDoubleMatrix3D)
      mdarray = MDArray.from_jstorage("double", 
                                      [colt_matrix.slices, colt_matrix.rows, 
                                       colt_matrix.columns], colt_matrix.elements)
      return DoubleMDMatrix.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseFloatMatrix3D)
      mdarray = MDArray.from_jstorage("float", 
                                      [colt_matrix.slices, colt_matrix.rows, 
                                       colt_matrix.columns], colt_matrix.elements)
      return FloatMDMatrix.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseLongMatrix3D)
      mdarray = MDArray.from_jstorage("long", 
                                      [colt_matrix.slices, colt_matrix.rows, 
                                       colt_matrix.columns], colt_matrix.elements)
      return LongMDMatrix.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseIntMatrix3D)
      mdarray = MDArray.from_jstorage("int", 
                                      [colt_matrix.slices, colt_matrix.rows, 
                                       colt_matrix.columns], colt_matrix.elements)
      return IntMDMatrix.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseDoubleMatrix2D)
      mdarray = MDArray.from_jstorage("double", [colt_matrix.rows, colt_matrix.columns], 
                                      colt_matrix.elements)
      return DoubleMDMatrix.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseFloatMatrix2D)
      mdarray = MDArray.from_jstorage("float", [colt_matrix.rows, colt_matrix.columns], 
                                      colt_matrix.elements)
      return FloatMDMatrix.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseLongMatrix2D)
      mdarray = MDArray.from_jstorage("long", [colt_matrix.rows, colt_matrix.columns], 
                                      colt_matrix.elements)
      return LongMDMatrix.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseIntMatrix2D)
      mdarray = MDArray.from_jstorage("int", [colt_matrix.rows, colt_matrix.columns], 
                                      colt_matrix.elements)
      return IntMDMatrix.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseDoubleMatrix1D)
      mdarray = MDArray.from_jstorage("double", [colt_matrix.size], colt_matrix.elements)
      return DoubleMDMatrix.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseFloatMatrix1D)
      mdarray = MDArray.from_jstorage("float", [colt_matrix.size], colt_matrix.elements)
      return FloatMDMatrix.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseLongMatrix1D)
      mdarray = MDArray.from_jstorage("long", [colt_matrix.size], colt_matrix.elements)
      return LongMDMatrix.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseIntMatrix1D)
      mdarray = MDArray.from_jstorage("int", [colt_matrix.size], colt_matrix.elements)
      return IntMDMatrix.from_mdarray(mdarray)
    end

  end

  #------------------------------------------------------------------------------------
  # Multiplies this matrix by another matrix
  #------------------------------------------------------------------------------------

  def mult(mdmatrix)
    result = @colt_matrix.like
    @colt_matrix.zMult(mdmatrix.colt_matrix, result)
    MDMatrix.from_colt_matrix(result)
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
  
  def sum
    @colt_matrix.zSum
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def formatter

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

##########################################################################################
#
##########################################################################################

class DoubleMDMatrix < MDMatrix
  include_package "cern.colt.matrix.tdouble.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix)
    @da = DenseDoubleAlgebra.new
  end

end # DoubleMDMatrix

##########################################################################################
#
##########################################################################################

class FloatMDMatrix < MDMatrix

end # FloatMDMatrix

##########################################################################################
#
##########################################################################################

class LongMDMatrix < MDMatrix

end # LongMDMatrix

##########################################################################################
#
##########################################################################################

class IntMDMatrix < MDMatrix

end # IntMDMatrix


require_relative 'matrix_double_algebra'
