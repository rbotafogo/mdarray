MDArray
=======

MDArray is a multi dimensional array implemented for JRuby with similar functionalities 
(but still less) to numpy and narray by Masahiro Tanaka. MDArray targets specifically JRuby 
as it uses Java-NetCDF library from Unidata (http://www.unidata.ucar.edu).

Copying from numpy documentation but also valid for MDArray:

MDArray main object is the homogeneous multidimensional array. It is a table of elements 
(usually numbers), all of the same type, indexed by a tuple of positive integers. In 
MDArray dimensions are called axes. The number of axes is rank.

For example, the coordinates of a point in 3D space [1, 2, 1] is an array of rank 1, 
because it has one axis. That axis has a length of 3. In example pictured below, the array 
has rank 2 (it is 2-dimensional). The first dimension (axis) has a length of 2, the 
second dimension has a length of 3.

[[ 1., 0., 0.],
 [ 0., 1., 2.]]

