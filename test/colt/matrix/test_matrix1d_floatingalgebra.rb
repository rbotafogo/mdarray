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

    should "test 1d double matrix functions" do

      b = MDMatrix.double([3], [1.5, 1, 1.3])

      pos = MDArray.double([9], [2, -1, 0, -1, 2, -1, 0, -1, 2])
      matrix1 = MDMatrix.from_mdarray(pos)

      p "getting regions from the above matrix"
      p "specification is '0:6'"
      matrix1.region(:spec => "0:6").print
      printf("\n\n")

      p "specification is '0:9:2'"
      matrix1.region(:spec => "0:9:2").print
      printf("\n\n")

      p "flipping dim 0 of the matrix"
      matrix1.flip(0).print
      printf("\n\n")

      m = MDArray.typed_arange("double", 16, 32)
      matrix2 = MDMatrix.from_mdarray(m).region(:spec => "0:9")
      matrix2.print
      printf("\n\n")
      
      p "matrix multiplication - dot product of two vectors"
      result = matrix1 * matrix2
      p result
      printf("\n\n")

      result = matrix1.kron(matrix2)
      p "Kronecker multiplication"
      result.print
      printf("\n\n")

      p "norm1"
      p result.norm1

      p "norm2"
      p result.norm2

      p "Returns the Frobenius norm of matrix A, which is Sqrt(Sum(A[i,j]^2))"
      p result.normF

      p "Returns the infinity norm of matrix A, which is the maximum absolute row sum."
      p result.norm_infinity

      result.normalize!
      result.print
      printf("\n\n")

      p "summing all values of result: #{result.sum}"

      result.mdarray.print

      # val1 is not a matrix2d... wrong test file.  Need to actually work with division on 
      # Matrix2D.
      p "dividing two matrices... actually multiply by the inverse"
      val1 = MDMatrix.double([2], [118.4, 135.2])
      val2 = MDMatrix.double([2, 2], [3, 3.5, 3.2, 3.6])
      val1.print
      printf("\n\n")
      val2.print
      printf("\n\n")

      div = val1 / val2
      p "result of division"
      div.print
      printf("\n\n")

      p "multiply by the inverse"
      r1 = val2.inverse
      r1.print
      printf("\n\n")

      val1.print
      printf("\n\n")

      mult = r1 * val1
      mult.print
      printf("\n\n")

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "test 1D float matrix functions" do

      b = MDMatrix.float([3], [1.5, 1, 1.3])

      pos = MDArray.float([9], [2, -1, 0, -1, 2, -1, 0, -1, 2])
      matrix1 = MDMatrix.from_mdarray(pos)

      p "getting regions from the above matrix"
      p "specification is '0:6'"
      matrix1.region(:spec => "0:6").print
      printf("\n\n")

      p "specification is '0:9:2'"
      matrix1.region(:spec => "0:9:2").print
      printf("\n\n")

      p "flipping dim 0 of the matrix"
      matrix1.flip(0).print
      printf("\n\n")

      m = MDArray.typed_arange("float", 16, 32)
      matrix2 = MDMatrix.from_mdarray(m).region(:spec => "0:9")
      matrix2.print
      printf("\n\n")
      
      p "matrix multiplication - dot product of two vectors"
      result = matrix1 * matrix2
      p result
      printf("\n\n")

      result = matrix1.kron(matrix2)
      p "Kronecker multiplication"
      result.print
      printf("\n\n")

      p "norm1"
      p result.norm1

      p "norm2"
      p result.norm2

      p "Returns the Frobenius norm of matrix A, which is Sqrt(Sum(A[i,j]^2))"
      p result.normF

      p "Returns the infinity norm of matrix A, which is the maximum absolute row sum."
      p result.norm_infinity

      result.normalize!
      result.print
      printf("\n\n")

      p "summing all values of result: #{result.sum}"

      result.mdarray.print

    end

  end

end
