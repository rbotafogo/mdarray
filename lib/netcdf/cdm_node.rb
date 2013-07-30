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
  # Define a superclass for all the CDM node classes: Group, Dimension, etc. Define the 
  # sort of the node CDMSort so that we can 1. do true switching on node type 2. avoid use 
  # of instanceof 3. Use container classes that have more than one kind of node
  #
  # Also move various common fields and methods to here.
  #=======================================================================================

  class CDMNode

    attr_reader :netcdf_elmt

    #------------------------------------------------------------------------------------
    # Initializes a CDMNode with a java CDMNode
    #------------------------------------------------------------------------------------

    def initialize(netcdf_cdmnode)
      @netcdf_elmt = netcdf_cdmnode
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def get_full_name
      @netcdf_elmt.getFullName()
    end

    alias :get_full_name_escaped :get_full_name

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def get_short_name
      @netcdf_elmt.getShortName()
    end

    alias :name :get_short_name

  end

end

require_relative 'group'
require_relative 'dimension'
require_relative 'variable'
require_relative 'attribute'
