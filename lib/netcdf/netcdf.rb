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
    _define(home_dir, file_name, true, version, outside_scope, &block)
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.redefine(home_dir, file_name, version, outside_scope = nil, &block)
    _define(home_dir, file_name, false, version, outside_scope, &block)
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

=begin
    case type
      
    when "boolean", :boolean then DataType.valueOf("BOOLEAN")
    when "byte", :byte then DataType.valueOf("BYTE")
    when "char", :char then DataType.valueOf("CHAR")
    when "double", :double then DataType.valueOf("DOUBLE")
    when "float", :float then DataType.valueOf("FLOAT")
    when "int", :int then DataType.valueOf("INT")
    when "long", :long then DataType.valueOf("LONG")
    when "opaque", :opaque then DataType.valueOf("OPAQUE")
    when "sequence", :sequence then DataType.valueOf("SEQUENCE")
    when "short", :short then DataType.valueOf("SHORT")
    when "string", :string then DataType.valueOf("STRING")
    when "structure", :structure then DataType.valueOf("STRUCTURE")
      
    end
=end

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

  private

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self._define(home_dir, file_name, new_file, file_version, outside_scope = nil, 
                   &block)

    writeable = NetCDF::FileWriter.new(home_dir, file_name, file_version, 
                                       outside_scope)
    writeable.open_write(new_file)
    writeable.redefine = true if !new_file
    writeable.instance_eval(&block)
    writeable.create
    writeable.close
    writeable

  end

end # NetCDF

require_relative 'group'
require_relative 'dimension'
require_relative 'variable'
require_relative 'attribute'
require_relative 'file'
