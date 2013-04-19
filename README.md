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


* MDArray Properties
  + Easy calculation for large numerical multi dimensional arrays;
  + Basic types are: boolean, byte, short, int, long, float, double, string, structure;
  + Based on JRuby, which allows importing Java libraries.  Version 0.4.0 only imports Java-NetCDF;
  + Operator: +,-,*,/,%,**, >, >=, etc.
  + Functions: abs, ceil, floor, truncate, is_zero, square, cube, fourth;
  + Binary Operators: &, |, ^, ~ (binary_ones_complement), <<, >>;
  + Ruby Math functions: acos, acosh, asin, asinh, atan, atan2, atanh, cbrt, cos, erf, exp, gamma, 
      hypot, ldexp, log, log10, log2, sin, sinh, sqrt, tan, tanh, neg;
  + Boolean operations on boolean arrays: and, or, not;
  + Simple statistics: sum, min, max, mean, weighted_mean;
  + Easy manipulation of arrays: reshape, reduce dimension, permute, section, slice, etc.


MDArray wiki can be found at: https://github.com/rbotafogo/mdarray/wiki

HISTORY
=======

19/04/2013: Version 0.4.3: Fixes a simple (but fatal bug).  No new features
17/04/2013: Version 0.4.2: Adds simple statistics and boolean operators
