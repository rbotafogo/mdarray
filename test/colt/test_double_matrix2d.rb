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

require 'rubygems'
require "test/unit"
require 'shoulda'

require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "Colt Matrix" do

    setup do

   
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "test matrix functions" do

      b = MDMatrix.double([3], [1.5, 1, 1.3])

      pos = MDArray.double([3, 3], [2, -1, 0, -1, 2, -1, 0, -1, 2])
      matrix = MDMatrix.from_mdarray(pos)
      result = matrix.chol
      p "Cholesky decomposition"
      result.print
      printf("\n\n")

      eig = matrix.eig
      p "eigen decomposition"
      p "eigenvalue matrix"
      eig[0].print
      printf("\n\n")
      p "imaginary parts of the eigenvalues"
      eig[1].print
      printf("\n\n")
      p "real parts of the eigenvalues"
      eig[2].print
      printf("\n\n")
      p "eigenvector matrix"
      eig[3].print
      printf("\n\n")

      lu = matrix.lu
      p "lu decomposition"
      p "is non singular: #{lu[0]}"
      p "determinant: #{lu[1]}"
      p "pivot vector: #{lu[2]}"
      p "lower triangular matrix"
      lu[3].print
      printf("\n\n")
      p "upper triangular matrix"
      lu[4].print
      printf("\n\n")

      # Returns the condition of matrix A, which is the ratio of largest to 
      # smallest singular value.
      p "condition of matrix"
      p matrix.cond

      # Solves the upper triangular system U*x=b;
      p "solving the equation by backward_solve"
      solve = lu[4].backward_solve(b)
      solve.print
      printf("\n\n")

      # Solves the lower triangular system U*x=b;
      p "solving the equation by forward_solve"
      solve = lu[3].forward_solve(b)
      solve.print
      printf("\n\n")

      qr = matrix.qr
      p "QR decomposition"
      p "Matrix has full rank: #{qr[0]}"
      p "Orthogonal factor Q:"
      qr[1].print
      printf("\n\n")
      p "Upper triangular factor, R"
      qr[2].print
      printf("\n\n")

      svd = matrix.svd
      p "Singular value decomposition"
      p "operation success? #{svd[0]}" # 0 success; < 0 ith value is illegal; > 0 not converge
      p "cond: #{svd[1]}"
      p "norm2: #{svd[2]}"
      p "rank: #{svd[3]}"
      p "singular values"
      p svd[4]
      p "Diagonal matrix of singular values"
      # svd[5].print
      printf("\n\n")
      p "left singular vectors U"
      svd[6].print
      printf("\n\n")
      p "right singular vectors V"
      svd[7].print
      printf("\n\n")

      m = MDArray.typed_arange("double", 0, 16)
      m.reshape!([4, 4])
      matrix1 = MDMatrix.from_mdarray(m)
      # mat2 = matrix.chol
      matrix1.print
      printf("\n\n")

      m = MDArray.typed_arange("double", 16, 32)
      m.reshape!([4, 4])
      matrix2 = MDMatrix.from_mdarray(m)
      matrix2.print
      printf("\n\n")
      
      result = matrix1 * matrix2
      p "matrix multiplication"
      result.print 
      printf("\n\n")

      result = matrix1.kron(matrix2)
      p "Kronecker multiplication"
      result.print
      printf("\n\n")

      print "determinant is: #{result.det}"
      printf("\n\n")

      p "norm1"
      p result.norm1

      p "norm2"
      p result.norm2

      p "Returns the Frobenius norm of matrix A, which is Sqrt(Sum(A[i,j]^2))"
      p result.normF

      p "Returns the infinity norm of matrix A, which is the maximum absolute row sum."
      p result.norm_infinity

      power3 = result ** 3
      power3.print 
      printf("\n\n")

      p result.trace

      trap_lower = result.trapezoidal_lower
      trap_lower.print
      printf("\n\n")

      p result.vector_norm2

      result.normalize!
      result.print
      printf("\n\n")

      p "summing all values of result: #{result.sum}"

      result.mdarray.print

    end
#=end
  end

end
