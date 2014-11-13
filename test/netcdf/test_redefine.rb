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


    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "Open a file for redefinition" do

      NetCDF.redefine(cygpath(@directory), "nc_output", self) do
        
        # rename_global_att("Values", "New_values")
        # delete_global_att("Values")
        rename_dimension("dim1", "new_dim1")
        # rename_variable("arr1", "new_arr1")

        var1 = find_variable("arr1")
        @outside_scope.assert_equal("arr1", var1.name)
        delete_variable_att(var1, "description")
        rename_variable_att(var1, "size", "new_size")

        p var1.extra_info
        att = var1.find_attribute("date")
        @outside_scope.assert_equal("date", att.name)
        @outside_scope.assert_equal(0, var1.find_dimension_index("new_dim1"))
        atts = var1.find_attributes
        atts.each do |att|
          p att.name
        end
        @outside_scope.assert_equal("int", var1.get_data_type)
        p var1.get_description
        dim = var1.get_dimension(0)
        p dim.name
        p var1.find_dimensions
        p var1.get_dimensions_string
        p var1.get_element_size
        p var1.get_name_and_dimensions
        p var1.rank
        p var1.shape
        p var1.size
        p var1.get_units_string

      end

    end

    #-------------------------------------------------------------------------------------
    # Opens a NetCDF file for reading only
    #-------------------------------------------------------------------------------------

    should "open a file just for reading" do

      # Opens a file for definition, passing the directory and file name.
      # Creates a new scope for defining the NetCDF file.  In order to access the 
      # ouside scope, that is, "here", we pass self as the third argument to define.
      # When self is passed as argument, @outside_scope is available inside the block.
      
      reader = NetCDF.read(cygpath(@directory), "nc_output", self) do
=begin      
        # print all global attributes
        global_attributes.each do |att|
          p att.name
        end
=end
        write_cdl

=begin
        p detail_info
        p file_type_description
        p file_type_id
        p id
        p last_modified
        p location
        p title
        p unlimited_dimension?
=end

      end
      
    end

    
  end
  
end
