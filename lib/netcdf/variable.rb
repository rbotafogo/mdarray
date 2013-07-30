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

  #=======================================================================================
  # A Variable is a logical container for data. It has a dataType, a set of Dimensions 
  # that define its array shape, and optionally a set of Attributes. The data is a 
  # multidimensional array of primitive types, Strings, or Structures. Data access is 
  # done through the read() methods, which return a memory resident Array.
  # Immutable if setImmutable() was called.
  #=======================================================================================

  class Variable < CDMNode

    attr_reader :data
    attr_reader :attributes
    attr_reader :dimensions
    attr_reader :index_iterator

    #------------------------------------------------------------------------------------
    # 
    #------------------------------------------------------------------------------------

    def extra_info
      @netcdf_elmt.extraInfo()
    end

    #------------------------------------------------------------------------------------
    # Finds an attribute by name
    #------------------------------------------------------------------------------------

    def find_attribute(name, ignore_case = false)

      if (ignore_case)
        @netcdf_elmt.findAttributeIgnoreCase(name)
      else
        @netcdf_elmt.findAttribute(name)
      end

    end

    #------------------------------------------------------------------------------------
    # Find the index of the named Dimension in this Variable.
    #------------------------------------------------------------------------------------

    def find_dimension_index(name)
      @netcdf_elmt.findDimensionIndex(name)
    end

    #------------------------------------------------------------------------------------
    # Returns the set of attributes for this variable.
    #------------------------------------------------------------------------------------

    def find_attributes

      attributes = @netcdf_elmt.getAttributes()
      atts = Array.new
      attributes.each do |att|
        atts << NetCDF::Attribute.new(att)
      end
      atts

    end

    #------------------------------------------------------------------------------------
    # Gets the variable data_type
    #------------------------------------------------------------------------------------

    def get_data_type
      @netcdf_elmt.getDataType().toString()
    end

    #------------------------------------------------------------------------------------
    # Get the description of the Variable.
    #------------------------------------------------------------------------------------

    def get_description
      @netcdf_elmt.getDescription()
    end

    #------------------------------------------------------------------------------------
    # Get the ith dimension.
    #------------------------------------------------------------------------------------

    def get_dimension(index)
      @netcdf_elmt.getDimension(index)
    end

    #------------------------------------------------------------------------------------
    # Get the list of dimensions used by this variable.
    #------------------------------------------------------------------------------------

    def find_dimensions

      dimensions = @netcdf_elmt.getDimensions()
      dims = Array.new
      dimensions.each do |dim|
        dims << NetCDF::Dimension.new(dim)
      end
      dims

    end

    #------------------------------------------------------------------------------------
    # Get the list of Dimension names, space delineated.
    #------------------------------------------------------------------------------------

    def get_dimensions_string
      @netcdf_elmt.getDimensionsString()
    end

    #------------------------------------------------------------------------------------
    # Get the number of bytes for one element of this Variable.
    #------------------------------------------------------------------------------------

    def get_element_size
      @netcdf_elmt.getElementSize()
    end

    #------------------------------------------------------------------------------------
    # Get the display name plus the dimensions, eg 'float name(dim1, dim2)'
    #------------------------------------------------------------------------------------

    def get_name_and_dimensions
      @netcdf_elmt.getNameAndDimensions()
    end

    #------------------------------------------------------------------------------------
    # Get the number of dimensions of the Variable.
    #------------------------------------------------------------------------------------

    def get_rank
      @netcdf_elmt.getRank()
    end

    alias :rank :get_rank

    #------------------------------------------------------------------------------------
    # Get the shape: length of Variable in each dimension.
    #------------------------------------------------------------------------------------

    def get_shape(index = nil)
      if (index)
        @netcdf_elmt.getShape(index)
      else
        @netcdf_elmt.getShape().to_a
      end
    end

    alias :shape :get_shape

    #------------------------------------------------------------------------------------
    # Get the total number of elements in the Variable.
    #------------------------------------------------------------------------------------

    def get_size
      @netcdf_elmt.getSize()
    end

    alias :size :get_size

    #------------------------------------------------------------------------------------
    # Get the Unit String for the Variable.
    #------------------------------------------------------------------------------------

    def get_units_string
      @netcdf_elmt.getUnitsString()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------
    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    #------------------------------------------------------------------------------------
    # Reads data for this Variable and sets the variable @data to the memory resident 
    # array.
    # <tt>:origin</tt> int array with the origin of data to be read
    # <tt>:shape</tt> int array with the shape of the data to be read.  If origin or 
    #------------------------------------------------------------------------------------

    def read(*args)

      opts = Map.options(args)
      origin = opts.getopt(:origin)
      shape = opts.getopt(:shape)

      if (origin || shape)
        @data = MDArray.new(@netcdf_elmt.read(origin.to_java, shape.to_java))
      else
        arr = @netcdf_elmt.read()
        @data = MDArray.build_from_nc_array(nil, @netcdf_elmt.read())
      end
      
    end






    #------------------------------------------------------------------------------------
    # Prints the content of the current data slice
    #------------------------------------------------------------------------------------
    
    def to_string
      @data.to_string
    end

    #------------------------------------------------------------------------------------
    # Prints the content of the current data slice
    #------------------------------------------------------------------------------------

    def print_data
      p @data.to_string
    end

  end # Variable

  #=======================================================================================
  #
  #=======================================================================================

  class VariableWriter < Variable

  end # VariableWriter


  #=======================================================================================
  #
  #=======================================================================================

  class StringVariable < Variable
    
  end # StringVariable


  #=======================================================================================
  #
  #=======================================================================================

  class TimeVariable < Variable
    include_package "ucar.nc2.time"

    attr_reader :calendar
    attr_reader :units
    attr_reader :base_date

    #------------------------------------------------------------------------------------
    # Initializes the Variable by giving a java netcdf_variable
    #------------------------------------------------------------------------------------

    def initialize(netcdf_variable)

      super(netcdf_variable)
      @calendar = @netcdf_elmt.findAttribute("calendar").getStringValue()
      @units = @netcdf_elmt.findAttribute("units").getStringValue()
      date_unit = CalendarDateUnit.of(@calendar, @units)
      @base_date = date_unit.getBaseCalendarDate()

    end
    
    #------------------------------------------------------------------------------------
    # Returns the number of milliseconds elapsed from the base_date to the given date.
    # The given date should be in iso_format.
    #------------------------------------------------------------------------------------

    def to_msec(iso_date)

      date = CalendarDate.parseISOformat(@calendar, iso_date)
      date.getDifferenceInMsecs(@base_date)

    end

    #------------------------------------------------------------------------------------
    # 
    #------------------------------------------------------------------------------------

    def next

      millisec_date = super
      @base_date.add(millisec_date, CalendarPeriod.fromUnitString("Millisec")).toString()

    end

  end # TimeVariable


end # NetCDFInterface
