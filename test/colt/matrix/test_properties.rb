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

    should "test double matrices properties" do

      d1 = MDArray.typed_arange("double", 0, 90)
      d1.reshape!([5, 3, 6])

      # take a slice of d1 on the first dimension (0) and taking only the first (0) index.
      d2 = d1.slice(0, 0)
      m1 = MDMatrix.from_mdarray(d2)

      d2 = d1.slice(0, 1)
      m2 = MDMatrix.from_mdarray(d2)

      d2 = d1.slice(1, 1)
      m3 = MDMatrix.from_mdarray(d2)

      rect = MDMatrix.from_mdarray(d1.reshape([5, 3, 6])
                                      .region(:spec => "0:4, 0:2, 0:0", :reduce => true))
      square = MDMatrix.from_mdarray(d1.reshape([5, 3, 6])
                                        .region(:spec => "0:2, 0:2, 0:0", :reduce => true))

      # identity matrix
      identity = MDMatrix.fromfunction("double", [5, 5]) { |i, j| 1 if i == j }

      # diagonaly dominant matrix by row and column
      diag_dominant = MDMatrix.fromfunction("double", [4, 4]) do |x, y|
        (x == y)? 5 * (x +1) + 5 * (y + 1) : x + y 
      end

      # upper diagonal matrix
      ud = MDMatrix.fromfunction("double", [4, 4]) { |x, y| x + y if x < y }

      # lower diagonal matrix
      ld = MDMatrix.fromfunction("double", [4, 4]) { |x, y| x + y if x > y }

      c2 = MDMatrix.double([2, 2], [2, 2, 2, 2])

      # zero matrix
      zero = MDMatrix.double([3, 3])

      # Checks whether the given matrix A is rectangular, i.e., if columns >= rows.  
      # If not rectangular raise exception, otherwise, does nothing.
      assert_raise ( RuntimeError ) { m1.check_rectangular }
      rect.check_rectangular
      
      # Checks that the matrix is a square matrix.  If not, raises an exception
      assert_raise ( RuntimeError ) { rect.check_square }
      square.check_square

      # Returns the matrix's fraction of non-zero cells; A.cardinality() / A.size().
      assert_equal(0.8888888888888888, square.density)

      # array square is not diagnonal
      assert_equal(false, square.diagonal?)

      #------------------------------------------------------------------------------------
      # A matrix A is diagonally dominant by column if the absolute value of each diagonal 
      # element is larger than the sum of the absolute values of the off-diagonal elements 
      # in the corresponding column. returns true if for all i: abs(A[i,i]) > 
      # Sum(abs(A[j,i])); j != i. Matrix may but need not be square.
      #
      # Note: Ignores tolerance.
      #------------------------------------------------------------------------------------
      assert_equal(true, diag_dominant.diagonally_dominant_by_column?)
      assert_equal(false, square.diagonally_dominant_by_column?)

      #------------------------------------------------------------------------------------
      # A matrix A is diagonally dominant by row if the absolute value of each diagonal 
      # element is larger than the sum of the absolute values of the off-diagonal elements in 
      # the corresponding row. returns true if for all i: abs(A[i,i]) > Sum(abs(A[i,j])); 
      # j != i. Matrix may but need not be square.
      # 
      # Note: Ignores tolerance.
      #------------------------------------------------------------------------------------
      assert_equal(true, diag_dominant.diagonally_dominant_by_row?)

      non_sing = square.copy
      # modifies the matrix to a non-singular matrix
      non_sing.generate_non_singular

      assert_equal(true, c2.equals?(2))
      assert_equal(true, identity.equals?(identity))
      assert_equal(false, c2.equals?(identity))
      assert_equal(true, identity.identity?)
      assert_equal(true, zero.lower_bidiagonal?)
      assert_equal(true, ld.lower_triangular?)
      assert_equal(true, c2.non_negative?)
      assert_equal(false, c2.orthogonal?)
      assert_equal(true, identity.orthogonal?)
      assert_equal(true, c2.positive?)
      assert_equal(true, c2.singular?)
      assert_equal(false, non_sing.singular?)

      # making a skew symmetric matrix by building the upper part and the lower part and
      # adding them together
      l = MDArray.fromfunction("double", [5, 5]) do |x, y|
        x + y if x > y
      end
      lt = MDMatrix.from_mdarray(l)

      u = MDArray.fromfunction("double", [5, 5]) do |x, y|
        -(x + y) if x < y
      end
      ut = MDMatrix.from_mdarray(u)
      ss = MDMatrix.from_mdarray(u + l)

      assert_equal(true, ss.skew_symmetric?)
      assert_equal(true, square.square?)
      assert_equal(false, rect.square?)
      assert_equal(true, lt.strictly_lower_triangular?)
      assert_equal(false, ut.strictly_lower_triangular?)
      assert_equal(true, lt.strictly_triangular?)
      assert_equal(true, ut.strictly_triangular?)
      assert_equal(true, ut.strictly_upper_triangular?)
      assert_equal(true, c2.symmetric?)
      assert_equal(true, ut.triangular?)

      tri = MDArray.fromfunction("double", [5, 6]) do |i, j|
        ((i - j).abs > 1)? 0 : i + j
      end
      assert_equal(true, MDMatrix.from_mdarray(tri).tridiagonal?)

      unittri = MDArray.fromfunction("double", [5, 6]) do |i, j|
        (i > j)? i + j : ((i == j)? 1 : 0)
      end
      assert_equal(true, MDMatrix.from_mdarray(unittri).unit_triangular?)

      upbi = MDArray.fromfunction("double", [5, 6]) do |i, j|
        ((i == j) || (i == j-1))? i + j : 0
      end
      assert_equal(true, MDMatrix.from_mdarray(upbi).upper_bidiagonal?)

      assert_equal(true, ut.upper_triangular?)
      assert_equal(true, zero.zero?)
      assert_equal(3, diag_dominant.lower_bandwidth)
      assert_equal(4, diag_dominant.semi_bandwidth)
      assert_equal(3, diag_dominant.upper_bandwidth)

      diag_dominant.properties

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "test float matrices properties" do

      d1 = MDArray.typed_arange("float", 0, 90)
      d1.reshape!([5, 3, 6])

      # take a slice of d1 on the first dimension (0) and taking only the first (0) index.
      d2 = d1.slice(0, 0)
      m1 = MDMatrix.from_mdarray(d2)

      d2 = d1.slice(0, 1)
      m2 = MDMatrix.from_mdarray(d2)

      d2 = d1.slice(1, 1)
      m3 = MDMatrix.from_mdarray(d2)

      rect = MDMatrix.from_mdarray(d1.reshape([5, 3, 6])
                                      .region(:spec => "0:4, 0:2, 0:0", :reduce => true))
      square = MDMatrix.from_mdarray(d1.reshape([5, 3, 6])
                                        .region(:spec => "0:2, 0:2, 0:0", :reduce => true))

      # identity matrix
      identity = MDMatrix
        .from_mdarray(MDArray.fromfunction("float", [5, 5]) { |x, y| 1 if x == y })

      # diagonaly dominant matrix by row and column
      diag_dominant = MDMatrix
        .from_mdarray(MDArray.fromfunction("float", [4, 4]) do |x, y|
                        if (x == y)
                          5 * (x +1) + 5 * (y + 1)
                        else
                          x + y 
                        end
                      end)

      # upper diagonal matrix
      ud = MDMatrix
        .from_mdarray(MDArray.fromfunction("float", [4, 4]) { |x, y|
                        x + y if x < y })

      # lower diagonal matrix
      ld = MDMatrix
        .from_mdarray(MDArray.fromfunction("float", [4, 4]) { |x, y|
                        x + y if x > y })

      c2 = MDMatrix.from_mdarray(MDArray.float([2, 2], [2, 2, 2, 2]))

      # zero matrix
      zero = MDMatrix.from_mdarray(MDArray.float([3, 3]))

      # Checks whether the given matrix A is rectangular, i.e., if columns >= rows.  
      # If not rectangular raise exception, otherwise, does nothing.
      assert_raise ( RuntimeError ) { m1.check_rectangular }
      rect.check_rectangular
      
      # Checks that the matrix is a square matrix.  If not, raises an exception
      assert_raise ( RuntimeError ) { rect.check_square }
      square.check_square

      # Returns the matrix's fraction of non-zero cells; A.cardinality() / A.size().
      assert_equal(0.8888888955116272, square.density)

      # array square is not diagnonal
      assert_equal(false, square.diagonal?)

      #------------------------------------------------------------------------------------
      # A matrix A is diagonally dominant by column if the absolute value of each diagonal 
      # element is larger than the sum of the absolute values of the off-diagonal elements 
      # in the corresponding column. returns true if for all i: abs(A[i,i]) > 
      # Sum(abs(A[j,i])); j != i. Matrix may but need not be square.
      #
      # Note: Ignores tolerance.
      #------------------------------------------------------------------------------------
      assert_equal(true, diag_dominant.diagonally_dominant_by_column?)
      assert_equal(false, square.diagonally_dominant_by_column?)

      #------------------------------------------------------------------------------------
      # A matrix A is diagonally dominant by row if the absolute value of each diagonal 
      # element is larger than the sum of the absolute values of the off-diagonal elements in 
      # the corresponding row. returns true if for all i: abs(A[i,i]) > Sum(abs(A[i,j])); 
      # j != i. Matrix may but need not be square.
      # 
      # Note: Ignores tolerance.
      #------------------------------------------------------------------------------------
      assert_equal(true, diag_dominant.diagonally_dominant_by_row?)

      non_sing = square.copy
      # modifies the matrix to a non-singular matrix
      non_sing.generate_non_singular

      assert_equal(true, c2.equals?(2))
      assert_equal(true, identity.equals?(identity))
      assert_equal(false, c2.equals?(identity))
      assert_equal(true, identity.identity?)
      assert_equal(true, zero.lower_bidiagonal?)
      assert_equal(true, ld.lower_triangular?)
      assert_equal(true, c2.non_negative?)
      assert_equal(false, c2.orthogonal?)
      assert_equal(true, identity.orthogonal?)
      assert_equal(true, c2.positive?)
      assert_equal(true, c2.singular?)
      assert_equal(false, non_sing.singular?)

      # making a skew symmetric matrix by building the upper part and the lower part and
      # adding them together
      l = MDArray.fromfunction("float", [5, 5]) do |x, y|
        x + y if x > y
      end
      lt = MDMatrix.from_mdarray(l)

      u = MDArray.fromfunction("float", [5, 5]) do |x, y|
        -(x + y) if x < y
      end
      ut = MDMatrix.from_mdarray(u)
      ss = MDMatrix.from_mdarray(u + l)

      assert_equal(true, ss.skew_symmetric?)
      assert_equal(true, square.square?)
      assert_equal(false, rect.square?)
      assert_equal(true, lt.strictly_lower_triangular?)
      assert_equal(false, ut.strictly_lower_triangular?)
      assert_equal(true, lt.strictly_triangular?)
      assert_equal(true, ut.strictly_triangular?)
      assert_equal(true, ut.strictly_upper_triangular?)
      assert_equal(true, c2.symmetric?)
      assert_equal(true, ut.triangular?)

      tri = MDArray.fromfunction("float", [5, 6]) do |i, j|
        ((i - j).abs > 1)? 0 : i + j
      end
      assert_equal(true, MDMatrix.from_mdarray(tri).tridiagonal?)

      unittri = MDArray.fromfunction("float", [5, 6]) do |i, j|
        (i > j)? i + j : ((i == j)? 1 : 0)
      end
      assert_equal(true, MDMatrix.from_mdarray(unittri).unit_triangular?)

      upbi = MDArray.fromfunction("float", [5, 6]) do |i, j|
        ((i == j) || (i == j-1))? i + j : 0
      end
      assert_equal(true, MDMatrix.from_mdarray(upbi).upper_bidiagonal?)

      assert_equal(true, ut.upper_triangular?)
      assert_equal(true, zero.zero?)
      assert_equal(3, diag_dominant.lower_bandwidth)
      assert_equal(4, diag_dominant.semi_bandwidth)
      assert_equal(3, diag_dominant.upper_bandwidth)

      diag_dominant.properties

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "test long matrices properties" do

      d1 = MDArray.typed_arange("long", 0, 90)
      d1.reshape!([5, 3, 6])

      # take a slice of d1 on the first dimension (0) and taking only the first (0) index.
      d2 = d1.slice(0, 0)
      m1 = MDMatrix.from_mdarray(d2)

      d2 = d1.slice(0, 1)
      m2 = MDMatrix.from_mdarray(d2)

      d2 = d1.slice(1, 1)
      m3 = MDMatrix.from_mdarray(d2)

      rect = MDMatrix.from_mdarray(d1.reshape([5, 3, 6])
                                      .region(:spec => "0:4, 0:2, 0:0", :reduce => true))
      square = MDMatrix.from_mdarray(d1.reshape([5, 3, 6])
                                        .region(:spec => "0:2, 0:2, 0:0", :reduce => true))

      # identity matrix
      identity = MDMatrix
        .from_mdarray(MDArray.fromfunction("long", [5, 5]) { |x, y| 1 if x == y })

      # diagonaly dominant matrix by row and column
      diag_dominant = MDMatrix
        .from_mdarray(MDArray.fromfunction("long", [4, 4]) do |x, y|
                        if (x == y)
                          5 * (x +1) + 5 * (y + 1)
                        else
                          x + y 
                        end
                      end)

      # upper diagonal matrix
      ud = MDMatrix
        .from_mdarray(MDArray.fromfunction("long", [4, 4]) { |x, y|
                        x + y if x < y })

      # lower diagonal matrix
      ld = MDMatrix
        .from_mdarray(MDArray.fromfunction("long", [4, 4]) { |x, y|
                        x + y if x > y })

      c2 = MDMatrix.from_mdarray(MDArray.long([2, 2], [2, 2, 2, 2]))

      # zero matrix
      zero = MDMatrix.from_mdarray(MDArray.long([3, 3]))

      # Checks whether the given matrix A is rectangular, i.e., if columns >= rows.  
      # If not rectangular raise exception, otherwise, does nothing.
      assert_raise ( RuntimeError ) { m1.check_rectangular }
      rect.check_rectangular
      
      # Checks that the matrix is a square matrix.  If not, raises an exception
      assert_raise ( RuntimeError ) { rect.check_square }
      square.check_square

      # Returns the matrix's fraction of non-zero cells; A.cardinality() / A.size().
      assert_equal(0, square.density)

      # array square is not diagnonal
      assert_equal(false, square.diagonal?)

      #------------------------------------------------------------------------------------
      # A matrix A is diagonally dominant by column if the absolute value of each diagonal 
      # element is larger than the sum of the absolute values of the off-diagonal elements 
      # in the corresponding column. returns true if for all i: abs(A[i,i]) > 
      # Sum(abs(A[j,i])); j != i. Matrix may but need not be square.
      #
      # Note: Ignores tolerance.
      #------------------------------------------------------------------------------------
      assert_equal(true, diag_dominant.diagonally_dominant_by_column?)
      assert_equal(false, square.diagonally_dominant_by_column?)

      #------------------------------------------------------------------------------------
      # A matrix A is diagonally dominant by row if the absolute value of each diagonal 
      # element is larger than the sum of the absolute values of the off-diagonal elements in 
      # the corresponding row. returns true if for all i: abs(A[i,i]) > Sum(abs(A[i,j])); 
      # j != i. Matrix may but need not be square.
      # 
      # Note: Ignores tolerance.
      #------------------------------------------------------------------------------------
      assert_equal(true, diag_dominant.diagonally_dominant_by_row?)

      non_sing = square.copy
      # modifies the matrix to a non-singular matrix
      non_sing.generate_non_singular

      assert_equal(true, c2.equals?(2))
      assert_equal(true, identity.equals?(identity))
      assert_equal(false, c2.equals?(identity))
      assert_equal(true, identity.identity?)
      assert_equal(true, zero.lower_bidiagonal?)
      assert_equal(true, ld.lower_triangular?)
      assert_equal(true, c2.non_negative?)
      assert_equal(false, c2.orthogonal?)
      assert_equal(true, identity.orthogonal?)
      assert_equal(true, c2.positive?)

      assert_raise( RuntimeError ) { c2.singular?}
      assert_raise( RuntimeError ) { non_sing.singular? }

      # making a skew symmetric matrix by building the upper part and the lower part and
      # adding them together
      l = MDArray.fromfunction("long", [5, 5]) do |x, y|
        x + y if x > y
      end
      lt = MDMatrix.from_mdarray(l)

      u = MDArray.fromfunction("long", [5, 5]) do |x, y|
        -(x + y) if x < y
      end
      ut = MDMatrix.from_mdarray(u)
      ss = MDMatrix.from_mdarray(u + l)

      assert_equal(true, ss.skew_symmetric?)
      assert_equal(true, square.square?)
      assert_equal(false, rect.square?)
      assert_equal(true, lt.strictly_lower_triangular?)
      assert_equal(false, ut.strictly_lower_triangular?)
      assert_equal(true, lt.strictly_triangular?)
      assert_equal(true, ut.strictly_triangular?)
      assert_equal(true, ut.strictly_upper_triangular?)
      assert_equal(true, c2.symmetric?)
      assert_equal(true, ut.triangular?)

      tri = MDArray.fromfunction("long", [5, 6]) do |i, j|
        ((i - j).abs > 1)? 0 : i + j
      end
      assert_equal(true, MDMatrix.from_mdarray(tri).tridiagonal?)

      unittri = MDArray.fromfunction("long", [5, 6]) do |i, j|
        (i > j)? i + j : ((i == j)? 1 : 0)
      end
      assert_equal(true, MDMatrix.from_mdarray(unittri).unit_triangular?)

      upbi = MDArray.fromfunction("long", [5, 6]) do |i, j|
        ((i == j) || (i == j-1))? i + j : 0
      end
      assert_equal(true, MDMatrix.from_mdarray(upbi).upper_bidiagonal?)

      assert_equal(true, ut.upper_triangular?)
      assert_equal(true, zero.zero?)
      assert_equal(3, diag_dominant.lower_bandwidth)
      assert_equal(4, diag_dominant.semi_bandwidth)
      assert_equal(3, diag_dominant.upper_bandwidth)

      diag_dominant.properties

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "test int matrices properties" do

      d1 = MDArray.typed_arange("int", 0, 90)
      d1.reshape!([5, 3, 6])

      # take a slice of d1 on the first dimension (0) and taking only the first (0) index.
      d2 = d1.slice(0, 0)
      m1 = MDMatrix.from_mdarray(d2)

      d2 = d1.slice(0, 1)
      m2 = MDMatrix.from_mdarray(d2)

      d2 = d1.slice(1, 1)
      m3 = MDMatrix.from_mdarray(d2)

      rect = MDMatrix.from_mdarray(d1.reshape([5, 3, 6])
                                      .region(:spec => "0:4, 0:2, 0:0", :reduce => true))
      square = MDMatrix.from_mdarray(d1.reshape([5, 3, 6])
                                        .region(:spec => "0:2, 0:2, 0:0", :reduce => true))

      # identity matrix
      identity = MDMatrix
        .from_mdarray(MDArray.fromfunction("int", [5, 5]) { |x, y| 1 if x == y })

      # diagonaly dominant matrix by row and column
      diag_dominant = MDMatrix
        .from_mdarray(MDArray.fromfunction("int", [4, 4]) do |x, y|
                        if (x == y)
                          5 * (x +1) + 5 * (y + 1)
                        else
                          x + y 
                        end
                      end)

      # upper diagonal matrix
      ud = MDMatrix
        .from_mdarray(MDArray.fromfunction("int", [4, 4]) { |x, y|
                        x + y if x < y })

      # lower diagonal matrix
      ld = MDMatrix
        .from_mdarray(MDArray.fromfunction("int", [4, 4]) { |x, y|
                        x + y if x > y })

      c2 = MDMatrix.from_mdarray(MDArray.int([2, 2], [2, 2, 2, 2]))

      # zero matrix
      zero = MDMatrix.from_mdarray(MDArray.int([3, 3]))

      # Checks whether the given matrix A is rectangular, i.e., if columns >= rows.  
      # If not rectangular raise exception, otherwise, does nothing.
      assert_raise ( RuntimeError ) { m1.check_rectangular }
      rect.check_rectangular
      
      # Checks that the matrix is a square matrix.  If not, raises an exception
      assert_raise ( RuntimeError ) { rect.check_square }
      square.check_square

      # Returns the matrix's fraction of non-zero cells; A.cardinality() / A.size().
      assert_equal(0, square.density)

      # array square is not diagnonal
      assert_equal(false, square.diagonal?)

      #------------------------------------------------------------------------------------
      # A matrix A is diagonally dominant by column if the absolute value of each diagonal 
      # element is larger than the sum of the absolute values of the off-diagonal elements 
      # in the corresponding column. returns true if for all i: abs(A[i,i]) > 
      # Sum(abs(A[j,i])); j != i. Matrix may but need not be square.
      #
      # Note: Ignores tolerance.
      #------------------------------------------------------------------------------------
      assert_equal(true, diag_dominant.diagonally_dominant_by_column?)
      assert_equal(false, square.diagonally_dominant_by_column?)

      #------------------------------------------------------------------------------------
      # A matrix A is diagonally dominant by row if the absolute value of each diagonal 
      # element is larger than the sum of the absolute values of the off-diagonal elements in 
      # the corresponding row. returns true if for all i: abs(A[i,i]) > Sum(abs(A[i,j])); 
      # j != i. Matrix may but need not be square.
      # 
      # Note: Ignores tolerance.
      #------------------------------------------------------------------------------------
      assert_equal(true, diag_dominant.diagonally_dominant_by_row?)

      non_sing = square.copy
      # modifies the matrix to a non-singular matrix
      non_sing.generate_non_singular

      assert_equal(true, c2.equals?(2))
      assert_equal(true, identity.equals?(identity))
      assert_equal(false, c2.equals?(identity))
      assert_equal(true, identity.identity?)
      assert_equal(true, zero.lower_bidiagonal?)
      assert_equal(true, ld.lower_triangular?)
      assert_equal(true, c2.non_negative?)
      assert_equal(false, c2.orthogonal?)
      assert_equal(true, identity.orthogonal?)
      assert_equal(true, c2.positive?)
      assert_raise ( RuntimeError ) { c2.singular? }
      assert_raise ( RuntimeError ) { non_sing.singular? }

      # making a skew symmetric matrix by building the upper part and the lower part and
      # adding them together
      l = MDArray.fromfunction("int", [5, 5]) do |x, y|
        x + y if x > y
      end
      lt = MDMatrix.from_mdarray(l)

      u = MDArray.fromfunction("int", [5, 5]) do |x, y|
        -(x + y) if x < y
      end
      ut = MDMatrix.from_mdarray(u)
      ss = MDMatrix.from_mdarray(u + l)

      assert_equal(true, ss.skew_symmetric?)
      assert_equal(true, square.square?)
      assert_equal(false, rect.square?)
      assert_equal(true, lt.strictly_lower_triangular?)
      assert_equal(false, ut.strictly_lower_triangular?)
      assert_equal(true, lt.strictly_triangular?)
      assert_equal(true, ut.strictly_triangular?)
      assert_equal(true, ut.strictly_upper_triangular?)
      assert_equal(true, c2.symmetric?)
      assert_equal(true, ut.triangular?)

      tri = MDArray.fromfunction("int", [5, 6]) do |i, j|
        ((i - j).abs > 1)? 0 : i + j
      end
      assert_equal(true, MDMatrix.from_mdarray(tri).tridiagonal?)

      unittri = MDArray.fromfunction("int", [5, 6]) do |i, j|
        (i > j)? i + j : ((i == j)? 1 : 0)
      end
      assert_equal(true, MDMatrix.from_mdarray(unittri).unit_triangular?)

      upbi = MDArray.fromfunction("int", [5, 6]) do |i, j|
        ((i == j) || (i == j-1))? i + j : 0
      end
      assert_equal(true, MDMatrix.from_mdarray(upbi).upper_bidiagonal?)

      assert_equal(true, ut.upper_triangular?)
      assert_equal(true, zero.zero?)
      assert_equal(3, diag_dominant.lower_bandwidth)
      assert_equal(4, diag_dominant.semi_bandwidth)
      assert_equal(3, diag_dominant.upper_bandwidth)

      diag_dominant.properties

    end

  end
  
end
