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

      @directory = "/home/zxb3/tmp"

    end

=begin
    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "Opens existing NetCDF file for writing and defines it" do

      p "opening existing file"

      file = NetCDF.redefine(cygpath(@directory), "nc_output", self) do
        
        @d1 = find_dimension("dim1")
        @d1.length = 8
        @d1.name = "new_dimension1"

        

      end

      file.write_cdl

    end
=end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "Create a new NetCDF file for writing and defines it" do

      # Opens a file for definition, passing the directory and file name.
      # Creates a new scope for defining the NetCDF file.  In order to access the 
      # ouside scope, that is, "here", we pass self as the third argument to define.
      # When self is passed as argument, @outside_scope is available inside the block.

      writer = NetCDF.define(cygpath(@directory), "nc_output", "netcdf3", self) do

        # can add global attributes by adding a single valued attribute or an array of 
        # attributes.  When adding an array of attributes all elements of the array must
        # be of the same type, i.e, fixnum, floats or strings. Attributes with long numbers
        # are not allowed. This seems to be a restriction of Java-NetCDF.
        global_att :fixnums, "Version", [1, 2, 3, 4]
        global_att :strings, "Strings", ["abc", "efg"]
        global_att :floats, "Floats", [1.34, 2.45]

        global_att :fixnum, "Fixnum", 3
        @outside_scope.assert_equal(3, @fixnum.numeric_value)

        global_att :string, "String", "this is a string"
        global_att :float, "Float", 3.45

        global_att :desc, "Description", "This is a test file created by MDArray"
        @outside_scope.assert_equal("String", @desc.data_type)
        @outside_scope.assert_equal("Description", @desc.name)
        @outside_scope.assert_equal("This is a test file created by MDArray", 
                                    @desc.string_value)
        @outside_scope.assert_equal(true, @desc.string?)
        @outside_scope.assert_equal(false, @desc.unsigned?)

=begin
        dimension :dim1, "dim1", 5
        @outside_scope.assert_equal(5, @dim1.length)
        @outside_scope.assert_equal("dim1", @dim1.name)
        @outside_scope.assert_equal(true, @dim1.shared?)
        @outside_scope.assert_equal(false, @dim1.unlimited?)
        @outside_scope.assert_equal(false, @dim1.variable_length?)

        dimension :dim2, "dim2", 10
        @outside_scope.assert_equal(true, @dim2.shared?)

        # create an unlimited dimension by setting the size to 0
        dimension :dim3, "dim3", 0
        @outside_scope.assert_equal(true, @dim3.unlimited?)
        @outside_scope.assert_equal(false, @dim3.variable_length?)
        @outside_scope.assert_equal(true, @dim3.shared?)

        dimension :dim4, "dim4", -1
        @outside_scope.assert_equal(true, @dim4.variable_length?)

        variable :var1, "arr1", "int", [:dim1, :dim2]
        variable_att :att1, "arr1", "description", "this is a variable", "string"
        variable_att :att2, "arr1", "size", 5
        variable_att :att3, "arr1", "date", 10

        variable :var2, "unlimited", "string", [:dim3, :dim2]
        # variable :var3, "variable_length", "double", [:dim4]

        @outside_scope.assert_equal(true, define_mode?)

        large_file = true
        p get_file_type_description
=end
      end


    end

  end
  
end
