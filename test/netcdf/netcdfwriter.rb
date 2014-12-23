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

require 'mdarray'

class NetCDF

  attr_reader :dir, :filename, :max_strlen

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def initialize
    @dir = $TMP_TEST_DIR
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
    NetCDF.define(@dir, @filename1, "netcdf3", self) do
      
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

    NetCDF.write(@dir, @filename1, self) do

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

    NetCDF.define(@dir, @filename2, "netcdf3", self) do
      
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

    NetCDF.write(@dir, @filename2, self) do

      lat = find_variable("lat")
      lon = find_variable("lon")
      write(lat, MDArray.float([3], [41, 40, 39]))
      write(lon, MDArray.float([4], [-109, -107, -105, -103]))

      # get variables from file
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
