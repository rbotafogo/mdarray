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

if !(defined? $ENVIR)
  $ENVIR = true
  require_relative '../env.rb'
end

# MDArray main object is the homogeneous multidimensional array. It is a table
# of elements (usually numbers), all of the same type, indexed by a tuple of 
# positive integers.  In MDArray dimensions are called <axes>.  The number of
# <axes> is rank.
#
# For example, the coordinates of a point in 3D space [1, 2, 1] is an array of
# rank 1, because it has one <axis>.  That <axis> has a length of 3. In 
# the example pictured below, the array has rank 2 (it is 2-dimensional).  The
# first dimension (axis) has length of 2, the second dimension has length of 3
# [[1, 0, 0],
#  [0, 1, 2]]
# The more important attributes of a MDArray object are:
# * ndim: the number of axes (dimensions) of the array.  The number of dimensions
# is referred to as rank
# * shape: the dimensions of the array.  This is a tuple of integers indicating 
# the size of the array in each dimension.  For a matrix with n rows and m 
# columns, shape will be (n, m). The length of the shape tuple is therefore the
# rank, or number of dimensions, ndim
# * size: the total number of elements of the array. This is equal to the product
# of the elements of shape
# * dtype: an object describing the type of the elements in the array. One can
# create or specify dtype's using standard Ruby types. Additionally MDArray 
# provides types of its own. (examples?)
# * itemsize: ??
# Differently from NumPy, it is not possible to get the internal buffer

#=begin
require_relative 'test_creation'
require_relative 'test_non_numeric'
require_relative 'test_access'
require_relative 'test_operator'
require_relative 'arithmetic_casting'
require_relative 'test_comparison'
require_relative 'test_boolean'
require_relative 'test_shape'
require_relative 'test_counter'
require_relative 'test_trigonometry'
require_relative 'test_views'
require_relative 'test_printing'
require_relative 'test_lazy'
require_relative 'test_sections'
#require_relative 'test_performance'
#=end
