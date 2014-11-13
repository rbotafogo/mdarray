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

class MDArray

  class Section
    include_package "ucar.ma2"

    attr_reader :netcdf_elmt

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    def initialize(netcdf_section)
      @netcdf_elmt = netcdf_section
    end

    #-------------------------------------------------------------------------------------
    # Builds a section by passing the proper section definition. The following itens can
    # be part of the section definition
    # shape
    # origin
    # size
    # stride
    # range
    # section
    # spec
    #-------------------------------------------------------------------------------------

    def self.build(*args)

      opts = Map.options(args)

      shape = opts.getopt(:shape)
      origin = opts.getopt(:origin)
      size = opts.getopt(:size)
      stride = opts.getopt(:stride)
      range = opts.getopt(:range)
      section = opts.getopt(:section)
      spec = opts.getopt(:spec)

      if (spec)
        new(Java::UcarMa2::Section.new(spec))
      elsif (shape)
        if (origin)
          new(Java::UcarMa2::Section.new(origin.to_java(:int), shape.to_java(:int)))
        else
          new(Java::UcarMa2::Section.new(shape.to_java(:int)))
        end
      elsif (origin)
        if (!size || !stride)
          raise "Invalid section definition, size and stride are required"
        end
        new(Java::UcarMa2::Section.new(origin.to_java(:int), size.to_java(:int), 
                                       stride.to_java(:int)))
      elsif (range)
        new(Java::UcarMa2::Section.new(range))
      end

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    def print
      p @netcdf_elmt.toString()
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    def to_s
      @netcdf_elmt.toString()
    end

  end

end


