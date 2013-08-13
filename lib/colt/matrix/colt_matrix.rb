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
require_relative 'property'

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
  attr_reader :mdarray
  attr_reader :rank
  attr_reader :property

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def self.build(type, shape, storage = nil)
    if (shape.size > 3)
      raise "Cannot create MDMatrix of size greater than 3"
    end
    self.from_mdarray(MDArray.build(type, shape, storage))
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def self.double(shape, storage = nil)
    self.build("double", shape, storage)
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def self.float(shape, storage = nil)
    self.build("float", shape, storage)
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def self.long(shape, storage = nil)
    self.build("long", shape, storage)
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def self.int(shape, storage = nil)
    self.build("int", shape, storage)
  end

  #------------------------------------------------------------------------------------
  # Creates a MDMatrix from an MDArray.
  # (int rows, int columns, double[] elements, int rowZero, int columnZero, 
  # int rowStride, int columnStride, boolean isView)
  #------------------------------------------------------------------------------------

  def self.from_mdarray(mdarray)

    case mdarray.rank

    when 1
      dense1D(mdarray)
    when 2
      dense2D(mdarray)
    when 3
      dense3D(mdarray)
    else
      raise "Cannot create MDMatrix of rank greater than 3"
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
      return DoubleMDMatrix3D.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseFloatMatrix3D)
      mdarray = MDArray.from_jstorage("float", 
                                      [colt_matrix.slices, colt_matrix.rows, 
                                       colt_matrix.columns], colt_matrix.elements)
      return FloatMDMatrix3D.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseLongMatrix3D)
      mdarray = MDArray.from_jstorage("long", 
                                      [colt_matrix.slices, colt_matrix.rows, 
                                       colt_matrix.columns], colt_matrix.elements)
      return LongMDMatrix3D.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseIntMatrix3D)
      mdarray = MDArray.from_jstorage("int", 
                                      [colt_matrix.slices, colt_matrix.rows, 
                                       colt_matrix.columns], colt_matrix.elements)
      return IntMDMatrix3D.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseDoubleMatrix2D)
      mdarray = MDArray.from_jstorage("double", [colt_matrix.rows, colt_matrix.columns], 
                                      colt_matrix.elements)
      return DoubleMDMatrix2D.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseFloatMatrix2D)
      mdarray = MDArray.from_jstorage("float", [colt_matrix.rows, colt_matrix.columns], 
                                      colt_matrix.elements)
      return FloatMDMatrix2D.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseLongMatrix2D)
      mdarray = MDArray.from_jstorage("long", [colt_matrix.rows, colt_matrix.columns], 
                                      colt_matrix.elements)
      return LongMDMatrix2D.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseIntMatrix2D)
      mdarray = MDArray.from_jstorage("int", [colt_matrix.rows, colt_matrix.columns], 
                                      colt_matrix.elements)
      return IntMDMatrix2D.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseDoubleMatrix1D)
      mdarray = MDArray.from_jstorage("double", [colt_matrix.size], colt_matrix.elements)
      return DoubleMDMatrix1D.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseFloatMatrix1D)
      mdarray = MDArray.from_jstorage("float", [colt_matrix.size], colt_matrix.elements)
      return FloatMDMatrix1D.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseLongMatrix1D)
      mdarray = MDArray.from_jstorage("long", [colt_matrix.size], colt_matrix.elements)
      return LongMDMatrix1D.from_mdarray(mdarray)
    elsif (colt_matrix.is_a? DenseIntMatrix1D)
      mdarray = MDArray.from_jstorage("int", [colt_matrix.size], colt_matrix.elements)
      return IntMDMatrix1D.from_mdarray(mdarray)
    end

  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def copy
    MDMatrix.from_mdarray(self.mdarray.copy)
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

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  private

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------
  
  def initialize(mdarray, colt_matrix, algebra)
    @mdarray = mdarray
    @colt_matrix = colt_matrix
    @colt_algebra = algebra
    @rank = @mdarray.rank
    @property = property_init(self)
  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def self.dense1D(mdarray)

    storage = mdarray.nc_array.getStorage()
    index = mdarray.nc_array.getIndex()
    size = index.size

    klass = index.getClass
    field = klass.getDeclaredField("stride0")
    field.setAccessible true
    stride0 = field.get(index)
    # p stride0

    klass = klass.getSuperclass()
    field = klass.getDeclaredField("offset")
    field.setAccessible true
    offset = field.get(index)
    # p offset

    case mdarray.type
    when "double"
      colt_matrix = DenseDoubleMatrix1D.new(size, storage, offset, stride0, false)
      DoubleMDMatrix1D.new(mdarray, colt_matrix)
    when "float"
      colt_matrix = DenseFloatMatrix1D.new(size, storage, offset, stride0, false)
      FloatMDMatrix1D.new(mdarray, colt_matrix)
    when "long"
      colt_matrix = DenseLongMatrix1D.new(size, storage, offset, stride0, false)
      LongMDMatrix1D.new(mdarray, colt_matrix)
    when "int"
      colt_matrix = DenseIntMatrix1D.new(size, storage, offset, stride0, false)
      IntMDMatrix1D.new(mdarray, colt_matrix)
    end

  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def self.dense2D(mdarray)

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
      DoubleMDMatrix2D.new(mdarray, colt_matrix)
    when "float"
      colt_matrix = DenseFloatMatrix2D.new(shape[0], shape[1], storage, offset, 0, 
                                           stride0, stride1, false)
      FloatMDMatrix2D.new(mdarray, colt_matrix)
    when "long"
      colt_matrix = DenseLongMatrix2D.new(shape[0], shape[1], storage, offset, 0, 
                                          stride0, stride1, false)
      LongMDMatrix2D.new(mdarray, colt_matrix)
    when "int"
      colt_matrix = DenseIntMatrix2D.new(shape[0], shape[1], storage, offset, 0, 
                                         stride0, stride1, false)
      IntMDMatrix2D.new(mdarray, colt_matrix)
    end

  end

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def self.dense3D(mdarray)

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

    field = klass.getDeclaredField("stride2")
    field.setAccessible true
    stride2 = field.get(index)
    # p stride2

    klass = klass.getSuperclass()
    field = klass.getDeclaredField("offset")
    field.setAccessible true
    offset = field.get(index)
    # p offset

    case mdarray.type
    when "double"
      colt_matrix = DenseDoubleMatrix3D.new(shape[0], shape[1], shape[2], storage, 
                                            offset, 0, 0, stride0, stride1, stride2, false)
      DoubleMDMatrix3D.new(mdarray, colt_matrix)
    when "float"
      colt_matrix = DenseFloatMatrix3D.new(shape[0], shape[1], shape[2], storage, 
                                           offset, 0, 0, stride0, stride1, stride2, false)
      FloatMDMatrix3D.new(mdarray, colt_matrix)
    when "long"
      colt_matrix = DenseLongMatrix3D.new(shape[0], shape[1], shape[2], storage, 
                                          offset, 0, 0, stride0, stride1, stride2, false)
      LongMDMatrix3D.new(mdarray, colt_matrix)
    when "int"
      colt_matrix = DenseIntMatrix3D.new(shape[0], shape[1], shape[2], storage, 
                                         offset, 0, 0, stride0, stride1, stride2, false)
      IntMDMatrix3D.new(mdarray, colt_matrix)
    end

  end

end # MDMatrix

require_relative 'matrix_hierarchy'
require_relative 'matrix2D_floating_algebra'
