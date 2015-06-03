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

      db = Dashboard.new(1500, 700)
      db.add_data(ndx, dimensions_labels)
      # prepare the dimensions for use in filtering.  Crossfilter does not filter on
      # the same dimension, so, in order fo the two graphs to react to each other we
      # need to define the same dimension twice.
      db.prepare_dimension("dateDimension", "Date")
      db.prepare_dimension("timeDimension", "Date")

      # creates a new grid for adding the graphs
      grid1 = db.new_grid([2, 2])
      grid1[0, 0] = "DateHigh"
      grid1[0, 1] = "DateVolume"
      grid1[1, 0] = "DateOpen"
      grid1[1, 1] = "DateClose"

=begin
      grid2 = db.new_grid([2, 1])
      grid2[0, 0] = "Hello from grid2"
      grid1[1, 0] = grid2
=end
      db.add_grid(grid1)
      p db.bootstrap

      g1 = LineGraph.new("DateOpen")
      g1.width(300)
        .height(200)
        .margins("{top: 10, right:10, bottom: 50, left: 100}")
        .x("Date")
        .y("Open")
        .dimension("dateDimension")
        .elastic_y(true)
        .group("dateDimension", "reduceSum") # needs to be defined after y

      g2 = LineGraph.new("DateVolume")
      g2.width(300)
        .height(200)
        .margins("{top: 10, right:10, bottom: 50, left: 100}")
        .x("Date")
        .y("Volume")
        .dimension("timeDimension")
        .elastic_y(true)
        .group("timeDimension", "reduceSum") # needs to be defined after y

      g3 = LineGraph.new("DateHigh")
      g3.width(300).height(200)
        .x("Date")
        .y("High")
        .margins("{top: 10, right:10, bottom: 50, left: 100}")
        .dimension("timeDimension")
        .elastic_y(true)
        .group("timeDimension", "reduceSum") # needs to be defined after y
      
      db.add_graph(g1)
      db.add_graph(g2)
      db.add_graph(g3)

      # p db.spec
=begin

      g2 = LineGraph.new("DateVolume")
      g2.width(700).height(200).x("Date").y("Volume")
      db.add_graph(g2)

      db.add_graph(g3)
=end

      p "plotting"
      db.plot

    end
    
  end
  
end

