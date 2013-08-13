Announcement
============

MDArray version 0.5.4 has Just been released. MDArray is a multi dimensional array implemented 
for JRuby inspired by NumPy (www.numpy.org) and Masahiro Tanaka´s Narray (narray.rubyforge.org).
MDArray stands on the shoulders of Java-NetCDF and Parallel Colt.  At this point MDArray has 
libraries for mathematical, trigonometric and descriptive statistics methods.

NetCDF-Java Library is a Java interface to NetCDF files, as well as to many other types of 
scientific data formats.  It is developed and distributed by Unidata 
(http://www.unidata.ucar.edu).

Parallel Colt (http://grepcode.com/snapshot/repo1.maven.org/maven2/net.sourceforge.parallelcolt/
parallelcolt/0.10.0/) is a multithreaded version of Colt (http://acs.lbl.gov/software/colt/).  
Colt provides a set of Open Source Libraries for High Performance Scientific and Technical 
Computing in Java. Scientific and technical computing is characterized by demanding problem 
sizes and a need for high performance at reasonably small memory footprint.

For more information and (some) documentation please go to: https://github.com/rbotafogo/mdarray/wiki

What´s new:
===========

NetCDF-3 File Support
---------------------

From Wikipedia, the free encyclopedia:

"NetCDF (Network Common Data Form) is a set of software libraries and self-describing, 
machine-independent data formats that support the creation, access, and sharing of array-oriented 
scientific data. The project homepage is hosted by the Unidata program at the University 
Corporation for Atmospheric Research (UCAR). They are also the chief source of netCDF software, 
standards development, updates, etc. The format is an open standard. NetCDF Classic and 64-bit 
Offset Format are an international standard of the Open Geospatial Consortium.

The project is actively supported by UCAR. Version 4.0 (released in 2008) allows the use of the 
HDF5 data file format. Version 4.1 (2010) adds support for C and Fortran client access to 
specified subsets of remote data via OPeNDAP.

The format was originally based on the conceptual model of the Common Data Format developed by 
NASA, but has since diverged and is not compatible with it."

This version of MDArray implements NetCDF-3 file support only.  NetCDF-4 is not yet supported.  At
the end of this announcement we show the MDArray implementation of the NetCDF-3 file writing 
from the tutorial at: 
http://www.unidata.ucar.edu/software/netcdf-java/tutorial/NetcdfWriting.html


MDArray and SciRuby:
====================

MDArray subscribes fully to the SciRuby Manifesto (http://sciruby.com/). 

“Ruby has for some time had no equivalent to the beautifully constructed NumPy, SciPy, and 
matplotlib libraries for Python. 

We believe that the time for a Ruby science and visualization package has come. Sometimes 
when a solution of sugar and water becomes super-saturated, from it precipitates a pure, 
delicious, and diabetes-inducing crystal of sweetness, induced by no more than the tap of a 
finger. So is occurring now, we believe, with numeric and visualization libraries for Ruby.”

MDArray main properties are:
============================

 + Homogeneous multidimensional array, a table of elements (usually numbers), all of the 
     same type, indexed by a tuple of positive integers;
 + Easy calculation for large numerical multi dimensional arrays;
 + Basic types are: boolean, byte, short, int, long, float, double, string, structure;
 + Based on JRuby, which allows importing Java libraries;
 + Operator: +,-,*,/,%,**, >, >=, etc.;
 + Functions: abs, ceil, floor, truncate, is_zero, square, cube, fourth;
 + Binary Operators: &, |, ^, ~ (binary_ones_complement), <<, >>;
 + Ruby Math functions: acos, acosh, asin, asinh, atan, atan2, atanh, cbrt, cos, erf, exp, 
     gamma, hypot, ldexp, log, log10, log2, sin, sinh, sqrt, tan, tanh, neg;
 + Boolean operations on boolean arrays: and, or, not;
 + Fast descriptive statistics from Parallel Colt (complete list found bellow);
 + Easy manipulation of arrays: reshape, reduce dimension, permute, section, slice, etc.;
 + Support for reading and writing NetCDF-3 files;
 + Reading of two dimensional arrays from CSV files (mainly for debugging and simple testing 
     purposes);
 + StatList: a list that can grow/shrink and that can compute Parallel Colt descriptive 
     statistics;
 + Experimental lazy evaluation (still slower than eager evaluation).

Descriptive statistics methods imported from Parallel Colt:
===========================================================

  + auto_correlation, correlation, covariance, durbin_watson, frequencies, geometric_mean, 
  + harmonic_mean, kurtosis, lag1, max, mean, mean_deviation, median, min, moment, moment3, 
  + moment4, pooled_mean, pooled_variance, product, quantile, quantile_inverse, 
  + rank_interpolated, rms, sample_covariance, sample_kurtosis, sample_kurtosis_standard_error, 
  + sample_skew, sample_skew_standard_error, sample_standard_deviation, sample_variance, 
  + sample_weighted_variance, skew, split,  standard_deviation, standard_error, sum, 
  + sum_of_inversions, sum_of_logarithms, sum_of_powers, sum_of_power_deviations, 
  + sum_of_squares, sum_of_squared_deviations, trimmed_mean, variance, weighted_mean, 
  + weighted_rms, weighted_sums, winsorized_mean.

Double and Float methods from Parallel Colt:
============================================

  + acos, asin, atan, atan2, ceil, cos, exp, floor, greater, IEEEremainder, inv, less, lg, 
  + log, log2, rint, sin, sqrt, tan.

Double, Float, Long and Int methods from Parallel Colt:
=======================================================

  + abs, compare, div, divNeg, equals, isEqual (is_equal), isGreater (is_greater), 
  + isles (is_less), max, min, minus, mod, mult, multNeg (mult_neg), multSquare (mult_square), 
  + neg, plus (add), plusAbs (plus_abs), pow (power), sign, square.

Long and Int methods from Parallel Colt
=======================================

  + and, dec, factorial, inc, not, or, shiftLeft (shift_left), shiftRightSigned 
      (shift_right_signed), shiftRightUnsigned (shift_right_unsigned), xor.

MDArray installation and download:
==================================

  + Install Jruby
  + jruby –S gem install mdarray

MDArray Homepages:
==================

  + http://rubygems.org/gems/mdarray
  + https://github.com/rbotafogo/mdarray/wiki

Contributors:
=============
Contributors are welcome.

MDArray History:
================

  + 07/08/2013: Version 0.5.4 - Support for reading and writing NetCDF-3 files
  + 24/06/2013: Version 0.5.3 – Over 90% Performance improvements for methods imported 
      from Parallel Colt and over 40% performance improvements for all other methods 
      (implemented in Ruby); 
  + 16/05/2013: Version 0.5.0 - All loops transferred to Java with over 50% performance 
      improvements.  Descriptive statistics from Parallel Colt;
  + 19/04/2013: Version 0.4.3 - Fixes a simple, but fatal bug in 0.4.2.  No new features;
  + 17/04/2013: Version 0.4.2 - Adds simple statistics and boolean operators;
  + 05/04/2013: Version 0.4.0 – Initial release.

NetCDF-3 Writing with MDArray API
=================================

require 'mdarray'

class NetCDF

  attr_reader :dir, :filename, :max_strlen

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def initialize
    @dir = "~/tmp"
    @filename1 = "testWriter"
    @filename2 = "testWriteRecord2"
    @max_strlen = 80
  end
    
  #---------------------------------------------------------------------------------------
  # Define the NetCDF-3 file
  #---------------------------------------------------------------------------------------

  def define_file
      
    # We pass the directory, filename, filetype and optionaly the outside_scope.  
    #
    # I'm implementing in cygwin, so the need for method cygpath that converts the 
    # directory name to a Windows name.  In another environment, just pass the directory
    # name.
    # 
    # Inside a block we have another scope, so the block cannot access any variables, etc. 
    # from the ouside scope. If we pass the outside scope, in this case we are passing self,
    # we can access variables in the outside scope by using @outside_scope.<variable>.
    NetCDF.define(cygpath(@dir), @filename1, "netcdf3", self) do
      
      # add dimensions
      dimension "lat", 64
      dimension "lon", 128
      
      # add variables and attributes
      # add Variable double temperature(lat, lon)
      variable "temperature", "double", [@dim_lat, @dim_lon]
      variable_att @var_temperature, "units", "K"
      variable_att @var_temperature, "scale", [1, 2, 3]
      
      # add a string-value variable: char svar(80)
      # note that this is created as a scalar variable although in NetCDF-3 there is no
      # string type and the string has to be represented as a char type.
      variable "svar", "string", [], {:max_strlen => @outside_scope.max_strlen}
      
      # add a 2D string-valued variable: char names(names, 80)
      dimension "names", 3
      variable "names", "string", [@dim_names], {:max_strlen => @outside_scope.max_strlen}
      
      # add a scalar variable
      variable "scalar", "double", []
      
      # add global attributes
      global_att "yo", "face"
      global_att "versionD", 1.2, "double"
      global_att "versionF", 1.2, "float"
      global_att "versionI", 1, "int"
      global_att "versionS", 2, "short"
      global_att "versionB", 3, "byte"
      
    end

  end

  #---------------------------------------------------------------------------------------
  # write data on the above define file
  #---------------------------------------------------------------------------------------

  def write_file

    NetCDF.write(cygpath(@dir), @filename1, self) do

      temperature = find_variable("temperature")
      shape = temperature.shape
      data = MDArray.fromfunction("double", shape) do |i, j|
        i * 1_000_000 + j * 1_000
      end
      write(temperature, data)

      svar = find_variable("svar")
      write_string(svar, "Two pairs of ladies stockings!")

      names = find_variable("names")
      # careful here with the shape of a string variable.  A string variable has one
      # more dimension than it should as there is no string type in NetCDF-3.  As such,
      # if we look as names' shape it has 2 dimensions, be we need to create a one
      # dimension string array.
      data = MDArray.string([3], ["No pairs of ladies stockings!",
                                  "One pair of ladies stockings!",
                                  "Two pairs of ladies stockings!"])
      write_string(names, data)

      # write scalar data
      scalar = find_variable("scalar")
      write(scalar, 222.333 )

    end

  end

  #---------------------------------------------------------------------------------------
  # Define a file for writing one record at a time
  #---------------------------------------------------------------------------------------

  def define_one_at_time

    NetCDF.define(cygpath(@dir), @filename2, "netcdf3", self) do
      
      dimension "lat", 3
      dimension "lon", 4
      # zero sized dimension is an unlimited dimension
      dimension "time", 0
      
      variable "lat", "float", [@dim_lat]
      variable_att @var_lat, "units", "degree_north"

      variable "lon", "float", [@dim_lon]
      variable_att @var_lon, "units", "degree_east"

      variable "rh", "int", [@dim_time, @dim_lat, @dim_lon]
      variable_att @var_rh, "long_name", "relative humidity"
      variable_att @var_rh, "units", "percent"
      
      variable "T", "double", [@dim_time, @dim_lat, @dim_lon]
      variable_att @var_t, "long_name", "surface temperature"
      variable_att @var_t, "units", "degC"

      variable "time", "int", [@dim_time]
      variable_att @var_time, "units", "hours since 1990-01-01"

    end

  end

  #---------------------------------------------------------------------------------------
  # Define a file for writing one record at a time
  #---------------------------------------------------------------------------------------

  def write_one_at_time

    NetCDF.write(cygpath(@dir), @filename2, self) do

      lat = find_variable("lat")
      lon = find_variable("lon")

      # write non recored data to the variables
      write(lat, MDArray.float([3], [41, 40, 39]))
      write(lon, MDArray.float([4], [-109, -107, -105, -103]))

      # get record variables from file
      rh = find_variable("rh")
      time = find_variable("time")
      t = find_variable("T")

      # there is no method find_dimension for NetcdfFileWriter, so we need to get the
      # dimension from a variable.
      rh_shape = rh.shape
      dim_lat = rh_shape[1]
      dim_lon = rh_shape[2]

      (0...10).each do |time_idx|

        # fill rh_data array
        rh_data = MDArray.fromfunction("int", [dim_lat, dim_lon]) do |lat, lon|
          time_idx * lat * lon
        end
        # reshape rh_data so that it has the same shape as rh variable
        # Method reshape! reshapes the array in-place without data copying.
        rh_data.reshape!([1, dim_lat, dim_lon])

        # fill temp_data array
        temp_data = MDArray.fromfunction("double", [dim_lat, dim_lon]) do |lat, lon|
          time_idx * lat * lon / 3.14159
        end
        # reshape temp_data array so that it has the same shape as temp variable.
        temp_data.reshape!([1, dim_lat, dim_lon])
        
        # write the variables
        write(time, MDArray.int([1], [time_idx * 12]), [time_idx])
        write(rh, rh_data, [time_idx, 0, 0])
        write(t, temp_data, [time_idx, 0, 0])

      end # End time_idx loop
      
    end

  end

end

netcdf = NetCDF.new
netcdf.define_file
netcdf.write_file
netcdf.define_one_at_time
netcdf.write_one_at_time
