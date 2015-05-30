# -*- coding: utf-8 -*-

##########################################################################################
# @author Rodrigo Botafogo
#
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

if !(defined? $ENVIR)
  $ENVIR = true
  require_relative '../env.rb'
end

require 'rubygems'
require "test/unit"
require 'shoulda'

require 'mdarray'

class DCFXTest < Test::Unit::TestCase

  context "Engine test" do

    setup do

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "access webview engine" do

      # Read the data
      p "Reading data"
      ndx = MDArray.double("short.csv", true)
      p "Data read"

      # Assing heading to the columns.  We cannot read the header from the file as 
      # we are storing in an MDArray double.  Could maybe add headers to MDArrays, but
      # it might be better to let Datasets be done in SciCom only.
      dimensions_labels = 
        MDArray.string([7], ["Date", "Open", "High", "Low", "Close", "Volume", 
                             "Adj Close"])

      db = Dashboard.new(1000, 700)
      db.add_data(ndx, dimensions_labels)

      g1 = LineGraph.new("DateOpen")
      g1.width = 700
      g1.height = 200
      g1.x = "Date"
      g1.y = "Open"

      g1.dimension = %{facts.dimension(function(d) {return d["Date"];});}

      # do not add any data to g2.  The data should come from g1.  Need to consider a 
      # better API.  I still don't like this!
      g2 = LineGraph.new("DateVolume")
      g2.width = 700
      g2.height = 200
      g2.x = "Date"
      g2.y = "Volume"

      # do not add any data to g2.  The data should come from g1.  Need to consider a 
      # better API.  I still don't like this!
      g3 = LineGraph.new("DateHigh")
      g3.width = 700
      g3.height = 200
      g3.x = "Date"
      g3.y = "High"
      
      p "plotting"
      db.add_graph(g1)
      db.add_graph(g2)
      db.add_graph(g3)
      db.plot


    end
    
  end
  
end

