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


#======================================================================================
#
#======================================================================================

class NetCDF
  include_package "ucar.nc2"
  include_package "ucar.ma2"

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.define(home_dir, file_name, version, outside_scope = nil, &block)

    writer = NetCDF::FileWriter.new_file(home_dir, file_name, version, outside_scope)
    begin
      writer.open
      writer.instance_eval(&block)
      writer.create
      writer.close
      writer
    rescue
      writer.close
      raise "Illegal opperation occured on file: #{writer.file_name}"
    end

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.redefine(home_dir, file_name, outside_scope = nil, &block)

    writer = NetCDF::FileWriter.existing_file(home_dir, file_name, outside_scope)
    begin
      writer.open
      writer.redefine = true
      # we are not really adding a root group, but actually getting the root group
      # can only be done in define mode
      writer.add_root_group
      writer.instance_eval(&block)
      writer.redefine = false
      writer.close
      writer
    rescue Exception =>e
      writer.close
      p e.message
      # p e.backtrace.inspect
      raise "Illegal opperation occured on file: #{writer.file_name}"
    end

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.write(home_dir, file_name, outside_scope = nil, &block)

    writer = NetCDF::FileWriter.existing_file(home_dir, file_name, outside_scope)

    begin
      writer.open
      writer.instance_eval(&block)
      writer.close
      writer
    rescue
      writer.close
      raise "Illegal opperation occured on file: #{file_name}"
    end

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.read(home_dir, file_name, outside_scope = nil, &block)

    reader = NetCDF::File.new(home_dir, file_name, outside_scope)
    begin
      reader.open
      reader.instance_eval(&block)
      reader.close
      reader
    rescue Exception => e
      reader.close
      p e.message
      raise "Illegal opperation occured on file: #{file_name}"
    end

  end

  #------------------------------------------------------------------------------------
  # Outputs the data format
  #------------------------------------------------------------------------------------
  
  def self.output(file_name)
    print `ncdump #{file_name}`
  end
  
  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def self.get_dtype(type)
    DataType.valueOf(type.upcase)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------
  
  def self.writer_version(name)
    NetcdfFileWriter::Version.valueOf(name)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

end # NetCDF

require_relative 'group'
require_relative 'dimension'
require_relative 'variable'
require_relative 'attribute'
require_relative 'file'
