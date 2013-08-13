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

      d1 = MDArray.typed_arange("double", 0, 90)
      d1.reshape!([5, 3, 6])

      # take a slice of d1 on the first dimension (0) and taking only the first (0) index.
      d2 = d1.slice(0, 0)
      @m1 = MDMatrix.from_mdarray(d2)

      d2 = d1.slice(0, 1)
      @m2 = MDMatrix.from_mdarray(d2)

      d2 = d1.slice(1, 1)
      @m3 = MDMatrix.from_mdarray(d2)

      @rect = MDMatrix.from_mdarray(d1.reshape([5, 3, 6])
                                      .region(:spec => "0:4, 0:2, 0:0", :reduce => true))
      @square = MDMatrix.from_mdarray(d1.reshape([5, 3, 6])
                                        .region(:spec => "0:2, 0:2, 0:0", :reduce => true))

      # identity matrix
      @identity = MDMatrix
        .from_mdarray(MDArray.fromfunction("double", [5, 5]) { |x, y| 1 if x == y })

      # diagonaly dominant matrix by row and column
      @diag_dominant = MDMatrix
        .from_mdarray(MDArray.fromfunction("double", [4, 4]) do |x, y|
                        if (x == y)
                          5 * (x +1) + 5 * (y + 1)
                        else
                          x + y 
                        end
                      end)

      # upper diagonal matrix
      @ud = MDMatrix
        .from_mdarray(MDArray.fromfunction("double", [4, 4]) { |x, y|
                        x + y if x < y })

      # lower diagonal matrix
      @ld = MDMatrix
        .from_mdarray(MDArray.fromfunction("double", [4, 4]) { |x, y|
                        x + y if x < y })
      @c2 = MDMatrix.from_mdarray(MDArray.double([2, 2], [2, 2, 2, 2]))

      # zero matrix
      @zero = MDMatrix.from_mdarray(MDArray.double([3, 3]))

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "test matrices properties" do

      # Checks whether the given matrix A is rectangular, i.e., if columns >= rows.  
      # If not rectangular raise exception, otherwise, does nothing.
      assert_raise ( RuntimeError ) { @m1.check_rectangular }
      @rect.check_rectangular
      
      # Checks that the matrix is a square matrix.  If not, raises an exception
      assert_raise ( RuntimeError ) { @rect.check_square }
      @square.check_square

      # Returns the matrix's fraction of non-zero cells; A.cardinality() / A.size().
      assert_equal(0.8888888888888888, @square.density)

      # array @square is not diagnonal
      assert_equal(false, @square.diagonal?)

      #------------------------------------------------------------------------------------
      # A matrix A is diagonally dominant by column if the absolute value of each diagonal 
      # element is larger than the sum of the absolute values of the off-diagonal elements 
      # in the corresponding column. returns true if for all i: abs(A[i,i]) > 
      # Sum(abs(A[j,i])); j != i. Matrix may but need not be square.
      #
      # Note: Ignores tolerance.
      #------------------------------------------------------------------------------------
      assert_equal(true, @diag_dominant.diagonally_dominant_by_column?)
      assert_equal(false, @square.diagonally_dominant_by_column?)

      #------------------------------------------------------------------------------------
      # A matrix A is diagonally dominant by row if the absolute value of each diagonal 
      # element is larger than the sum of the absolute values of the off-diagonal elements in 
      # the corresponding row. returns true if for all i: abs(A[i,i]) > Sum(abs(A[i,j])); 
      # j != i. Matrix may but need not be square.
      # 
      # Note: Ignores tolerance.
      #------------------------------------------------------------------------------------
      assert_equal(true, @diag_dominant.diagonally_dominant_by_row?)

      non_sing = @square.copy
      # modifies the matrix to a non-singular matrix
      non_sing.generate_non_singular

      assert_equal(true, @c2.equals?(2))
      assert_equal(true, @identity.equals?(@identity))
      assert_equal(false, @c2.equals?(@identity))
      assert_equal(true, @identity.identity?)
      assert_equal(true, @zero.lower_bidiagonal?)

    end

  end

end
