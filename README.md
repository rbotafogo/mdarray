MDArray
=======

MDArray is a multi dimensional array implemented for JRuby inspired by NumPy (www.numpy.org) 
and Narray (narray.rubyforge.org) by Masahiro Tanaka.  MDArray stands on the shoulders of 
Java-NetCDF and Parallel Colt.
 
NetCDF-Java Library is a Java interface to NetCDF files, as well as to many other types of 
scientific data formats.  It is developed and distributed by Unidata (http://www.unidata.ucar.edu). 

Parallel Colt (sites.google.com/site/piotrwendykier/software/parallelcolt) is a multithreaded 
version of Colt (http://acs.lbl.gov/software/colt/).  Colt provides a set of Open Source 
Libraries for High Performance Scientific and Technical Computing in Java. Scientific 
and technical computing is characterized by demanding problem sizes and a need for high 
performance at reasonably small memory footprint.

MDArray and SciRuby
===================

MDArray subscribes fully to the SciRuby Manifesto (http://sciruby.com/).  

Ruby has for some time had no equivalent to the beautifully constructed NumPy, SciPy, 
and matplotlib libraries for Python. 

We believe that the time for a Ruby science and visualization package has come. Sometimes 
when a solution of sugar and water becomes super-saturated, from it precipitates a pure, 
delicious, and diabetes-inducing crystal of sweetness, induced by no more than the tap 
of a finger. So is occurring now, we believe, with numeric and visualization libraries for Ruby.”

Main properties
===============

  + Homogeneous multidimensional array, a table of elements (usually numbers), all of the 
      same type, indexed by a tuple of positive integers;
  + Easy calculation for large numerical multi dimensional arrays;
  + Basic types are: boolean, byte, short, int, long, float, double, string, structure;
  + Based on JRuby, which allows importing Java libraries;
  + Operator: +,-,*,/,%,**, >, >=, etc.
  + Functions: abs, ceil, floor, truncate, is_zero, square, cube, fourth;
  + Binary Operators: &, |, ^, ~ (binary_ones_complement), <<, >>;
  + Ruby Math functions: acos, acosh, asin, asinh, atan, atan2, atanh, cbrt, cos, erf, exp, 
      gamma, hypot, ldexp, log, log10, log2, sin, sinh, sqrt, tan, tanh, neg;
  + Boolean operations on boolean arrays: and, or, not;
  + Fast descriptive statistics from Parallel Colt (complete list found bellow);
  + Easy manipulation of arrays: reshape, reduce dimension, permute, section, slice, etc.
  + Reading of two dimensional arrays from CSV files (mainly for debugging and simple 
      testing purposes);
  + StatList: a list that can grow/shrink and that can compute Parallel Colt descriptive 
      statistics. 

Descriptive statistics methods
==============================

auto_correlation, correlation, covariance, durbin_watson, frequencies, geometric_mean, 
harmonic_mean, kurtosis, lag1, max, mean, mean_deviation, median, min, moment, moment3, 
moment4, pooled_mean, pooled_variance, product, quantile, quantile_inverse, 
rank_interpolated, rms, sample_covariance, sample_kurtosis, 
sample_kurtosis_standard_error, sample_skew, sample_skew_standard_error, 
sample_standard_deviation, sample_variance, sample_weighted_variance, skew, split,  
standard_deviation, standard_error, sum, sum_of_inversions, sum_of_logarithms, 
sum_of_powers, sum_of_power_deviations, sum_of_squares, sum_of_squared_deviations, 
trimmed_mean, variance, weighted_mean, weighted_rms, weighted_sums, winsorized_mean.

Installation and download
=========================

  + Install Jruby
  + jruby –S gem install mdarray

Contributors
============

  + Contributors are welcome.

Homepages
=========

  + http://rubygems.org/gems/mdarray
  + https://github.com/rbotafogo/mdarray/wiki


HISTORY
=======

  + 16/05/2013: Version 0.5.0: All loops transfered to Java with over 50% performance 
      improvement.  Descriptive statistics from Parallel Colt.
  + 19/04/2013: Version 0.4.3: Fixes a simple (but fatal bug).  No new features
  + 17/04/2013: Version 0.4.2: Adds simple statistics and boolean operators
  + 05/05/2013: Version 0.4.0: Initial release
