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

# require 'jruby/core_ext'

require 'java'

##########################################################################################
#
##########################################################################################

module Matrix2DDoubleAlgebra
  include_package "cern.colt.matrix.tdouble.algo"

  #------------------------------------------------------------------------------------
  # Constructs and returns the cholesky-decomposition of the given matrix.
  #------------------------------------------------------------------------------------

  def chol
    @algebra.chol(@colt_matrix)
  end

  #------------------------------------------------------------------------------------
  # Returns the condition of matrix A, which is the ratio of largest to smallest 
  # singular value.
  #------------------------------------------------------------------------------------

  def cond
    @algebra.cond(@colt_matrix)
  end

  #------------------------------------------------------------------------------------
  # Returns the determinant of matrix A.
  #------------------------------------------------------------------------------------

  def det
    @algebra.det(@colt_matrix)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def inverse
    result = @algebra.inverse(@colt_matrix)
    MDMatrix.from_colt_matrix(result)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def kron(matrix)

    if (matrix.rank != 2)
      raise "Rank should be 2"
    end
    result = @algebra.kron(@colt_matrix, matrix.colt_matrix)
    MDMatrix.from_colt_matrix(result)

  end

  #------------------------------------------------------------------------------------
  # Multiplies this matrix by another matrix
  #------------------------------------------------------------------------------------

  def mult(matrix)

    if (matrix.rank > 2)
      raise "Rank should be 1 or 2"
    end

    result = @colt_matrix.like
    @colt_matrix.zMult(matrix.colt_matrix, result)
    MDMatrix.from_colt_matrix(result)

  end

  alias :* :mult

end # 

##########################################################################################
#
##########################################################################################

class DoubleMDMatrix2D

  include Matrix2DDoubleAlgebra

end # MDMatrix
