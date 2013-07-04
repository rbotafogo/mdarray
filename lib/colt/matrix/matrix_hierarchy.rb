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
# Floating point 1D Matrices
##########################################################################################

class FloatingMDMatrix1D < MDMatrix

end # FloatingMDMatrix1D

##########################################################################################
#
##########################################################################################

class DoubleMDMatrix1D < FloatingMDMatrix1D
  include_package "cern.colt.matrix.tdouble.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix)
    @algebra = DenseDoubleAlgebra.new
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

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix)
    @algebra = DenseFloatAlgebra.new
  end

end # FloatMDMatrix1D



##########################################################################################
# Floating point 2D Matrices
##########################################################################################

class FloatingMDMatrix2D < MDMatrix

end # FloatingMDMatrix2D

##########################################################################################
#
##########################################################################################

class DoubleMDMatrix2D < FloatingMDMatrix2D
  include_package "cern.colt.matrix.tdouble.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix)
    @algebra = DenseDoubleAlgebra.new
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
    super(mdarray, colt_matrix)
    @algebra = DenseFloatAlgebra.new
  end

end # FloatMDMatrix





##########################################################################################
#
##########################################################################################

class DoubleMDMatrix3D < MDMatrix
  include_package "cern.colt.matrix.tdouble.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix)
    @algebra = DenseDoubleAlgebra.new
  end

end # DoubleMDMatrix

##########################################################################################
#
##########################################################################################

class FloatMDMatrix3D < MDMatrix
  include_package "cern.colt.matrix.tfloat.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix)
    @algebra = DenseFloatAlgebra.new
  end

end # FloatMDMatrix





##########################################################################################
#
##########################################################################################

class LongMDMatrix1D < MDMatrix
  include_package "cern.colt.matrix.tlong.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix)
  end

end # LongMDMatrix

##########################################################################################
#
##########################################################################################

class LongMDMatrix2D < MDMatrix
  include_package "cern.colt.matrix.tlong.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix)
  end

end # LongMDMatrix

##########################################################################################
#
##########################################################################################

class LongMDMatrix3D < MDMatrix
  include_package "cern.colt.matrix.tlong.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix)
  end

end # LongMDMatrix

##########################################################################################
#
##########################################################################################

class IntMDMatrix1D < MDMatrix
  include_package "cern.colt.matrix.tint.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix)
  end

end # IntMDMatrix

##########################################################################################
#
##########################################################################################

class IntMDMatrix2D < MDMatrix
  include_package "cern.colt.matrix.tint.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix)
  end

end # IntMDMatrix

##########################################################################################
#
##########################################################################################

class IntMDMatrix3D < MDMatrix
  include_package "cern.colt.matrix.tint.algo"

  #------------------------------------------------------------------------------------
  # 
  #------------------------------------------------------------------------------------

  def initialize(mdarray, colt_matrix)
    super(mdarray, colt_matrix)
  end

end # IntMDMatrix
