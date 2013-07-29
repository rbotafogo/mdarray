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

#=========================================================================================
#
#=========================================================================================

class NetCDF

  #=======================================================================================
  # An Attribute has a name and a value, used for associating arbitrary metadata with 
  # a Variable or a Group. The value can be a one dimensional array of Strings or 
  # numeric values.
  # Attributes are immutable.
  #=======================================================================================

  class Attribute

    attr_reader :netcdf_elmt
    
    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def initialize(netcdf_attribute)
      @netcdf_elmt = netcdf_attribute
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def data_type
      @netcdf_elmt.getDataType().toString()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def length
      @netcdf_elmt.getLength()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def name
      @netcdf_elmt.getName()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def numeric_value(index = 0)
      @netcdf_elmt.getNumericValue(index)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def string_value(index = 0)
      @netcdf_elmt.getStringValue(index)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def value(index = 0)
      @netcdf_elmt.getValue(index)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def array?
      @netcdf_elmt.isArray()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def string?
      @netcdf_elmt.isString()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def unsigned?
      @netcdf_elmt.isUnsigned()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def to_string(strict = false)
      @netcdf_elmt.toString(strict)
    end

    #------------------------------------------------------------------------------------
    # Needs to be correctly rubyfied
    #------------------------------------------------------------------------------------

    def write_cdl(formater, strict = false)
      @netcdf_elmt.write_cdl(formater, strict)
    end

  end # Attribute

  #=======================================================================================
  #
  #=======================================================================================

  class AttributeWriter < Attribute

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def self.build(name, val)

      value = val
      if (val.is_a? Fixnum)
        value = val.to_java(:int)
      elsif (val.is_a? Array)
        value = Array.new
        val.each do |elmt|
          if (elmt.is_a? Fixnum)
            value << elmt.to_java(:int)
          else
            value << elmt
          end
        end
      end

      NetCDF::Attribute.new(Java::UcarNc2::Attribute.new(name, value))

    end

  end # AttributeWriter

end


