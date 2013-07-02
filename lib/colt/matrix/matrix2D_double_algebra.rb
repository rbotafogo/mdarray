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
  # Solves the upper triangular system U*x=b;
  #------------------------------------------------------------------------------------

  def backward_solve(matrix1D)
    result = @algebra.backwardSolve(matrix1D.colt_matrix)
    MDMatrix.from_colt_matrix(result)
  end

  #------------------------------------------------------------------------------------
  # Constructs and returns the cholesky-decomposition of the given matrix. For a 
  # symmetric, positive definite matrix A, the Cholesky decomposition is a lower 
  # triangular matrix L so that A = L*L'; If the matrix is not symmetric positive 
  # definite, the IllegalArgumentException is thrown.
  #------------------------------------------------------------------------------------

  def chol
    result = @algebra.chol(@colt_matrix).getL()
    MDMatrix.from_colt_matrix(result)
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

  def eig
    eig = @algebra.eig(@colt_matrix)
    [MDMatrix.from_colt_matrix(eig.getD), 
     MDMatrix.from_colt_matrix(eig.getImagEigenvalues),
     MDMatrix.from_colt_matrix(eig.getRealEigenvalues),
     MDMatrix.from_colt_matrix(eig.getV)]
  end

  #------------------------------------------------------------------------------------
  # Solves the lower triangular system L*x=b;
  #------------------------------------------------------------------------------------

  def forward_solve(matrix1D)
    result = @algebra.forwardSolve(matrix1D.colt_matrix)
    MDMatrix.from_colt_matrix(result)
  end

  #------------------------------------------------------------------------------------
  # Returns the inverse or pseudo-inverse of matrix A.
  #------------------------------------------------------------------------------------

  def inverse
    result = @algebra.inverse(@colt_matrix)
    MDMatrix.from_colt_matrix(result)
  end

  #------------------------------------------------------------------------------------
  # Computes the Kronecker product of two real matrices.
  #------------------------------------------------------------------------------------

  def kron(matrix)

    if (matrix.rank != 2)
      raise "Rank should be 2"
    end
    result = @algebra.kron(@colt_matrix, matrix.colt_matrix)
    MDMatrix.from_colt_matrix(result)

  end

  #------------------------------------------------------------------------------------
  # Constructs and returns the LU-decomposition of the given matrix.
  #------------------------------------------------------------------------------------

  def lu
    result = @algebra.lu(@colt_matrix)
    [result.isNonsingular(), result.det(), result.getPivot.to_a(),
     MDMatrix.from_colt_matrix(result.getL()),
     MDMatrix.from_colt_matrix(result.getU())]
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

  #------------------------------------------------------------------------------------
  # Returns the one-norm of vector x, which is Sum(abs(x[i])).
  #------------------------------------------------------------------------------------

  def norm1
    @algebra.norm1(@colt_matrix)
  end

  #------------------------------------------------------------------------------------
  # Returns the two-norm of matrix A, which is the maximum singular value; obtained 
  # from SVD.
  #------------------------------------------------------------------------------------

  def norm2
    @algebra.norm2(@colt_matrix)
  end

  #------------------------------------------------------------------------------------
  # Returns the Frobenius norm of matrix A, which is Sqrt(Sum(A[i,j]^2))
  #------------------------------------------------------------------------------------

  def normF
    @algebra.normF(@colt_matrix)
  end

  #------------------------------------------------------------------------------------
  # Returns the infinity norm of matrix A, which is the maximum absolute row sum.
  #------------------------------------------------------------------------------------

  def norm_infinity
    @algebra.normInfinity(@colt_matrix)
  end

  #------------------------------------------------------------------------------------
  # Linear algebraic matrix power; B = A^k <==> B = A*A*...
  #------------------------------------------------------------------------------------

  def power(val)
    result = @algebra.pow(@colt_matrix, val)
    MDMatrix.from_colt_matrix(result)
  end

  alias :** :power

  #------------------------------------------------------------------------------------
  # Returns the effective numerical rank of matrix A, obtained from Singular Value 
  # Decomposition.
  #------------------------------------------------------------------------------------

  def numerical_rank
    @algebra.rank(@colt_matrix)
  end

  #------------------------------------------------------------------------------------
  # Solves A*X = B
  #------------------------------------------------------------------------------------
  
  def solve(matrix)
    result = @algebra.solve(@colt_matrix, matrix.colt_matrix)
    MDMatris.from_colt_matrix(resul)
  end

  #------------------------------------------------------------------------------------
  # Solves X*A = B, which is also A'*X' = B'.
  #------------------------------------------------------------------------------------

  def solve_transpose(matrix)
    result = @algebra.solveTranspose(@colt_matrix, matrix.colt_matrix)
    MDMatris.from_colt_matrix(resul)
  end

  #------------------------------------------------------------------------------------
  # Returns the sum of the diagonal elements of matrix A; Sum(A[i,i]).
  #------------------------------------------------------------------------------------

  def trace
    @algebra.trace(@colt_matrix)
  end

  #------------------------------------------------------------------------------------
  # Modifies the matrix to be a lower trapezoidal matrix.
  #------------------------------------------------------------------------------------

  def trapezoidal_lower
    result = @algebra.trapezoidalLower(@colt_matrix)
    MDMatrix.from_colt_matrix(result)
  end

  #------------------------------------------------------------------------------------
  # Returns the two-norm (aka euclidean norm) of vector X.vectorize();
  #------------------------------------------------------------------------------------

  def vector_norm2
    @algebra.vectorNorm2(@colt_matrix)
  end

end # 

##########################################################################################
#
##########################################################################################

class DoubleMDMatrix2D

  include Matrix2DDoubleAlgebra

end # MDMatrix
