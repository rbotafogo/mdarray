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
# Floating point Matrices
##########################################################################################

class FloatingMDMatrix < MDMatrix

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  private

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix, algebra)
    super(mdarray, colt_matrix, algebra.property(), algebra)
  end

end

##########################################################################################
#
##########################################################################################

class DoubleMDMatrix < FloatingMDMatrix
  include_package "cern.colt.matrix.tdouble.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix, tolerance = nil)
    super(mdarray, colt_matrix, DenseDoubleAlgebra.new)
  end

end # DoubleMDMatrix

##########################################################################################
#
##########################################################################################

class DoubleMDMatrix1D < DoubleMDMatrix

end # DoubleMDMatrix1D

##########################################################################################
#
##########################################################################################

class DoubleMDMatrix2D < DoubleMDMatrix

end # DoubleMDMatrix2D

##########################################################################################
#
##########################################################################################

class DoubleMDMatrix3D < DoubleMDMatrix

end # DoubleMDMatrix3D



##########################################################################################
#
##########################################################################################

class FloatMDMatrix < FloatingMDMatrix
  include_package "cern.colt.matrix.tfloat.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix, tolerance = nil)
    super(mdarray, colt_matrix, DenseFloatAlgebra.new)
  end

end # FloatMDMatrix

##########################################################################################
#
##########################################################################################

class FloatMDMatrix1D < FloatMDMatrix

end # FloatMDMatrix1D


##########################################################################################
#
##########################################################################################

class FloatMDMatrix2D < FloatMDMatrix

end # FloatMDMatrix2D


##########################################################################################
#
##########################################################################################

class FloatMDMatrix3D < FloatMDMatrix

end # FloatMDMatrix3D



##########################################################################################
# Floating point Matrices
##########################################################################################

class FixPointMDMatrix < MDMatrix

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  private

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix, property)
    super(mdarray, colt_matrix, property)
  end

end # FixPointMDMatrix


##########################################################################################
#
##########################################################################################

class LongMDMatrix < FixPointMDMatrix
  include_package "cern.colt.matrix.tlong.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix, LongProperty.new)
  end

end # LongMDMatrix

##########################################################################################
#
##########################################################################################

class LongMDMatrix1D < LongMDMatrix

end # LongMDMatrix1D

##########################################################################################
#
##########################################################################################

class LongMDMatrix2D < LongMDMatrix

end # LongMDMatrix2D

##########################################################################################
#
##########################################################################################

class LongMDMatrix3D < LongMDMatrix

end # LongMDMatrix3D


##########################################################################################
#
##########################################################################################

class IntMDMatrix < FixPointMDMatrix
  include_package "cern.colt.matrix.tint.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix, IntProperty.new)
  end

end # IntMDMatrix

##########################################################################################
#
##########################################################################################

class IntMDMatrix1D < IntMDMatrix

end # IntMDMatrix1D

##########################################################################################
#
##########################################################################################

class IntMDMatrix2D < IntMDMatrix

end # IntMDMatrix2D

##########################################################################################
#
##########################################################################################

class IntMDMatrix3D < IntMDMatrix

end # IntMDMatrix3D
