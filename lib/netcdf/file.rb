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
    attr_reader :version
    attr_reader :netcdf_file
    attr_reader :outsid_scope

    #------------------------------------------------------------------------------------
    # Creates a netCDF file for storing processed information
    #------------------------------------------------------------------------------------
    
    def initialize(home_dir, name, version, outside_scope = nil)
      @home_dir = home_dir
      @file_name = "#{home_dir}/#{name}.nc"
      @version = version
      @outside_scope = outside_scope
    end

    #------------------------------------------------------------------------------------
    # Finds a dimension by full name
    #------------------------------------------------------------------------------------
    
    def find_dimension(name)
      NetCDF::Dimension.new(@netcdf_file.findDimension(name))
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

    def find_variable(name)
      NetCDF::Variable.new(@netcdf_file.findVariable(name))
    end

    #------------------------------------------------------------------------------------
    # Find an attribute, with the specified (escaped full) name.
    #------------------------------------------------------------------------------------

    def find_attribute(name)
      NetCDF::Attribute.new(@netcdf_file.findAttribute(name))
    end

    #------------------------------------------------------------------------------------
    # Find an global attribute, with the specified (full) name.
    #------------------------------------------------------------------------------------

    def find_global_attribute(name, ignore_case = false)
      if (ignore_case)
        NetCDF::Attribute.new(@netcdf_file.findGlobalAttributeIgnoreCase(name))
      else
        NetCDF::Attribute.new(@netcdf_file.findGlobalAttribute(name))
      end
    end

    #------------------------------------------------------------------------------------
    # closes the file
    #------------------------------------------------------------------------------------

    def open

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
    # Find all dimensions in the file
    #------------------------------------------------------------------------------------

    def detail_info
      @netcdf_file.getDetailInfo()
    end

    #------------------------------------------------------------------------------------
    # Get a human-readable description for this file type.
    #------------------------------------------------------------------------------------

    def file_type_description
      @netcdf_file.getFileTypeDescription()
    end

    #------------------------------------------------------------------------------------
    # Get the file type id for the underlying data source.
    #------------------------------------------------------------------------------------

    def file_type_id
      @netcdf_file.getFileTypeId()
    end

    #------------------------------------------------------------------------------------
    # Get the globally unique dataset identifier, if it exists.
    #------------------------------------------------------------------------------------

    def id
      @netcdf_file.getId()
    end

    #------------------------------------------------------------------------------------
    # 
    #------------------------------------------------------------------------------------

    def last_modified
      @netcdf_file.getLastModified() 
    end

    #------------------------------------------------------------------------------------
    # Get the NetcdfFile location.
    #------------------------------------------------------------------------------------

    def location
      @netcdf_file.getLocation() 
    end

    #------------------------------------------------------------------------------------
    # Get the human-readable title, if it exists.
    #------------------------------------------------------------------------------------

    def title
      @netcdf_file.getTitle() 
    end

    #------------------------------------------------------------------------------------
    # Get the human-readable title, if it exists.
    #------------------------------------------------------------------------------------

    def unlimited_dimension?
      @netcdf_file.hasUnlimitedDimension() 
    end



    #------------------------------------------------------------------------------------
    # Find all dimensions in the file
    #------------------------------------------------------------------------------------

    def get_dimensions
      @netcdf_file.getDimensions()
    end

    #------------------------------------------------------------------------------------
    # Get the file type id for the underlying data source.
    #------------------------------------------------------------------------------------
    
    def get_file_type_id
      @netcdf_file.getFileTypeId()
    end

  end # File

end # NetCDF

require_relative 'file_writer'
