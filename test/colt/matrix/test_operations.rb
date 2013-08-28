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

    should "test multiple matrix operations" do

      # Dot product (or inner product of scalar product) of 2 vectors
      x = MDMatrix.double([3], [1, -2, 0.0])
      y = MDMatrix.double([3], [2, 5, -1.0])
      assert_equal(-8.0, x * y)

      # Matrix product.
      a = MDMatrix.double([3, 3], [3.2, -1, 2, 2, -2, 4, 1.5,-1,-4])
      b = MDMatrix.double([3, 2], [1.0, 2.0, -1.0, 2.0, 2, -1.5])
      product = a * b
      product.print
      printf("\n\n")

      # Matrix-vector product
      x = MDMatrix.double([3], [1, -2, 0.0])
      result = a * x
      result.print
      printf("\n\n")
      
      # transpose matrix
      a.transpose.print
      printf("\n\n")

      # trace
      assert_equal(-2.8, a.trace)

      # Determinant and inverse
      assert_equal(26.400000000000002, a.det)
      a.inverse.print
      printf("\n\n")

      # Eigenvalue and Eigenvectors
      eig = a.eig
      # eigenvalue matrix
      eig[0].print
      printf("\n\n")
      eig[1].print
      printf("\n\n")
      eig[2].print
      printf("\n\n")
      eig[3].print
      printf("\n\n")

    end

  end

end


=begin

Diagonal, transpose and trace

[Not yet a good way of working with the diagonal in MDMatrix]

>>> print sp.diagonal(A)   #returns the diagonal of A
array([ 3.2, -2., -4.]) 
>>> D = sp.diag((1, 2, 3))  # return a diagonal matrix
[[1 0 0]
 [0 2 0]
 [0 0 3]]

1.2 Eigenvalue and Eigenvectors

[Value from NunPy and MDMatrix are different... is this wrong?!]

>>> print e_vectors    # row i corresponds to the eigenvector
		       # associated with eigenvalues i
[[ 0.88158576+0.j, -0.25687900+0.02847007j, -0.25687900-0.02847007j]
 [ 0.45531661+0.j, -0.89064266+0.j, -0.89064266+0.j        ]
 [ 0.12447222+0.j,  0.32503863-0.18522464j, 0.32503863+0.18522464j]]

3 x 3 matrix
0,881586  1,37094 0,510170
0,455317  4,50194  2,26780
0,124472 -2,11460 0,108628


=end
