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

require 'rubygems'
require "test/unit"
require 'shoulda'

require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "NetCDF implementation" do

    setup do

      @directory = $TMP_TEST_DIR

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "Allow definition of a NetCDF-3 file" do

      # Opens a file for definition, passing the directory and file name.
      # Creates a new scope for defining the NetCDF file.  In order to access the 
      # ouside scope, that is, "here", we pass self as the third argument to define.
      # When self is passed as argument, @outside_scope is available inside the block.
      # NetCDF.define block is in define mode, so it is not possible to write data in
      # this block.  We need to open a new block with NetCDF.write for writing.  The
      # cost of doing this is that we close the file at the end of the define block and
      # need to reopen the file for writing.  However, since we probably only define the
      # file once and write many times, this is not much of a problem.  If one prefers, 
      # one could not use the define block and use the normal APIs.
      
      NetCDF.define(@directory, "nc_output", "netcdf3", self) do
        
        #=================================================================================
        # Add global attributes by adding a single valued attribute or an array of 
        # attributes.  When adding an array of attributes all elements of the array must
        # be of the same type, i.e, fixnum, floats or strings. Attributes with long numbers
        # are not allowed. This seems to be a restriction of Java-NetCDF.
        # 
        # Note that the attribute name can be used to make access to the attribute, for
        # instance, on the first example "Values" can be accessed as @value later on.
        #=================================================================================

        global_att "Fixnum", 3
        @outside_scope.assert_equal(3, @ga_fixnum.numeric_value)

        global_att "Float", 3.45, "float"
        @outside_scope.assert_equal("float", @ga_float.data_type)

        global_att "Double", 3.45, "double"
        @outside_scope.assert_equal("double", @ga_double.data_type)

        global_att "Int", 3.45
        @outside_scope.assert_equal("int", @ga_int.data_type)

        global_att "Byte", 3, "byte"
        @outside_scope.assert_equal("byte", @ga_byte.data_type)

        global_att "Short", 3, "short"
        @outside_scope.assert_equal("short", @ga_short.data_type)
        
        global_att "String", "this is a string"
        global_att "Description", "This is a test file created by MDArray"
        @outside_scope.assert_equal("String", @ga_description.data_type)
        @outside_scope.assert_equal("Description", @ga_description.name)
        @outside_scope.assert_equal("This is a test file created by MDArray", 
                                    @ga_description.string_value)
        @outside_scope.assert_equal(true, @ga_description.string?)
        @outside_scope.assert_equal(false, @ga_description.unsigned?)

        global_att "Values", [1, 2, 3, 4], "double"
        @outside_scope.assert_equal(true, @ga_values.array?)
        @outside_scope.assert_equal("Values", @ga_values.name)
        @outside_scope.assert_equal(2.0, @ga_values.numeric_value(1))

        global_att "Strings", ["abc", "efg"]
        @outside_scope.assert_equal("abc", @ga_strings.string_value(0))

        global_att "Floats", [1.34, 2.45], "float"

        att = find_global_attribute("Fixnum")
        @outside_scope.assert_equal("Fixnum", att.name)

        att = find_global_attribute("doesnotexists")
        @outside_scope.assert_equal(nil, att)

        # print all global attributes
        global_attributes.each do |att|
          p att.name
        end

        #=================================================================================
        # Adding dimensions
        #=================================================================================

        dimension "dim1", 5
        @outside_scope.assert_equal(5, @dim_dim1.length)
        @outside_scope.assert_equal("dim1", @dim_dim1.name)
        @outside_scope.assert_equal(true, @dim_dim1.shared?)
        @outside_scope.assert_equal(false, @dim_dim1.unlimited?)
        @outside_scope.assert_equal(false, @dim_dim1.variable_length?)

        dimension "dim2", 10
        @outside_scope.assert_equal(true, @dim_dim2.shared?)

        # create an unlimited dimension by setting the size to 0
        dimension "dim3", 0
        @outside_scope.assert_equal(true, @dim_dim3.shared?)
        @outside_scope.assert_equal(true, @dim_dim3.unlimited?)
        @outside_scope.assert_equal(false, @dim_dim3.variable_length?)

        # Cannot create a variable_length dimension in NetCDF-3 file.  Might
        # work on NetCDF-4.  Not tested.
        # dimension "dim4", -1
        # @outside_scope.assert_equal(true, @dim_dim4.variable_length?)

        # Create a dimension that is not shared. Don't know exactly what happens
        # in NetCDF-3 files.  It does not give any bugs but the dimension does
        # not appear on a write_cdl call.
        dimension "dim5", 5, false
        @outside_scope.assert_equal("dim5", @dim_dim5.name)
        @outside_scope.assert_equal(false, @dim_dim5.shared?)

        #=================================================================================
        # Adding variables
        #=================================================================================

        # One dimensional variable
        variable "arr1", "int", [@dim_dim1]
        variable_att @var_arr1, "description", "this is a variable"
        variable_att @var_arr1, "size", 5
        variable_att @var_arr1, "date", 10
        variable_att @var_arr1, "String List", ["abc", "def"]
        variable_att @var_arr1, "Float list", [1.37, 5.18]

        # two dimensional variable string variable is actually a three dimensional
        # variable.  NetCDF-3 does not support string variable, so this variable
        # is transformed to a "char" variable with one extra dimension, the string
        # size
        variable "var3", "int", [@dim_dim3]
        variable "var4", "string", [@dim_dim3, @dim_dim2]
        variable "var5", "double", [@dim_dim3, @dim_dim2]

        # controlling the size of the string variable
        variable "Short", "string", [@dim_dim2], {:max_strlen => 20}
        @outside_scope.assert_equal("Short", @var_short.name)

        # double variable with fixed size dimensions
        variable "Double", "double", [@dim_dim1, @dim_dim2]

        # double variable with an unlimited dimension.  Unlimited dimension must be the
        # first dimension in NetCDF-3 files.
        variable "Double3", "double", [@dim_dim3, @dim_dim1, @dim_dim2]
        variable_att @var_double3, "_FillValue", -1

        variable "Scalar", "double", []

        #=================================================================================
        # Add additional flags
        #=================================================================================

        # set fill to true... all elements should be filled with the fill_value
        fill = true
        large_file = true

      end

    end

#=begin
    #-------------------------------------------------------------------------------------
    # Opens a NetCDF file for writing data
    #-------------------------------------------------------------------------------------
  
    should "open a file for writing data" do
      
      NetCDF.write(@directory, "nc_output", self) do

        # create some data to add to variable
        array = MDArray.typed_arange("double", 0, 50)
        array2 = MDArray.typed_arange("double", 0, 10)
        array3 = MDArray.typed_arange("double", 0, 6)
        string_array = MDArray.string([5], ["this", "is", "a", "string", "array"])

        var = find_variable("Double")
        @outside_scope.assert_equal("Double", var.name)
        # reshape the first array to fit the variable shape
        array.reshape!([5, 10])
        # Fill variable Double with data.  The whole variable gets data
        write(var, array)

        # writing data only to the last dimension
        array2.reshape!([1, 10])
        write(var, array2, [4, 0])

        # writing data to a variable with unlimited dimension.  Writing on the third
        # index of the unlimited dimension.  Array needs to be reshaped to the same
        # shape as the variable
        var3 = find_variable("Double3")
        @outside_scope.assert_equal("Double3", var3.name)
        array.reshape!([1, 5, 10])
        write(var3, array, [2, 0, 0])

        # adding data to a subsection of the variable
        array3.reshape!([1, 1, 6])
        write(var3, array3, [1, 1, 1])

        # reshaping the data in another way
        array3.reshape!([1, 3, 2])
        write(var3, array3, [0, 2, 3])

        # writing string data
        short = find_variable("Short") 
        @outside_scope.assert_equal("Short", short.name)
        write_string(short, string_array)

        var4 = find_variable("var4")
        string_array.reshape!([1, 5])
        @outside_scope.assert_equal("var4", var4.name)
        write_string(var4, string_array)

        scalar = find_variable("Scalar")
        @outside_scope.assert_equal("Scalar", scalar.name)
        write(scalar, 5.34)

      end
      
    end
#=end
    #-------------------------------------------------------------------------------------
    # Opens a NetCDF file for reading only
    #-------------------------------------------------------------------------------------
#=begin
    should "open a file just for reading" do

      # Opens a file for definition, passing the directory and file name.
      # Creates a new scope for defining the NetCDF file.  In order to access the 
      # ouside scope, that is, "here", we pass self as the third argument to define.
      # When self is passed as argument, @outside_scope is available inside the block.
      
      NetCDF.read(@directory, "nc_output", self) do

        # print all global attributes
        global_attributes.each do |att|
          p att.name
        end

        att = find_global_attribute("Fixnum")
        @outside_scope.assert_equal("Fixnum", att.name)

        # att 

        dim1 = find_dimension("dim1")
        @outside_scope.assert_equal(5, dim1.length)
        @outside_scope.assert_equal("dim1", dim1.name)
        @outside_scope.assert_equal(true, dim1.shared?)
        @outside_scope.assert_equal(false, dim1.unlimited?)
        @outside_scope.assert_equal(false, dim1.variable_length?)

        unlimited = find_unlimited_dimension
        @outside_scope.assert_equal("dim3", unlimited.name)

        # Although adding an unshared dimension seemed to work on NetCDF-3 file, 
        # trying to retrieve this dimension does not work.
        # unshared = find_dimension("dim5")
        # @outside_scope.assert_equal("dim5", unshared.name)

        # reading the whole Double variable
        var = find_variable("Double")
        var.read

        # reading a section of Double using origin and shape
        var.read(:origin => [1, 1], :shape => [2, 3])

        # reading a section of Double using a section specification
        var.read(:spec => "0:4:2, 4:9:3")

        # reading the whole Double3 variable
        var2 = find_variable("Double3")
        var2.read

        # makes a new variable as a subsection of Double3
        var3 = var2.section(:origin => [0, 1, 1], :shape => [1, 4, 9])

        # reading a section of Double3 using origin and shape
        var2.read(:origin => [0, 1, 1], :shape => [1, 4, 9])

        write_cdl

        p detail_info
        p file_type_description
        p file_type_id
        p id
        p last_modified
        p location
        p title
        p unlimited_dimension?

      end
      
    end
#=end    
    
  end
  
end
  
# require_relative 'test_redefine'
