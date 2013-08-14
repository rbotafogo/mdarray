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

class Colt
  
  module Property
    include_package "cern.colt.matrix.tdouble.algo"
    include_package "cern.colt.matrix.tfloat.algo"
    include_package "cern.colt.matrix.tlong.algo"
    include_package "cern.colt.matrix.tint.algo"

    attr_reader :colt_property
    attr_reader :colt_matrix
    
    #------------------------------------------------------------------------------------
    # Checks whether the given matrix A is rectangular.
    #------------------------------------------------------------------------------------
    
    def check_rectangular
      begin
        @colt_property.checkRectangular(@colt_matrix)
      rescue java.lang.IllegalArgumentException
        raise "rows < columns.  Not rectangular matrix"
      end
    end
        
    #------------------------------------------------------------------------------------
    # Checks whether the given matrix A is square. 
    #------------------------------------------------------------------------------------
    
    def check_square
      begin
        @colt_property.checkSquare(@colt_matrix)
      rescue java.lang.IllegalArgumentException
        raise "rows != columns.  Not square matrix"
      end
    end

    #------------------------------------------------------------------------------------
    # Returns the matrix's fraction of non-zero cells; A.cardinality() / A.size().
    #------------------------------------------------------------------------------------

    def density
      @colt_property.density(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is diagonal if A[i,j] == 0 whenever i != j. Matrix may but need not be 
    # square.
    #------------------------------------------------------------------------------------

    def diagonal?
      @colt_property.diagonal(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is diagonally dominant by column if the absolute value of each diagonal 
    # element is larger than the sum of the absolute values of the off-diagonal elements 
    # in the corresponding column. returns true if for all i: abs(A[i,i]) > 
    # Sum(abs(A[j,i])); j != i. Matrix may but need not be square.
    #
    # Note: Ignores tolerance.
    #------------------------------------------------------------------------------------

    def diagonally_dominant_by_column?
      @colt_property.diagonallyDominantByColumn(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is diagonally dominant by row if the absolute value of each diagonal 
    # element is larger than the sum of the absolute values of the off-diagonal elements in 
    # the corresponding row. returns true if for all i: abs(A[i,i]) > Sum(abs(A[i,j])); 
    # j != i. Matrix may but need not be square.
    # 
    # Note: Ignores tolerance.
    #------------------------------------------------------------------------------------

    def diagonally_dominant_by_row?
      @colt_property.diagonallyDominantByRow(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # if val is a Numeric value: Returns whether all cells of the given matrix A are 
    # equal to the given value. 
    # if val is another matrix: Returns whether both given matrices A and B are equal.
    #------------------------------------------------------------------------------------

    def equals?(val)
      
      if (val.is_a? Numeric)
        @colt_property.equals(@colt_matrix, val)
      else
        @colt_property.equals(@colt_matrix, val.colt_matrix)
      end

    end

    #------------------------------------------------------------------------------------
    # Modifies the given matrix square matrix A such that it is diagonally dominant by 
    # row and column, hence non-singular, hence invertible.
    #------------------------------------------------------------------------------------

    def generate_non_singular
      @colt_property.generateNonSingular(@colt_matrix)
    end

    #-------------------------------------------------------------------------------------
    # A matrix A is an identity matrix if A[i,i] == 1 and all other cells are zero. Matrix 
    # may but need not be square.
    #-------------------------------------------------------------------------------------

    def identity?
      @colt_property.isIdentity(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is lower bidiagonal if A[i,j]==0 unless i==j || i==j+1.
    #------------------------------------------------------------------------------------

    def lower_bidiagonal?
      @colt_property.isLowerBidiagonal(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is lower triangular if A[i,j]==0 whenever i < j.
    #------------------------------------------------------------------------------------

    def lower_triangular?
      @colt_property.isLowerTriangular(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is non-negative if A[i,j] >= 0 holds for all cells.
    #------------------------------------------------------------------------------------

    def non_negative?
      @colt_property.isNonNegative(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A square matrix A is orthogonal if A*transpose(A) = I.
    #------------------------------------------------------------------------------------

    def orthogonal?
      @colt_property.isOrthogonal(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is positive if A[i,j] > 0 holds for all cells.
    #------------------------------------------------------------------------------------

    def positive?
      @colt_property.isPositive(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is singular if it has no inverse, that is, iff det(A)==0.
    #------------------------------------------------------------------------------------

    def singular?
      @colt_property.isSingular(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A square matrix A is skew-symmetric if A = -transpose(A), that is A[i,j] == -A[j,i].
    #------------------------------------------------------------------------------------

    def skew_symmetric?
      @colt_property.isSkewSymmetric(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # 
    #------------------------------------------------------------------------------------

    def square?
      @colt_property.isSquare(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is strictly lower triangular if A[i,j]==0 whenever i <= j.
    #------------------------------------------------------------------------------------
    
    def strictly_lower_triangular?
      @colt_property.isStrictlyLowerTriangular(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is strictly triangular if it is triangular and its diagonal elements all 
    # equal 0
    #------------------------------------------------------------------------------------

    def stricly_triangular?
      @colt_property.isStrictlyTriangular(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is strictly upper triangular if A[i,j]==0 whenever i >= j.
    #------------------------------------------------------------------------------------

    def strictly_upper_triangular?
      @colt_property.isStrictlyUpperTriangular(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is symmetric if A = tranpose(A), that is A[i,j] == A[j,i].
    #------------------------------------------------------------------------------------

    def symmetric?
      @colt_property.isSymmetric(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is triangular iff it is either upper or lower triangular.
    #------------------------------------------------------------------------------------
    
    def triangular?
      @colt_property.isTriangular(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is tridiagonal if A[i,j]==0 whenever Math.abs(i-j) > 1.
    #------------------------------------------------------------------------------------

    def tridiagonal?
      @colt_property.isTridiagonal(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is unit triangular if it is triangular and its diagonal elements all 
    # equal 1.
    #------------------------------------------------------------------------------------

    def unit_triangular?
      @colt_property.isUnitTriangular(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is upper bidiagonal if A[i,j]==0 unless i==j || i==j-1.
    #------------------------------------------------------------------------------------

    def upper_bidiagonal?
      @colt_property.isUpperBidiagonal(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is upper triangular if A[i,j]==0 whenever i > j.
    #------------------------------------------------------------------------------------

    def upper_triangular?
      @colt_property.isUpperTriangular(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # A matrix A is zero if all its cells are zero.
    #------------------------------------------------------------------------------------

    def zero?
      @colt_property.isZero(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # The lower bandwidth of a square matrix A is the maximum i-j for which A[i,j] is 
    # nonzero and i > j.
    #------------------------------------------------------------------------------------

    def lower_bandwith
      @colt_property.lowerBandwith(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # Returns the semi-bandwidth of the given square matrix A.
    #------------------------------------------------------------------------------------

    def semi_bandwith
      @colt_property.semiBandwith(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # Returns the current tolerance.
    #------------------------------------------------------------------------------------

    def tolerance
      @colt_property.tolerance()
    end

    #------------------------------------------------------------------------------------
    # Sets the tolerance to Math.abs(val).
    #------------------------------------------------------------------------------------

    def tolerance=(val)
      @colt_property.setTolerance(val)
    end

    #------------------------------------------------------------------------------------
    # Returns summary information about the given matrix A.
    #------------------------------------------------------------------------------------

    def to_string
      @colt_property.toString(@colt_matrix)
    end

    #------------------------------------------------------------------------------------
    # The upper bandwidth of a square matrix A is the maximum j-i for which A[i,j] is 
    # nonzero and j > i.
    #------------------------------------------------------------------------------------

    def upper_bandwith
      @colt_property.upperBandwith(@colt_matrix)
    end

  end
  
end # Colt

##########################################################################################
#
##########################################################################################

class MDMatrix

  include Colt::Property

end
