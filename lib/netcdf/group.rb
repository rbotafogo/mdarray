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
  
  ########################################################################################
  # A Group is a logical collection of Variables. The Groups in a Dataset form a 
  # hierarchical tree, like directories on a disk. A Group has a name and optionally a 
  # set of Attributes. There is always at least one Group in a dataset, the root Group, 
  # whose name is the empty string.
  #
  # Immutable if setImmutable() was called.
  ########################################################################################

  class Group < CDMNode

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def common_parent(group)
      @netcdf_elmt.commomParent(group.netcdf_elmt)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def find_attribute(name, ignore_case = false)
      if (ignore_case)
        NetCDF::Attribute.new(@netcdf_elmt.findAttributeIgnoreCase(name))
      else
        NetCDF::Attribute.new(@netcdf_elmt.findAttribute(name))
      end
    end

    #------------------------------------------------------------------------------------
    # Retrieve a Dimension using its (short) name. If local is true, then
    # retrieve a Dimension using its (short) name, in this group only.
    #------------------------------------------------------------------------------------

    def find_dimension(name, local = false)
      if (local)
        NetCDF::Dimension.new(@netcdf_elmt.findDimensionLocal(name))
      else
        NetCDF::Dimension.new(@netcdf_elmt.findDimension(name))
      end
    end

    #------------------------------------------------------------------------------------
    # Retrieve the Group with the specified (short) name.
    #------------------------------------------------------------------------------------

    def find_group(name)
      NetCDF::Group.new(@netcdf_elmt.findGroup(name))
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def find_variable(name, local = true)

      if (local)
        NetCDF::Variable.new(@netcdf_elmt.findVariable(name))
      else
        NetCDF::Variable.new(@netcdf_elmt.findVariableOrInParent(name))
      end

    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def attributes

      java_attributes = @netcdf_elmt.getAttributes()
      attributes = Array.new
      java_attributes.each do |att|
        attributes << NetCDF::Attribute.new(att)
      end
      attributes

    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def to_string
      @netcdf_elmt.toString()
    end

  end

  #=======================================================================================
  # GroupWriter is a group that allows for writing data on it.
  #=======================================================================================

  class GroupWriter < Group

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def add_attribute(attribute)
      @netcdf_elmt.addAttribute(attribute.netcdf_elmt)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def add_dimension(dimension)
      @netcdf_elmt.addDimension(dimension.netcdf_elmt)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def add_dimension_if_not_exists(dimension)
      @netcdf_elmt.addDimensionIfNotExists(dimension.netcdf_elmt)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def add_group(group)
      @netcdf_elmt.addGroup(group.netcdf_elmt)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def add_variable(variable)
      @netcdf_elmt.addVariable(variable.netcdf_elmt)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def remove(elmt)
      @netcdf_elmt.remove(elmt.netcdf_elmt)
    end

    #------------------------------------------------------------------------------------
    # remove a Dimension using its name, in this group only
    #------------------------------------------------------------------------------------

    def remove_dimension(name)
      @netcdf_elmt.removeDimension(name)
    end

    #------------------------------------------------------------------------------------
    # remove a Variable using its (short) name, in this group only
    #------------------------------------------------------------------------------------

    def remove_variable(name)
      @netcdf_elmt.removeVariable(name)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def name=(name)
      @netcdf_elmt.setName(name)
    end

    #------------------------------------------------------------------------------------
    # Set the Group's parent Group
    #------------------------------------------------------------------------------------

    def parent_group=(parent)
      @netcdf_elmt.setParentGroup(parent.netcdf_elmt)
    end


  end # GroupWriter


end
