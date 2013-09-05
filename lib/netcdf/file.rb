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
  
  #=======================================================================================
  # Parent File for the file hierarchy that includes File and FileWriter.  
  #=======================================================================================

  class FileParent

    attr_reader :home_dir
    attr_reader :file_name
    attr_reader :netcdf_elmt
    attr_reader :outside_scope
    attr_reader :root_group

    #------------------------------------------------------------------------------------
    # NetCDF File
    #------------------------------------------------------------------------------------
    
    def initialize(home_dir, name, outside_scope = nil)
      @home_dir = home_dir
      @file_name = "#{home_dir}/#{name}.nc"
      @outside_scope = outside_scope
    end
    
    #------------------------------------------------------------------------------------
    # Gets a list of all global attributes, i.e, all attributes in the root group
    #------------------------------------------------------------------------------------

    def global_attributes
      @root_group.attributes
    end

  end # FileParent

  #=======================================================================================
  # Read-only scientific datasets that are accessible through the netCDF API. Immutable 
  # after setImmutable() is called. However, reading data is not thread-safe.
  #=======================================================================================

  class File < FileParent
    include_package "ucar.nc2"

    #------------------------------------------------------------------------------------
    # Opens a file for reading
    #------------------------------------------------------------------------------------

    def open
      @netcdf_elmt = NetcdfFile.open(@file_name)
      @root_group = @netcdf_elmt.findGroup(nil)
    end

    #------------------------------------------------------------------------------------
    # Find out if the file can be opened, but dont actually open it.
    #------------------------------------------------------------------------------------

    def can_open?
      @netcdf_elmt.canOpen(@file_name)
    end

    #------------------------------------------------------------------------------------
    # closes the file
    #------------------------------------------------------------------------------------
    
    def close
      @netcdf_elmt.close()
    end

    #------------------------------------------------------------------------------------
    # Completely empty the objects in the netcdf file.
    #------------------------------------------------------------------------------------
    
    def empty
      @netcdf_elmt.empty()
    end

    #------------------------------------------------------------------------------------
    # Find a Group, with the specified (full) name.
    #------------------------------------------------------------------------------------

    def find_group(name)
      NetCDF::Group.new(@netcdf_elmt.findGroup(name))
    end

    #------------------------------------------------------------------------------------
    # Find an attribute, with the specified (escaped full) name.
    #------------------------------------------------------------------------------------

    def find_attribute(name)
      NetCDF::Attribute.new(@netcdf_elmt.findAttribute(name))
    end

    #------------------------------------------------------------------------------------
    # Find an global attribute, with the specified (full) name.
    #------------------------------------------------------------------------------------

    def find_global_attribute(name, ignore_case = false)
      if (ignore_case)
        NetCDF::Attribute.new(@netcdf_elmt.findGlobalAttributeIgnoreCase(name))
      else
        NetCDF::Attribute.new(@netcdf_elmt.findGlobalAttribute(name))
      end
    end

    #------------------------------------------------------------------------------------
    # Finds a dimension by full name
    #------------------------------------------------------------------------------------
    
    def find_dimension(name)
      NetCDF::Dimension.new(@netcdf_elmt.findDimension(name))
    end

    #------------------------------------------------------------------------------------
    # Return the unlimited (record) dimension, or null if not exist. If there are 
    # multiple unlimited dimensions, it will return the first one.
    # <tt>Returns:</tt> the unlimited Dimension, or null if none.
    #------------------------------------------------------------------------------------

    def find_unlimited_dimension
      NetCDF::Dimension.new(@netcdf_elmt.getUnlimitedDimension())
    end

    # Don't know the difference between find and get methods on the original NetCDF API
    alias :get_unlimited_dimension :find_unlimited_dimension


    #------------------------------------------------------------------------------------
    # Finds a variable by name
    #------------------------------------------------------------------------------------

    def find_variable(name)
      NetCDF::Variable.new(@netcdf_elmt.findVariable(name))
    end




    #------------------------------------------------------------------------------------
    # Outputs the data CDL to an output stream
    # * TODO: allow writing to other output streams.  Need to interface with java streams
    # * <tt>strict</tt> if true, make it stricly CDL, otherwise, add a little extra info
    #------------------------------------------------------------------------------------
    
    def write_cdl(out = $stdout, strict = false)
      @netcdf_elmt.writeCDL(out.to_outputstream, strict)
    end

    #------------------------------------------------------------------------------------
    # Find all dimensions in the file
    #------------------------------------------------------------------------------------

    def detail_info
      @netcdf_elmt.getDetailInfo()
    end

    #------------------------------------------------------------------------------------
    # Get a human-readable description for this file type.
    #------------------------------------------------------------------------------------

    def file_type_description
      @netcdf_elmt.getFileTypeDescription()
    end

    #------------------------------------------------------------------------------------
    # Get the file type id for the underlying data source.
    #------------------------------------------------------------------------------------

    def file_type_id
      @netcdf_elmt.getFileTypeId()
    end

    #------------------------------------------------------------------------------------
    # Get the globally unique dataset identifier, if it exists.
    #------------------------------------------------------------------------------------

    def id
      @netcdf_elmt.getId()
    end

    #------------------------------------------------------------------------------------
    # 
    #------------------------------------------------------------------------------------

    def last_modified
      @netcdf_elmt.getLastModified() 
    end

    #------------------------------------------------------------------------------------
    # Get the NetcdfFile location.
    #------------------------------------------------------------------------------------

    def location
      @netcdf_elmt.getLocation() 
    end

    #------------------------------------------------------------------------------------
    # Get the human-readable title, if it exists.
    #------------------------------------------------------------------------------------

    def title
      @netcdf_elmt.getTitle() 
    end

    #------------------------------------------------------------------------------------
    # Get the human-readable title, if it exists.
    #------------------------------------------------------------------------------------

    def unlimited_dimension?
      @netcdf_elmt.hasUnlimitedDimension() 
    end




    #------------------------------------------------------------------------------------
    # Find all dimensions in the file
    #------------------------------------------------------------------------------------

    def get_dimensions
      @netcdf_elmt.getDimensions()
    end

  end # File

end # NetCDF

require_relative 'file_writer'
