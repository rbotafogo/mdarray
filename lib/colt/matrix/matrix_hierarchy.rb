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
# Floating point 1D Matrices
##########################################################################################

class FloatingMDMatrix1D < FloatingMDMatrix

end # FloatingMDMatrix1D

##########################################################################################
#
##########################################################################################

class DoubleMDMatrix1D < FloatingMDMatrix1D
  include_package "cern.colt.matrix.tdouble.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix, tolerance = nil)
    super(mdarray, colt_matrix, DenseDoubleAlgebra.new)
  end

end # DoubleMDMatrix1D

##########################################################################################
#
##########################################################################################

class FloatMDMatrix1D < FloatingMDMatrix1D
  include_package "cern.colt.matrix.tfloat.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix, tolerance = nil)
    super(mdarray, colt_matrix, DenseFloatAlgebra.new)
  end

end # FloatMDMatrix1D

##########################################################################################
# Floating point 2D Matrices
##########################################################################################

class FloatingMDMatrix2D < FloatingMDMatrix

end # FloatingMDMatrix2D

##########################################################################################
#
##########################################################################################

class DoubleMDMatrix2D < FloatingMDMatrix2D
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

class FloatMDMatrix2D < FloatingMDMatrix2D
  include_package "cern.colt.matrix.tfloat.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix, DenseFloatAlgebra.new)
  end

end # FloatMDMatrix

##########################################################################################
#
##########################################################################################

class DoubleMDMatrix3D < FloatingMDMatrix1D
  include_package "cern.colt.matrix.tdouble.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix, DenseDoubleAlgebra.new)
  end

end # DoubleMDMatrix

##########################################################################################
#
##########################################################################################

class FloatMDMatrix3D < FloatingMDMatrix1D
  include_package "cern.colt.matrix.tfloat.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix, DenseFloatAlgebra.new)
  end

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

end


##########################################################################################
#
##########################################################################################

class LongMDMatrix1D < FixPointMDMatrix
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

class LongMDMatrix2D < FixPointMDMatrix
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

class LongMDMatrix3D < FixPointMDMatrix
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

class IntMDMatrix1D < FixPointMDMatrix
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

class IntMDMatrix2D < FixPointMDMatrix
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

class IntMDMatrix3D < FixPointMDMatrix
  include_package "cern.colt.matrix.tint.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix, IntProperty.new)
  end

end # IntMDMatrix
