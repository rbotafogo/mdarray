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

require '../../config' if @platform == nil
require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "Section Tests" do

    setup do
            
    end

    #-------------------------------------------------------------------------------------
    # Create a new Array using same backing store as this Array, by fixing the specified 
    # dimension at the specified index value. This reduces rank by 1.
    #-------------------------------------------------------------------------------------

    should "create sections" do

      #-----------------------------------------------------------------------------------
      # create a section from a section spec
      # Parse an index section String specification, return equivilent Section. A null 
      # Range means "all" (i.e.":") indices in that dimension.
      # The sectionSpec string uses fortran90 array section syntax, namely:
      #
      # sectionSpec := dims
      # dims := dim | dim, dims
      # dim := ':' | slice | start ':' end | start ':' end ':' stride
      # slice := INTEGER
      # start := INTEGER
      # stride := INTEGER
      # end := INTEGER
      #
      # where nonterminals are in lower case, terminals are in upper case, literals are in 
      # single quotes.
      #
      # Meaning of index selector :
      # ':' = all
      # slice = hold index to that value
      # start:end = all indices from start to end inclusive
      # start:end:stride = all indices from start to end inclusive with given stride
      #-----------------------------------------------------------------------------------

      # creates a section from a spec
      section = MDArray::Section.build(:spec => "0:0,0:5:5")
      assert_equal("0:0,0:5:5", section.to_s)

      section = MDArray::Section.build(:spec => ":,5:10,3:27:3")
      assert_equal(":,5:10,3:27:3", section.to_s)

      # cannot create a section with only the origin, we also need the size and stride
      assert_raise ( RuntimeError ) { MDArray::Section.build(:origin => [0, 0]) }

      # create a section with origin, size and stride
      section = MDArray::Section.build(:origin => [0, 0], :size => [5, 10], 
                                       :stride => [2, 3])
      assert_equal("0:4:2,0:9:3", section.to_s)

      # create a section with origin and shape
      section = MDArray::Section.build(:origin => [5, 1, 2], :shape => [10, 3, 7])
      section.print

      # create a section from shape only
      section = MDArray::Section.build(:shape => [10, 3, 7])
      assert_equal("0:9,0:2,0:6", section.to_s)

    end

  end

end
