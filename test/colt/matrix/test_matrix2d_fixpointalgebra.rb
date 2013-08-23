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

    should "get and set values for long Matrix" do

      a = MDMatrix.long([4, 4])
      a[0, 0] = 1
      assert_equal(1, a[0, 0])
      assert_equal(0.0, a[0, 1])

      a.fill(2)
      assert_equal(2, a[3, 3])

      b = MDMatrix.long([4, 4])
      b.fill(a)
      assert_equal(2, b[1, 3])

      # fill the matrix with the value of a Proc evaluation.  The argument to the 
      # Proc is the content of the array at the given index, i.e, x = b[i] for all i.
      func = Proc.new { |x| x ** 2 }
      b.fill(func)
      assert_equal(4, b[0, 3])
      b.print
      printf("\n\n")

      # fill the Matrix with the value of method apply from a given class.
      # In general this solution is more efficient than the above solution with
      # Proc.  
      class LongFunc
        def self.apply(x)
          x/2
        end
      end

      b.fill(LongFunc)
      assert_equal(2, b[2,0])
      b.print
      printf("\n\n")

      # defines a class with a method apply with two arguments
      class LongFunc2
        def self.apply(x, y)
          (x + y) ** 2
        end
      end
      
      # fill array a with the value the result of a function to each cell; 
      # x[row,col] = function(x[row,col],y[row,col]).
      a.fill(b, LongFunc2)
      a.print
      printf("\n\n")

      tens = MDMatrix.init_with("long", [5, 3], 10.0)
      tens.print
      printf("\n\n")

      typed_arange = MDMatrix.typed_arange("long", 0, 20, 2)
      typed_arange.print
      printf("\n\n")
      
      linspace = MDMatrix.linspace("long", 0, 10, 50)
      linspace.print
      printf("\n\n")

      # set the value of all cells that are bigger than 5 to 1.0
      linspace.fill_cond(Proc.new { |x| x > 5 }, 1.0)
      linspace.print
      printf("\n\n")

      # set the value of all cells that are smaller than 5 to the square value
      linspace.fill_cond(Proc.new { |x| x < 5 }, Proc.new { |x| x * x })
      linspace.print
      printf("\n\n")
      
      ones = MDMatrix.ones("long", [3, 5])
      ones.print
      printf("\n\n")

      arange = MDMatrix.arange(0, 10)
      arange.print
      printf("\n\n")

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "test 2d long matrix functions" do

      m = MDArray.typed_arange("long", 0, 16)
      m.reshape!([4, 4])
      matrix1 = MDMatrix.from_mdarray(m)
      # mat2 = matrix.chol
      matrix1.print
      printf("\n\n")

      p "Transposing the above matrix"
      matrix1.transpose.print
      printf("\n\n")

      p "getting regions from the above matrix"
      p "specification is '0:0, 1:3'"
      matrix1.region(:spec => "0:0, 1:3").print
      printf("\n\n")

      p "specification is '0:3:2, 1:3'"
      matrix1.region(:spec => "0:3:2, 1:3").print
      printf("\n\n")

      p "flipping dim 0 of the matrix"
      matrix1.flip(0).print
      printf("\n\n")

      m = MDArray.typed_arange("long", 16, 32)
      m.reshape!([4, 4])
      matrix2 = MDMatrix.from_mdarray(m)
      matrix2.print
      printf("\n\n")
      
      result = matrix1 * matrix2
      p "matrix multiplication of square matrices"
      result.print 
      printf("\n\n")

      p "matrix multiplication of rec matrices"
      array1 = MDMatrix.long([2, 3], [1, 2, 3, 4, 5, 6])
      array2 = MDMatrix.long([3, 2], [1, 2, 3, 4, 5, 6])
      mult = array1 * array2
      mult.print
      printf("\n\n")

      p "matrix multiplication of rec matrices passing alpha and beta parameters."
      p "C = alpha * A x B + beta*C"
      mult = array1.mult(array2, 2, 2)
      mult.print
      printf("\n\n")

      p "matrix multiplication of rec matrices passing alpha, beta and return (C) parameters."
      p "C = alpha * A x B + beta*C"
      result = MDMatrix.long([2, 2], [2, 2, 2, 2])
      mult = array1.mult(array2, 2, 2, false, false, result)
      mult.print
      printf("\n\n")

      p "matrix multiplication by vector"
      array1 = MDMatrix.long([2, 3], [1, 2, 3, 4, 5, 6])
      array2 = MDMatrix.long([3], [4, 5, 6])
      mult = array1 * array2
      mult.print
      printf("\n\n")

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "get and set values for int Matrix" do

      a = MDMatrix.int([4, 4])
      a[0, 0] = 1
      assert_equal(1, a[0, 0])
      assert_equal(0.0, a[0, 1])

      a.fill(2)
      assert_equal(2, a[3, 3])

      b = MDMatrix.int([4, 4])
      b.fill(a)
      assert_equal(2, b[1, 3])

      # fill the matrix with the value of a Proc evaluation.  The argument to the 
      # Proc is the content of the array at the given index, i.e, x = b[i] for all i.
      func = Proc.new { |x| x ** 2 }
      b.fill(func)
      assert_equal(4, b[0, 3])
      b.print
      printf("\n\n")

      # fill the Matrix with the value of method apply from a given class.
      # In general this solution is more efficient than the above solution with
      # Proc.  
      class IntFunc
        def self.apply(x)
          x/2
        end
      end

      b.fill(IntFunc)
      assert_equal(2, b[2,0])
      b.print
      printf("\n\n")

      # defines a class with a method apply with two arguments
      class IntFunc2
        def self.apply(x, y)
          (x + y) ** 2
        end
      end
      
      # fill array a with the value the result of a function to each cell; 
      # x[row,col] = function(x[row,col],y[row,col]).
      a.fill(b, IntFunc2)
      a.print
      printf("\n\n")

      tens = MDMatrix.init_with("int", [5, 3], 10.0)
      tens.print
      printf("\n\n")

      typed_arange = MDMatrix.typed_arange("int", 0, 20, 2)
      typed_arange.print
      printf("\n\n")
      
      linspace = MDMatrix.linspace("int", 0, 10, 50)
      linspace.print
      printf("\n\n")

      # set the value of all cells that are bigger than 5 to 1.0
      linspace.fill_cond(Proc.new { |x| x > 5 }, 1.0)
      linspace.print
      printf("\n\n")

      # set the value of all cells that are smaller than 5 to the square value
      linspace.fill_cond(Proc.new { |x| x < 5 }, Proc.new { |x| x * x })
      linspace.print
      printf("\n\n")
      
      ones = MDMatrix.ones("int", [3, 5])
      ones.print
      printf("\n\n")

      arange = MDMatrix.arange(0, 10)
      arange.print
      printf("\n\n")

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "test 2d int matrix functions" do

      m = MDArray.typed_arange("int", 0, 16)
      m.reshape!([4, 4])
      matrix1 = MDMatrix.from_mdarray(m)
      # mat2 = matrix.chol
      matrix1.print
      printf("\n\n")

      p "Transposing the above matrix"
      matrix1.transpose.print
      printf("\n\n")

      p "getting regions from the above matrix"
      p "specification is '0:0, 1:3'"
      matrix1.region(:spec => "0:0, 1:3").print
      printf("\n\n")

      p "specification is '0:3:2, 1:3'"
      matrix1.region(:spec => "0:3:2, 1:3").print
      printf("\n\n")

      p "flipping dim 0 of the matrix"
      matrix1.flip(0).print
      printf("\n\n")

      m = MDArray.typed_arange("int", 16, 32)
      m.reshape!([4, 4])
      matrix2 = MDMatrix.from_mdarray(m)
      matrix2.print
      printf("\n\n")
      
      result = matrix1 * matrix2
      p "matrix multiplication of square matrices"
      result.print 
      printf("\n\n")

      p "matrix multiplication of rec matrices"
      array1 = MDMatrix.int([2, 3], [1, 2, 3, 4, 5, 6])
      array2 = MDMatrix.int([3, 2], [1, 2, 3, 4, 5, 6])
      mult = array1 * array2
      mult.print
      printf("\n\n")

      p "matrix multiplication of rec matrices passing alpha and beta parameters."
      p "C = alpha * A x B + beta*C"
      mult = array1.mult(array2, 2, 2)
      mult.print
      printf("\n\n")

      p "matrix multiplication of rec matrices passing alpha, beta and return (C) parameters."
      p "C = alpha * A x B + beta*C"
      result = MDMatrix.int([2, 2], [2, 2, 2, 2])
      mult = array1.mult(array2, 2, 2, false, false, result)
      mult.print
      printf("\n\n")

      p "matrix multiplication by vector"
      array1 = MDMatrix.int([2, 3], [1, 2, 3, 4, 5, 6])
      array2 = MDMatrix.int([3], [4, 5, 6])
      mult = array1 * array2
      mult.print
      printf("\n\n")

    end

#=end
  end

end

=begin

Example of SVD decomposition with PColt.  Check if working!

A =2.0  0.0 8.0 6.0 0.0
   1.0 6.0 0.0 1.0 7.0
   5.0 0.0 7.0 4.0 0.0
   7.0 0.0 8.0 5.0 0.0 
   0.0 10.0 0.0 0.0 7.0

U = -0.542255   0.0649957  0.821617  0.105747  -0.124490 
    -0.101812  -0.593461 -0.112552  0.788123   0.0602700
    -0.524953   0.0593817 -0.212969 -0.115742   0.813724 
    -0.644870   0.0704063 -0.508744 -0.0599027 -0.562829 
    -0.0644952 -0.796930  0.0900097 -0.592195  -0.0441263

VT =-0.464617   0.0215065 -0.868509   0.000799554 -0.171349
    -0.0700860 -0.759988  0.0630715 -0.601346   -0.227841
    -0.735094   0.0987971  0.284009  -0.223485    0.565040
    -0.484392   0.0254474  0.398866   0.332684   -0.703523
    -0.0649698 -0.641520 -0.0442743  0.691201    0.323284

S = 
(00)    17.91837085874625
(11)    15.17137188041607
(22)    3.5640020352605677
(33)    1.9842281528992616
(44)    0.3495556671751232







Dot product (or inner product of scalar product) of 2 vectors

>>> import scipy as sp
>>> x = sp.array([1,-2, .0])
>>> y = sp.array([2, 5, -1.0])
>>> dotproduct = sp.dot(x,y)
>>> print dotproduct
-8.0
Matrix product.

>>> import scipy as sp
>>> A = sp.array([[3.2, -1, 2],[2,-2,4],[1.5,-1,-4]])
>>> B = sp.array([[1., 2.],[-1., 2.0],[2, -1.5]])

>>> Matrixproduct = sp.dot(A,B)
>>> print Matrixproduct
[[ 8.2,  1.4]
 [ 12.,  -6. ]
 [ -5.5,  7. ]]
Matrix-vector product

>>> import scipy as sp
>>> x = sp.array([1,-2, .0])
>>> A = sp.array([[3.2, -1, 2],[2,-2,4],[1.5,-1,-4]])
>>> b = sp.dot(A,x)
>>> print b
[ 5.2,  6.,   3.5]
Diagonal, transpose and trace

>>> print sp.diagonal(A)   #returns the diagonal of A
array([ 3.2, -2., -4.]) 
>>> D = sp.diag((1, 2, 3))  # return a diagonal matrix
[[1 0 0]
 [0 2 0]
 [0 0 3]]
>>> print sp.transpose(A)
[[ 3.2  2.   1.5]
 [-1.  -2.  -1. ]
 [ 2.   4.  -4. ]]
>>> print sp.trace(A)
-2.7999999999999998
Determinant and inverse. To compute the determinant or the inverse of a matrix, we need the numpy linear algebra submodule linalg

>>> import numpy 
>>> import numpy.linalg
>>> A = numpy.array([[3.2, -1, 2],[2,-2,4],[1.5,-1,-4]])
>>> determinant = numpy.linalg.det(A)
>>> print determinant
26.4
>>> inverse = numpy.linalg.inv(A)
[[ 0.45454545 -0.22727273  0.        ]
 [ 0.53030303 -0.59848485 -0.33333333]
 [ 0.03787879  0.06439394 -0.16666667]]
1.2 Eigenvalue and Eigenvectors


>>> import numpy as np
>>> import np.linalg
>>> A = np.array([[3.2, -1, 2],[2,-2,4],[1.5,-1,-4]])
>>> e_values, e_vectors = np.linalg.eig(A)       #returns a list e_values of eigenvalues and a matrix e_vector whose row i corresponds 
                                                 #to the eigenvectors associated with eigenvalue i
>>> print e_values
[ 2.965908+0.j, -2.882954+0.76793809j, -2.882954-0.76793809j ]
>>> print e_vectors    # row i corresponds to the eigenvector
		       # associated with eigenvalues i
[[ 0.88158576+0.j, -0.25687900+0.02847007j, -0.25687900-0.02847007j]
 [ 0.45531661+0.j, -0.89064266+0.j, -0.89064266+0.j        ]
 [ 0.12447222+0.j,  0.32503863-0.18522464j, 0.32503863+0.18522464j]]
1.3 Matrix factorization

LU factorization (LU_Decomposition.py). 
Given a matrix A, A can be written as A = PLU where L lower triangular matrix U upper triangular matrix P is the matrix whose row i is a permutation of the identity matrix row i
	LU_Decomposition.py
"""
LU decomposition: M  = PLU
"""
import scipy
import scipy.linalg

if __name__ == "__main__":
	M = scipy.array([ [1,-2, 3], [0,2,-1], [1,3,-2] ])
	P, L, U = scipy.linalg.lu(M)
	
	print "P = ",P
	print "L = ",L
	print 'U = ', U
QR factorization (QR_Decomposition.py). 
Given a mxn matrix M, find a mxm unitary matrix Q  -  that is   where   is the adjoint of Q  -  and a mxn upper triangular matrix R such that M = QR.
"""
QR decomposition: M = QR
"""
import scipy
import scipy.linalg

if __name__ == "__main__":
	M = scipy.array([ [1,-2,3], [2,1,-1], [1,0,2], [0,-2,-1]])
	Q, R = scipy.linalg.qr(M)
	
	print "Q = ",Q
	print "R = ", R
Singular values decomposition:(SVD.py) 
For a given mxn matrix A.   and   are Hermitians - a matrix H is Hermitian if it is equal to its adjoint, i.e.  - so their eigenvalues are all real positive numbers. Further there are at most Min(m,n) non-zero identical eigenvalues  for   and   . The square roots of these are called singular values. A can be decomposed as   where U is a mxm matrix of eigenvectors of  , V is a nxn matrix of eigenvectors of   and   is mxn diagonal matrix whose entries are the singular values. The command linalg.svd will return U, V, and a list of singular values. To obtain the matrix  use linalg.diagsvd.

"""
SVD,  A = U \Sigma V
"""
import scipy
import scipy.linalg
if __name__ == "__main__":
	A = scipy.array([[1,-2],[2,0],[-1,3]])
	U,s,V = scipy.linalg.svd(A) #s is the list os singular values
	
	print "U = ",U
	print "V = ", V
	print "singular values list = ",s
	Sigma = scipy.mat(scipy.linalg.diagsvd(s,3,2))
	print "Sigma = ", Sigma
Cholesky factorization (CholeskyDecomposition.py): Given a Hermitian matrix M. Find a decomposition as M =   where U is a upper triangular matrix and   is the adjoint of U
"""
Cholesky decomposition.  M = VU where 
U is a upper triangular matrix and V is the adjoint of U
"""
import scipy
import scipy.linalg

if __name__ == "__main__":
	M =  scipy.array([[1,0,-1],[1,2,1],[0,-1,2]])
	U = scipy.linalg.cholesky(M)
	
	print "U = ", U
Schur factorization (SchurDecomposition.py): For a square nxn matrix M, find a unitary matrix Z and a upper-triangular (or quasi-triangular) matrix T such that 
"""
Schur decomposition:  M = ZTZh, where Zh is the adjoint of Z 
"""
import scipy
import scipy.linalg

if __name__ == "__main__":
	M =  scipy.array([[1,0,-1],[1,2,1],[0,-1,2]])
	Z, T = scipy.linalg.schur(M)
	
	print "Z = ", Z
	print 'T = ', T

=end
