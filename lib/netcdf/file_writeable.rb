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

  class FileWriteable < File
    include_package "ucar.ma2"
    include_package "ucar.nc2"
    include_package "ucar.nc2.time"
    
    #------------------------------------------------------------------------------------
    # Opens a netCDF file.
    # * TODO: Check the case when reading should be shared
    # * <tt>fill</tt> If true, or anything but false, the data is first written with fill 
    # values. Default is fill = false. Leave false if you expect to write all data values, 
    # set to true if you want to be sure that unwritten data values have the fill value 
    # in it.
    #------------------------------------------------------------------------------------
    
    def open(new_file, fill = false)

      begin
        if (new_file)
          @netcdf_file = NetcdfFileWriteable.createNew(@file_name, fill)
        else
          @netcdf_file = NetcdfFileWriteable.openExisting(@file_name, fill)
        end
      rescue java.io.IOException => ioe
        $stderr.print "Cannot open file: #{@file_name}"
        $stderr.print ioe
      end
      
    end
    
    #------------------------------------------------------------------------------------
    # Add a Dimension to the file. Must be in define mode.
    # <tt>dimName</tt> name of dimension (string)
    # <tt>length</tt> size of dimension (int).  If size == 0, dimension is unlimited
    # <tt> isShared<tt> if dimension is shared (boolean)
    # <tt> isVariableLength</tt> if dimension is variable length (boolean)
    # <tt> Returns </tt> the created dimension
    # NetCDF3 only supports shared dimensions.
    #------------------------------------------------------------------------------------
    
    def add_dimension(name, size, *args)

      opts = Map.options(args)
      is_variable_length = false
      if (size == -1)
        is_variable_length = true
      end

      dim = nil
      if (size == 0)
        dim = @netcdf_file.addDimension("#{name}", size, true, true, false)
      elsif (is_variable_length)
        dim = @netcdf_file.addDimension("#{name}", size, false, false, is_variable_length)
      else
        dim = @netcdf_file.addDimension("#{name}", size)
      end

      NetCDF::Dimension.new(dim)

    end

    #------------------------------------------------------------------------------------
    # Adds a new dimension.
    #------------------------------------------------------------------------------------

    def dimension(symbol, name, size, *args)
      instance_variable_set("@#{symbol}", add_dimension(name, size, *args))
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
          dim_list.add(instance_variable_get("@#{dim}").netcdf_dimension)
        end
      end

      case type
      when "string"
        NetCDF::Variable.new(@netcdf_file.addStringVariable(var_name, dim_list, max_strlen))
        
      else
        NetCDF::Variable.new(@netcdf_file.addVariable(var_name, 
                                                      DataType.valueOf(type.upcase), 
                                                      dim_list))
      end
      
    end

    #------------------------------------------------------------------------------------
    # Adds new variable
    #------------------------------------------------------------------------------------

    def variable(symbol, name, size, *args)
      instance_variable_set("@#{symbol}", add_variable(name, size, *args))
    end

    #------------------------------------------------------------------------------------
    # Adds a global attribute to the file.
    # * TODO: Storing Array attributes is not working. Creating a Java array is not 
    # working according to jruby documentation (as far as I understand it)
    #------------------------------------------------------------------------------------
    
    def add_global_att(attribute_name, value, type = :int)

      if (value.is_a? Array)
        raise "Array attribute not implemented yet"
      elsif (value.is_a? String)
        NetCDF::Attribute.new(@netcdf_file.addGlobalAttribute(attribute_name, value))
      elsif (value.is_a? Numeric)
        NetCDF::Attribute.new(@netcdf_file.addGlobalAttribute(attribute_name, 
                                                              (value.to_java type)))
      else
        raise "Cannot add attribute of type: #{value}"
      end
      
    end

    #------------------------------------------------------------------------------------
    # Adds new global attribute
    #------------------------------------------------------------------------------------

    def global_att(symbol, name, value, type = :int)
      instance_variable_set("@#{symbol}", add_global_att(name, value, type))
    end

    #------------------------------------------------------------------------------------
    # Adds a variable attribute
    #------------------------------------------------------------------------------------
    
    def add_variable_att(var_name, att_name, value, type = :int)

      if (value.is_a? Array)
        raise "Array attribute not implemented yet"
      elsif (value.is_a? String)
        NetCDF::Attribute.new(@netcdf_file.addVariableAttribute(var_name, att_name, value))
      elsif (value.is_a? Numeric)
        NetCDF::Attribute.new(@netcdf_file.addVariableAttribute(var_name, att_name, 
                                                                (value.to_java type)))
      else
        raise "Cannot add attribute of type: #{value}"
      end
      
    end

    #------------------------------------------------------------------------------------
    # Adds new variable attribute
    #------------------------------------------------------------------------------------

    def variable_att(symbol, var_name, att_name, value, type = :int)
      instance_variable_set("@#{symbol}", add_variable_att(var_name, att_name, value, 
                                                           type))
    end

    #------------------------------------------------------------------------------------
    # After you have added all of the Dimensions, Variables, and Attributes, call create
    # to actually create the file. You must be in define mode. After this call, you are 
    # no longer in define mode.
    #------------------------------------------------------------------------------------
    
    def create

      begin
        @netcdf_file.create
      rescue java.io.IOException => ioe
        $stderr.print "Error accessing file: #{@file_name}"
        $stderr.print ioe
      end

    end

    #------------------------------------------------------------------------------------
    # Set if this should be a "large file" (64-bit offset) format.
    #------------------------------------------------------------------------------------

    def large_file=(bool)
      @netcdf_file.setLargeFile(bool)
    end

    #------------------------------------------------------------------------------------
    # Flush anything written to disk
    #------------------------------------------------------------------------------------

    def flush
      @netcdf_file.flush
    end

    #------------------------------------------------------------------------------------
    # Returns true if the file is in define mode
    #------------------------------------------------------------------------------------

    def define_mode?
      @netcdf_file.isDefineMode()
    end

    #------------------------------------------------------------------------------------
    # Set the fill flag. If fill flag is set then variable data is filled with fill
    # value
    #------------------------------------------------------------------------------------

    def fill=(bool)
      @netcdf_file.setFill(bool)
    end
        
    #------------------------------------------------------------------------------------
    # Get a human-readable description for this file type.
    #------------------------------------------------------------------------------------

    def get_file_type_description
      @netcdf_file.getFileTypeDescription()
    end






    #------------------------------------------------------------------------------------
    # Deletes a global attribute
    #------------------------------------------------------------------------------------

    def delete_global_att(attribute_name)
      @netcdf_file.deleteGlobalAttribute(attribute_name)
    end

    #------------------------------------------------------------------------------------
    # Rename a global Attribute.
    #------------------------------------------------------------------------------------

    def rename_global_att(old_name, new_name)
      @netcdf_file.renameGlobalAttribute(old_name, new_name)
    end

    #------------------------------------------------------------------------------------
    # Rename a Dimension.
    #------------------------------------------------------------------------------------

    def rename_dimension(old_name, new_name)
      @netcdf_file.renameDimension(old_name, new_name)
    end

    #------------------------------------------------------------------------------------
    # Adds coordinate variables.  This is a helper function that creates the dimension
    # and the variable at the same time, following proper conventions.
    # * TODO: check proper conventions.
    # Calendar can have the following values:
    #------------------------------------------------------------------------------------

    def add_coordinate(var_name, type, size, *args)
      
      add_dimension(var_name, size)
      add_variable(var_name, type, var_name, *args)

      opts = Map.options(args)

      case type
      when "time"
        add_variable_att(var_name, "long_name", "time")
      else
        add_variable_att(var_name, "long_name", var_name)
      end

    end

    alias :coordinate :add_coordinate

    #------------------------------------------------------------------------------------
    # Rename a Variable.
    #------------------------------------------------------------------------------------

    def rename_variable(old_name, new_name)
      @netcdf_file.renameVariable(old_name, new_name)
    end

    #------------------------------------------------------------------------------------
    # Deletes a variable attribute
    #------------------------------------------------------------------------------------

    def delete_variable_att(var_name, att_name)
      @netcdf_file.deleteGlobalAttribute(var_name, att_name)
    end

    #------------------------------------------------------------------------------------
    # Renames a variable attribute
    #------------------------------------------------------------------------------------

    def rename_variable_att(var_name, att_name, new_name)
      @netcdf_file.renameVariableAttribute(var_name, att_name, new_name)
    end

    #------------------------------------------------------------------------------------
    # Switches redefine mode.  if true allows data to be redefined, if false, redefine
    # mode is closed.
    # <tt>Returns</tt> true if it had to rewrite the entire file, false if it wrote the 
    # header in place
    #------------------------------------------------------------------------------------
    
    def redefine=(bool)

      begin
        @netcdf_file.setRedefineMode(bool)
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

    def write(var_name, layout, data = nil, origin = nil, type = nil)

      var = find_variable(var_name)

      if (type == nil)
        type = var.get_data_type
      end

      array = NetCDFInterface.mold(type, layout, data)
      if (origin)
        @netcdf_file.write(var_name, origin.to_java(:int), array)
      else
        @netcdf_file.write(var_name, array)
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
        @netcdf_file.writeStringData(var_name, origin.to_java(:int), array)
      else
        @netcdf_file.writeStringData(var_name, array)
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

  end # FileWriteable

end
