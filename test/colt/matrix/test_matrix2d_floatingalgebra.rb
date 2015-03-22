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

class MDMatrixTest < Test::Unit::TestCase

  context "Colt Matrix" do

    setup do

   
    end
#=begin
    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "do basic matrix algebra" do

      a = MDMatrix.double([4, 4])
      a.fill(2.5)

      b = MDMatrix.fromfunction("double", [4, 4]) { |x, y| x + y }

      c = a + b
      b.reset_traversal
      c.each do |val|
        assert_equal(2.5 + b.next, val)
      end

      c = a * 2
      a.reset_traversal
      c.each do |val|
        assert_equal(a.next * 2, val)
      end

      c = 2 * a
      a.reset_traversal
      c.each do |val|
        assert_equal(a.next * 2, val)
      end

      c = a - 2
      a.reset_traversal
      c.each do |val|
        assert_equal(a.next - 2, val)
      end

      c = 2 - a
      a.reset_traversal
      c.each do |val|
        assert_equal(2 - a.next, val)
      end

      # Need to test/implement matrix division
      assert_raise ( RuntimeError ) { c = a / a }
      assert_raise ( RuntimeError ) { c = a / b }

      p "Matrix division"
      b.generate_non_singular!
      c = a / b
      c.print
      printf("\n\n")

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "get and set values for double Matrix" do

      a = MDMatrix.double([4, 4])
      a[0, 0] = 1
      assert_equal(1, a[0, 0])
      assert_equal(0.0, a[0, 1])

      a.fill(2.5)
      assert_equal(2.5, a[3, 3])

      b = MDMatrix.double([4, 4])
      b.fill(a)
      assert_equal(2.5, b[1, 3])

      # fill the matrix with the value of a Proc evaluation.  The argument to the 
      # Proc is the content of the array at the given index, i.e, x = b[i] for all i.
      func = Proc.new { |x| x ** 2 }
      b.fill(func)
      assert_equal(2.5 ** 2, b[0, 3])
      assert_equal(2.5 ** 2, b[1, 1])

      # fill the Matrix with the value of method apply from a given class.
      # In general this solution is more efficient than the above solution with
      # Proc.  
      class DoubleFunc
        def self.apply(x)
          x/2
        end
      end

      b.fill(DoubleFunc)
      assert_equal(3.125, b[2,0])

      # defines a class with a method apply with two arguments
      class DoubleFunc2
        def self.apply(x, y)
          (x + y) ** 2
        end
      end
      
      # fill array a with the value ot the result of a function to each cell; 
      # x[row,col] = function(x[row,col],y[row,col]).
      tmp = a[0,1]
      a.fill(b, DoubleFunc2)
      assert_equal((tmp + b[0, 1]) ** 2, a[0, 1]) 

      tens = MDMatrix.init_with("double", [5, 3], 10.0)
      assert_equal(10.0, tens[2, 2])

      typed_arange = MDMatrix.typed_arange("double", 0, 20, 2)
      assert_equal(0, typed_arange[0])
      assert_equal(2, typed_arange[1])
      assert_equal(4, typed_arange[2])

      typed_arange.reshape!([5, 2])

      val = typed_arange.reduce(Proc.new { |x, y| x + y }, Proc.new { |x| x })
      assert_equal(90, val)

      val = typed_arange.reduce(Proc.new { |x, y| x + y }, Proc.new { |x| x * x})
      assert_equal(1140, val)

      val = typed_arange.reduce(Proc.new { |x, y| x + y }, Proc.new { |x| x },
                                Proc.new { |x| x > 8 })
      assert_equal(70, val)

      linspace = MDMatrix.linspace("double", 0, 10, 50)
      assert_equal(0.20408163265306123, linspace[1])
      assert_equal(1.0204081632653061, linspace[5])

      # set the value of all cells that are bigger than 5 to 1.0
      linspace.fill_cond(Proc.new { |x| x > 5 }, 1.0)
      assert_equal(1.0, linspace[25])
      assert_equal(1.0, linspace[27])
      assert_not_equal(1.0, linspace[24])

      # set the value of all cells that are smaller than 5 to the square value
      linspace.fill_cond(Proc.new { |x| x < 5 }, Proc.new { |x| x * x })
      assert_equal(0.20408163265306123 ** 2, linspace[1])
      assert_equal(1.0204081632653061 ** 2, linspace[5])
      
      ones = MDMatrix.ones("double", [3, 5])
      assert_equal(1.0, ones[2, 1])

      arange = MDMatrix.arange(0, 10)
      assert_equal(0, arange[0])
      assert_equal(1, arange[1])

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "test 2d double matrix functions" do

      b = MDMatrix.double([3], [1.5, 1, 1.3])

      pos = MDArray.double([3, 3], [4, 12, -16, 12, 37, -43, -16, -43, 98])
      matrix = MDMatrix.from_mdarray(pos)

      # Cholesky decomposition from wikipedia example
      chol = matrix.chol
      assert_equal(2, chol[0, 0])
      assert_equal(6, chol[1, 0])
      assert_equal(-8, chol[2, 0])
      assert_equal(5, chol[2, 1])
      assert_equal(3, chol[2, 2])

      matrix = MDMatrix.double([2, 2], [2, 3, 2, 1])
      
      # Finding Determinant
      det = matrix.det
      assert_equal(-4, det)

      # Eigenvalue decomposition
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

      matrix = MDMatrix.double([5, 5], [2.0, 0.0, 8.0, 6.0, 0.0,\
                                        1.0, 6.0, 0.0, 1.0, 7.0,\
                                        5.0, 0.0, 7.0, 4.0, 0.0,\
                                        7.0, 0.0, 8.0, 5.0, 0.0,\
                                        0.0, 10.0, 0.0, 0.0, 7.0])

      svd = matrix.svd
      p "Singular value decomposition"
      p "operation success? #{svd[0]}" # 0 success; < 0 ith value is illegal; > 0 not converge
      p "cond: #{svd[1]}"
      p "norm2: #{svd[2]}"
      p "rank: #{svd[3]}"
      assert_equal(17.91837085874625, svd[4][0])
      assert_equal(15.17137188041607, svd[4][1])
      assert_equal(3.5640020352605677, svd[4][2])
      assert_equal(1.9842281528992616, svd[4][3])
      assert_equal(0.3495556671751232, svd[4][4])

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

      m = MDArray.typed_arange("double", 16, 32)
      m.reshape!([4, 4])
      matrix2 = MDMatrix.from_mdarray(m)
      matrix2.print
      printf("\n\n")
      
      p "matrix multiplication of square matrices"
      result = matrix1 * matrix2
      result.print 
      printf("\n\n")

      p "matrix multiplication of rec matrices"
      array1 = MDMatrix.double([2, 3], [1, 2, 3, 4, 5, 6])
      array2 = MDMatrix.double([3, 2], [1, 2, 3, 4, 5, 6])
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
      result = MDMatrix.double([2, 2], [2, 2, 2, 2])
      mult = array1.mult(array2, 2, 2, false, false, result)
      mult.print
      printf("\n\n")

      p "matrix multiplication by vector"
      array1 = MDMatrix.double([2, 3], [1, 2, 3, 4, 5, 6])
      vector = MDMatrix.double([3], [4, 5, 6])
      mult = array1 * vector
      mult.print
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

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "get and set values for float Matrix" do

      a = MDMatrix.float([4, 4])
      a[0, 0] = 1
      assert_equal(1, a[0, 0])
      assert_equal(0.0, a[0, 1])

      a.fill(2.5)
      assert_equal(2.5, a[3, 3])

      b = MDMatrix.float([4, 4])
      b.fill(a)
      assert_equal(2.5, b[1, 3])

      # fill the matrix with the value of a Proc evaluation.  The argument to the 
      # Proc is the content of the array at the given index, i.e, x = b[i] for all i.
      func = Proc.new { |x| x ** 2 }
      b.fill(func)
      assert_equal(6.25, b[0, 3])
      b.print
      printf("\n\n")

      p "defining function in a class"

      # fill the Matrix with the value of method apply from a given class.
      # In general this solution is more efficient than the above solution with
      # Proc.  
      class Func
        def self.apply(x)
          x/2
        end
      end

      b.fill(Func)
      assert_equal(3.125, b[2,0])
      b.print
      printf("\n\n")

      # defines a class with a method apply with two arguments
      class Func2
        def self.apply(x, y)
          (x + y) ** 2
        end
      end
      
      # fill array a with the value the result of a function to each cell; 
      # x[row,col] = function(x[row,col],y[row,col]).
      a.fill(b, Func2)
      a.print

      tens = MDMatrix.init_with("float", [5, 3], 10.0)
      tens.print
      printf("\n\n")

      typed_arange = MDMatrix.typed_arange("float", 0, 20, 2)
      typed_arange.print
      printf("\n\n")
      
      typed_arange.reshape!([5, 2])
      p "printing typed_arange"
      typed_arange.print
      printf("\n\n")

      p "reducing the value of typed_arange by summing all value"
      val = typed_arange.reduce(Proc.new { |x, y| x + y }, Proc.new { |x| x })
      p val
      assert_equal(90, val)

      p "reducing the value of typed_arange by summing the square of all value"
      val = typed_arange.reduce(Proc.new { |x, y| x + y }, Proc.new { |x| x * x})
      p val
      assert_equal(1140, val)

      p "reducing the value of typed_arange by summing all value larger than 8"
      val = typed_arange.reduce(Proc.new { |x, y| x + y }, Proc.new { |x| x },
                                Proc.new { |x| x > 8 })
      p val


      linspace = MDMatrix.linspace("float", 0, 10, 50)
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

      ones = MDMatrix.ones("float", [3, 5])
      ones.print
      printf("\n\n")

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "test 2d float matrix functions" do

      b = MDMatrix.float([3], [1.5, 1, 1.3])

      pos = MDArray.float([3, 3], [2, -1, 0, -1, 2, -1, 0, -1, 2])
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

      m = MDArray.typed_arange("float", 0, 16)
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

      m = MDArray.typed_arange("float", 16, 32)
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

=begin

Example of SVD decomposition with PColt.  Check if working!

A =2.0  0.0 8.0 6.0 0.0
   1.0 6.0 0.0 1.0 7.0
   5.0 0.0 7.0 4.0 0.0
   7.0 0.0 8.0 5.0 0.0 
   0.0 10.0 0.0 0.0 7.0

      u = MDMatrix.double([5, 5], [-0.542255, 0.0649957, 0.821617, 0.105747, -0.124490,\
                                   -0.101812, -0.593461, -0.112552, 0.788123, 0.0602700,\
                                   -0.524953, 0.0593817, -0.212969, -0.115742, 0.813724,\
                                   -0.644870, 0.0704063, -0.508744, -0.0599027, -0.562829,\
                                   -0.0644952, -0.796930, 0.0900097, -0.592195, -0.0441263])

      vt = MDMatrix.double([5, 5], [-0.464617, 0.0215065, -0.868509, 0.000799554, -0.171349,\
                                    -0.0700860, -0.759988, 0.0630715, -0.601346, -0.227841,\
                                    -0.735094, 0.0987971, 0.284009, -0.223485, 0.565040,\
                                    -0.484392, 0.0254474, 0.398866, 0.332684, -0.703523,\
                                    -0.0649698, -0.641520, -0.0442743, 0.691201, 0.323284])

S = 
(00)    17.91837085874625
(11)    15.17137188041607
(22)    3.5640020352605677
(33)    1.9842281528992616
(44)    0.3495556671751232

=end
