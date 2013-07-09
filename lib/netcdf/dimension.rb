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
  # A Dimension is used to define the array shape of a Variable. It may be shared among 
  # Variables, which provides a simple yet powerful way of associating Variables. When a 
  # Dimension is shared, it has a unique name within its Group. It may have a coordinate 
  # Variable, which gives each index a coordinate value. A private Dimension cannot have a 
  # coordinate Variable, so use shared dimensions with coordinates when possible. The 
  # Dimension length must be > 0, except for an unlimited dimension which may have 
  # length = 0, and a vlen Dimension has length = -1.
  # Immutable if setImmutable() was called, except for an Unlimited Dimension, whose size 
  # can change.
  ########################################################################################

  class Dimension

    attr_reader :netcdf_dimension

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def initialize(netcdf_dimension)
      @netcdf_dimension = netcdf_dimension
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def length
      @netcdf_dimension.getLength()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def length=(val)
      @netcdf_dimension.setLength(val)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def set_immutable
      @netcdf_dimension.setImmutable()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def name
      @netcdf_dimension.getName()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def name=(name)
      @netcdf_dimension.setName(name)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def shared?
      @netcdf_dimension.isShared()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def shared=(bool)
      @netcdf_dimension.setShared(bool)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def unlimited?
      @netcdf_dimension.isUnlimited()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def unlimited=(bool)
      @netcdf_dimension.setUnlimited(bool)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def variable_length?
      @netcdf_dimension.isVariableLength()
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def variable_length=(bool)
      @netcdf_dimension.setVariableLength(bool)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def group=(group)
      @netcdf_dimension.setGroup(group.netcdf_group)
    end


  end # Dimension

end # NetCDF
