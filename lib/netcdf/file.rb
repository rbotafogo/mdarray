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

require 'java'

#======================================================================================
#
#======================================================================================

class NetCDF
  
  class File
    include_package "ucar.nc2"
    include_package "ucar.nc2.time"

    attr_reader :home_dir
    attr_reader :file_name
    attr_reader :netcdf_file
    attr_reader :outsid_scope

    #------------------------------------------------------------------------------------
    # Creates a netCDF file for storing processed information
    #------------------------------------------------------------------------------------
    
    def initialize(home_dir, name, outside_scope = nil)
      @home_dir = home_dir
      @file_name = "#{home_dir}/#{name}.nc"
      @outside_scope = outside_scope
    end

    #------------------------------------------------------------------------------------
    # Find all dimensions in the file
    #------------------------------------------------------------------------------------

    def get_dimensions
      @netcdf_file.getDimensions()
    end

    #------------------------------------------------------------------------------------
    # Finds a dimension by full name
    #------------------------------------------------------------------------------------
    
    def find_dimension(dim_name)
      NetCDF::Dimension.new(@netcdf_file.findDimension(dim_name))
    end

    #------------------------------------------------------------------------------------
    # Return the unlimited (record) dimension, or null if not exist. If there are 
    # multiple unlimited dimensions, it will return the first one.
    # <tt>Returns:</tt> the unlimited Dimension, or null if none.
    #------------------------------------------------------------------------------------

    def get_unlimited_dimension
      NetCDF::Dimension.new(@netcdf_file.getUnlimitedDimension())
    end

    #------------------------------------------------------------------------------------
    # Finds a variable by name
    #------------------------------------------------------------------------------------

    def find_variable(var_name)

      var = @netcdf_file.findVariable(var_name)
      use_as = var.findAttribute("use_as")

      if (use_as)
        usage = use_as.getStringValue()
      end
      
      case usage
      when "string"
        StringVariable.new(var)
      when "time"
        TimeVariable.new(var)
      else
        Variable.new(@netcdf_file.findVariable(var_name))
      end

    end

    #------------------------------------------------------------------------------------
    # closes the file
    #------------------------------------------------------------------------------------
    
    def close
      @netcdf_file.close
    end

    #------------------------------------------------------------------------------------
    # Outputs the data CDL to standard output
    # * TODO: allow writing to other output streams.  Need to interface with java streams
    # * <tt>strict</tt> if true, make it stricly CDL, otherwise, add a little extra info
    #------------------------------------------------------------------------------------
    
    def write_cdl(strict = false)
      @netcdf_file.writeCDL(java.lang.System.out, strict)
    end

    #------------------------------------------------------------------------------------
    # Get the file type id for the underlying data source.
    #------------------------------------------------------------------------------------
    
    def get_file_type_id
      @netcdf_file.getFileTypeId()
    end

  end # File

end # NetCDF

require_relative 'file_writeable'
