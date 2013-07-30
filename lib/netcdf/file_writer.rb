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

class NetCDF

  class FileWriter < FileParent
    include_package "ucar.ma2"
    include_package "ucar.nc2"
    
    attr_reader :version
    # Opens the same file just for reading.  I don't know it this will work properly.
    # Needed as the API for FileWriter lacks some interesting features.  Or maybe not!
    # I don't know... I might just be confused!
    attr_reader :reader
    
    #------------------------------------------------------------------------------------
    # Writer for a new NetCDF file
    #------------------------------------------------------------------------------------

    def self.new_file(home_dir, name, version, outside_scope = nil)
      FileWriter.new(home_dir, name, version, outside_scope)
    end

    #------------------------------------------------------------------------------------
    # Writer for an existing NetCDF file
    #------------------------------------------------------------------------------------

    def self.existing_file(home_dir, name, outside_scope = nil)
      FileWriter.new(home_dir, name, nil, outside_scope)
    end
    
    #------------------------------------------------------------------------------------
    # Opens a netCDF file.
    # * TODO: Check the case when reading should be shared
    # * <tt>fill</tt> If true, or anything but false, the data is first written with fill 
    # values. Default is fill = false. Leave false if you expect to write all data values, 
    # set to true if you want to be sure that unwritten data values have the fill value 
    # in it.
    #------------------------------------------------------------------------------------
    
    def open

      begin
        if (@version)
          @netcdf_elmt = NetcdfFileWriter.createNew(@version, @file_name)
          add_root_group
        else
          @netcdf_elmt = NetcdfFileWriter.openExisting(@file_name)
        end
      rescue java.io.IOException => ioe
        $stderr.print "Cannot open file: #{@file_name}"
        $stderr.print ioe
      end
      
    end
    
    #------------------------------------------------------------------------------------
    # Adds a new group to the file.
    #------------------------------------------------------------------------------------

    def add_group(parent, name)
      NetCDF::GroupWriter.new(@netcdf_elmt.addGroup(parent, name))
    end

    #------------------------------------------------------------------------------------
    # Adds the root group to the file.
    #------------------------------------------------------------------------------------

    def add_root_group
      @root_group = add_group(nil, "root")
    end

    #------------------------------------------------------------------------------------
    # Adds a group attribute
    #------------------------------------------------------------------------------------

    def add_group_att(group, attribute)
      group.add_attribute(attribute)
      attribute
    end

    #------------------------------------------------------------------------------------
    # Adds a global attribute
    #------------------------------------------------------------------------------------
    
    def add_global_att(name, value, type = :int)
      attribute = NetCDF::AttributeWriter.build(name, value)
      add_group_att(@root_group, attribute)
    end

    #------------------------------------------------------------------------------------
    # Adds new global attribute.  A global attribute is a attribute added to the root
    # group.  In NetCDF 3 there is only the root group.
    #------------------------------------------------------------------------------------

    def global_att(symbol, name, value, type = :int)
      instance_variable_set("@#{symbol}", add_global_att(name, value, type))
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def find_global_attribute(name, ignore_case = false)

      if (ignore_case)
        att = @root_group.netcdf_elmt.findAttributeIgnoreCase(name)
      else
        att = @root_group.netcdf_elmt.findAttribute(name)
      end

      if (att != nil)
        return NetCDF::AttributeWriter.new(att)
      end

      nil

    end

    #------------------------------------------------------------------------------------
    # Add a Dimension to the file. Must be in define mode.
    # <tt>dimName</tt> name of dimension (string)
    # <tt>length</tt> size of dimension (int).  If size == 0, dimension is unlimited
    # <tt> is_shared<tt> if dimension is shared (boolean)
    # if size == -1, then this is a variable_length dimension
    # if size == 0, this is an unlimited dimension
    # NetCDF3 only supports shared dimensions.
    #------------------------------------------------------------------------------------
    
    def add_dimension(name, size, is_shared = true)

      is_unlimited = false
      is_variable_length = false
      dim = nil

      if (size == -1)
        is_variable_length = true
      elsif (size == 0)
        is_unlimited = true
      end

      NetCDF::DimensionWriter
        .new(@netcdf_elmt.addDimension(@root_group.netcdf_elmt, "#{name}", size, 
                                      is_shared, is_unlimited, is_variable_length))

    end

    #------------------------------------------------------------------------------------
    # Adds a new dimension.
    #------------------------------------------------------------------------------------

    def dimension(symbol, name, size, is_shared = true)
      instance_variable_set("@#{symbol}", add_dimension(name, size, is_shared))
    end

    #------------------------------------------------------------------------------------
    # Finds a dimension by full name
    #------------------------------------------------------------------------------------
    
    def find_dimension(name)
      NetCDF::DimensionWriter.new(@reader.findDimension(name))
    end

    #------------------------------------------------------------------------------------
    # Add a variable to the file.
    #------------------------------------------------------------------------------------

    def add_variable(var_name, type, dims, *args)

      opts = Map.options(args)
      max_strlen = opts.getopt(:max_strlen, :default=>250)

      # if dims is an array then make a java dimension list
      dim_list = java.util.ArrayList.new
      if (dims.is_a? Array)
        dims.each do |dim|
          dim_list.add(instance_variable_get("@#{dim}").netcdf_elmt)
        end
      end
      
      case type
      when "string"
        NetCDF::VariableWriter.new(@netcdf_elmt
                                     .addStringVariable(@root_group.netcdf_elmt, var_name, 
                                                        dim_list, max_strlen))
      else
        NetCDF::VariableWriter.new(@netcdf_elmt
                                     .addVariable(@root_group.netcdf_elmt, var_name, 
                                                  DataType.valueOf(type.upcase), dim_list))
      end
      
    end

    #------------------------------------------------------------------------------------
    # Adds new variable
    #------------------------------------------------------------------------------------

    def variable(symbol, name, type, dims, *args)
      instance_variable_set("@#{symbol}", add_variable(name, type, dims, *args))
    end

    #------------------------------------------------------------------------------------
    # Finds a variable in the file
    #------------------------------------------------------------------------------------

    def find_variable(name)
      var = @netcdf_elmt.findVariable(name)
      var ? NetCDF::VariableWriter.new(var) : nil
    end

    #------------------------------------------------------------------------------------
    # Adds a variable attribute
    #------------------------------------------------------------------------------------
    
    def add_variable_att(variable, name, value)
      attribute = NetCDF::AttributeWriter.build(name, value)
      @netcdf_elmt.addVariableAttribute(variable.netcdf_elmt, attribute.netcdf_elmt)
      attribute
    end
    
    #------------------------------------------------------------------------------------
    # Adds new variable attribute
    #------------------------------------------------------------------------------------

    def variable_att(symbol, variable, att_name, value)
      instance_variable_set("@#{symbol}", 
                            add_variable_att(variable, att_name, value))
    end

    #------------------------------------------------------------------------------------
    # Deletes a global attribute
    #------------------------------------------------------------------------------------

    def delete_global_att(attribute_name)
      @netcdf_elmt.deleteGroupAttribute(@root_group.netcdf_elmt, attribute_name)
    end

    #------------------------------------------------------------------------------------
    # Rename a global Attribute. Does not seem to work on NetCDF-3 files.
    #------------------------------------------------------------------------------------

    def rename_global_att(old_name, new_name)
      @netcdf_elmt.renameGlobalAttribute(@root_group.netcdf_elmt, old_name, new_name)
    end

    #------------------------------------------------------------------------------------
    # Rename a Dimension.
    #------------------------------------------------------------------------------------

    def rename_dimension(old_name, new_name)
      @netcdf_elmt.renameDimension(@root_group.netcdf_elmt, old_name, new_name)
    end



    #------------------------------------------------------------------------------------
    # Rename a Variable.
    #------------------------------------------------------------------------------------

    def rename_variable(old_name, new_name)
      @netcdf_elmt.renameVariable(old_name, new_name)
    end

    #------------------------------------------------------------------------------------
    # Deletes a variable attribute
    #------------------------------------------------------------------------------------

    def delete_variable_att(variable, att_name)
      @netcdf_elmt.deleteVariableAttribute(variable.netcdf_elmt, att_name)
    end

    #------------------------------------------------------------------------------------
    # Renames a variable attribute
    #------------------------------------------------------------------------------------

    def rename_variable_att(variable, att_name, new_name)
      @netcdf_elmt.renameVariableAttribute(variable.netcdf_elmt, att_name, new_name)
    end

    #------------------------------------------------------------------------------------
    # After you have added all of the Dimensions, Variables, and Attributes, call create
    # to actually create the file. You must be in define mode. After this call, you are 
    # no longer in define mode.
    #------------------------------------------------------------------------------------
    
    def create
      
      begin
        @netcdf_elmt.create
      rescue java.io.IOException => ioe
        $stderr.print "Error accessing file: #{@file_name}"
        $stderr.print ioe
      end
      
    end
    
    #------------------------------------------------------------------------------------
    # closes the file
    #------------------------------------------------------------------------------------
    
    def close
      @netcdf_elmt.close
    end

    #------------------------------------------------------------------------------------
    # Set if this should be a "large file" (64-bit offset) format.
    #------------------------------------------------------------------------------------

    def large_file=(bool)
      @netcdf_elmt.setLargeFile(bool)
    end

    #------------------------------------------------------------------------------------
    # Flush anything written to disk
    #------------------------------------------------------------------------------------

    def flush
      @netcdf_elmt.flush
    end

    #------------------------------------------------------------------------------------
    # Returns true if the file is in define mode
    #------------------------------------------------------------------------------------

    def define_mode?
      @netcdf_elmt.isDefineMode()
    end

    #------------------------------------------------------------------------------------
    # Set the fill flag. If fill flag is set then variable data is filled with fill
    # value
    #------------------------------------------------------------------------------------

    def fill=(bool)
      @netcdf_elmt.setFill(bool)
    end
        
    #------------------------------------------------------------------------------------
    # Get a human-readable description for this file type.
    #------------------------------------------------------------------------------------

    def get_file_type_description
      @netcdf_elmt.getFileTypeDescription()
    end

    #------------------------------------------------------------------------------------
    # Switches redefine mode.  if true allows data to be redefined, if false, redefine
    # mode is closed.
    # <tt>Returns</tt> true if it had to rewrite the entire file, false if it wrote the 
    # header in place
    #------------------------------------------------------------------------------------
    
    def redefine=(bool)

      begin
        @netcdf_elmt.setRedefineMode(bool)
      rescue java.io.IOException => ioe
        $stderr.print "Error accessing file: #{@file_name}"
        $stderr.print ioe
      end

    end

    #------------------------------------------------------------------------------------
    # writes the given data with the given layout on variable at origin
    # @nc_i.write(<variable>, <layout>, <origin>, <data>)
    # if data is not given, then it is assumed to be all zeroes
    # @nc_i.write(<variable>, <layout>, <origin>)
    # <tt>var_name</tt> Name of the variable in which to write
    # <tt>type</tt> type of the data.
    # <tt>layout</tt> layout of the data represented by a rank array
    # <tt>origin</tt> origin in the var in which to write the data.  If origin = nil,
    # then origin is <0>
    # <tt>data</tt> data to write.  If data = nil, then an all zeroes data is assumed.
    #------------------------------------------------------------------------------------

    def write(variable, values, origin = nil)

      if (origin)
        @netcdf_elmt.write(variable.netcdf_elmt, origin.to_java(:int), values.nc_array)
      else
        @netcdf_elmt.write(variable.netcdf_elmt, values.nc_array)
      end

    end
    
    #------------------------------------------------------------------------------------
    # writes a string data to the variable at origin
    # if data is not given, then it is assumed to be all zeroes
    # <tt>var_name</tt> Name of the variable in which to write
    # <tt>type</tt> type of the data.
    # <tt>layout</tt> layout of the data represented by a rank array
    # <tt>origin</tt> origin in the var in which to write the data.  If origin = nil,
    # then origin is <0>
    # <tt>data</tt> data to write.  If data = nil, then an all zeroes data is assumed.
    #------------------------------------------------------------------------------------

    def write_string(var_name, layout, data = nil, origin = nil)

      var = find_variable(var_name)

      array = NetCDFInterface.mold(:string, layout, data)
      if (origin)
        @netcdf_elmt.writeStringData(var_name, origin.to_java(:int), array)
      else
        @netcdf_elmt.writeStringData(var_name, array)
      end
      
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def write_time(var_name, layout, data, origin = nil)
      
      var = find_variable(var_name)

      write_data = Array.new
      data.each do |iso_date|
        write_data << var.to_msec(iso_date)
      end

      write(var_name, layout, write_data, origin)

    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------
    
    private

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------
    
    def initialize(home_dir, name, version = nil, outside_scope = nil)

      super(home_dir, name, outside_scope)
      @version = NetCDF.writer_version(version) if version 

    end

  end # FileWriteable

end
