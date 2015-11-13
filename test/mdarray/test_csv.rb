# -*- coding: utf-8 -*-

##########################################################################################
# Copyright © 2013 Rodrigo Botafogo. All Rights Reserved. Permission to use, copy, modify, 
# and distribute this software and its documentation for educational, research, and 
# not-for-profit purposes, without fee and without a signed licensing agreement, is hereby 
# granted, provided that the above copyright notice, this paragraph and the following two 
# paragraphs appear in all copies, modifications, and distributions. Contact Rodrigo
# Botafogo - rodrigo.a.botafogo@gmail.com for commercial licensing opportunities.
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

require_relative '../../config'

require 'mdarray'

class MDArrayTest < Test::Unit::TestCase

  context "CSV Tests" do

    setup do

    end
    
    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "Read CSV Data" do
      # res = Csv.read_numeric("VALE_2014.csv")
      res = Csv.read_file("VALE_2014.csv", col_sep: ";", dimensions:["Symbol"])
      # arr = MDArray.double([res[0], res[1]-1], res[2])
      # arr.print
    end

  end

end
