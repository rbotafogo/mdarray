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

    should "allow complex grid specification and slideshow" do

      # Read the data
      ndx = MDArray.double("VALE_2014.csv", true)
      # Assing heading to the columns.  We cannot read the header from the file as 
      # we are storing in an MDArray double.  Could maybe add headers to MDArrays, but
      # it might be better to let Datasets be done in SciCom only.
      dimensions_labels = 
        MDArray.string([7], ["Date", "Open", "High", "Low", "Close", "Volume", 
                             "Adj Close"])

      # Create a new dashboard.  A dashboard is created with new data and its labels.  If
      # there are columns with date information, then this should be given as an array of
      # columns
      db = Sol.dashboard("VALE_2014", ndx, dimensions_labels, ["Date"])
      
      # Crossfilter does not filter on
      # the same dimension, so, in order for two graphs to react to each other when they
      # have the same 'x' column we need to define an alias for this column.  In this case
      # we are defining Time as an alias for the Date column
      db.prepare_dimension("Time", "Date")

      scene = db.scene
      scene.title = "VALE 2014"

      # Specify how the scene should look like by defining a grid
      grid_external = scene.new_grid([1, 2])

      grid1 = scene.new_grid([2, 1])
      grid1[0, 0] = "DateOpen"
      grid1[1, 0] = "DateHigh"

      grid_external[0, 0] = grid1
      grid_external[0, 1] = "DateVolume"

      scene.add_grid(grid_external)

      # Calculate the x scale.  Finding min and max for the date column (first one, index
      # = 0).  Use reset_statistics on the MDArray to allow calling method min and max
      date = ndx.section([0, 0], [ndx.shape[0], 1])
      date.reset_statistics
      x_scale = Sol.scale(:time)
      x_scale.domain([date.min, date.max])

      # minimal chart.  No options are set
      g1 = db.chart(:line_chart, "Date", "Open", "DateOpen")
        .width(600).height(200)
        .x(x_scale)

      # maximal chart... all options availabe explicitly set
      g2 = db.chart(:bar_chart, "Time", "Volume", "DateVolume")
        .width(600).height(400)
        .margins(top:10, right: 10, bottom: 50, left: 80)
        .elastic_y(true)
        .group(:reduce_sum)
        .x_axis_label("Data em dias")
        .y_axis_label("Volumen em milhões (R$)")
        .x(:time, [date.min, date.max])  # sets the x scale

      # default_margins are = {top: 10, right: 50, bottom: 30, left: 30}.  Changing one of the four
      # margins will keep the others as the default.
      g3 = db.chart(:line_chart, "Time", "High", "DateHigh")
        .width(600).height(200)
        .margins(left: 40)
        .group(:reduce_sum)
        .x(:time, [date.min, date.max])  # sets the x scale

      db.plot(1400, 600)

      # Example of executing a javascript inside the GUI window
      Sol.eval("d3.select(\"body\").append(\"div\").text(\"hi there\");")
      
      # Javascript in a here document (nice Ruby style!)
      Sol.eval(<<EOS)
           d3.select("body").append("div").text("hi there again!!");
           d3.select("body").append("div").text("hi there again the third time!!");
EOS

      # wait three seconds before proceeding, allowing time for charts viewing
      sleep(3)

      # Add new chart.  In this version of Sol, adding a new chart to the dashboard and
      # calling plot, will remove all the other charts.  It is not possible to append to
      # the dashboard.  This will be changed in future versions.
      g = db.chart(:line_chart, "Date", "Open", "DateOpen")
        .width(600).height(200)
        .x(x_scale)

      # and plot it
      db.plot

      sleep(3)
      
      # Read new data.
      ndx = MDArray.double("PETR4_2014.csv", true)
      
      # Assing heading to the columns.  We cannot read the header from the file as 
      # we are storing in an MDArray double.  Could maybe add headers to MDArrays, but
      # it might be better to let Datasets be done in SciCom only.
      dimensions_labels = 
        MDArray.string([7], ["Date", "Open", "High", "Low", "Close", "Volume", 
                             "Adj Close"])

      # Create a new dashboard with the new data read.
      db2 = Sol.dashboard("PETR4_2014", ndx, dimensions_labels, ["Date"])

      # Calculate the x scale.  Finding min and max for the date column (first one, index
      # = 0).  Use reset_statistics on the MDArray to allow calling method min and max
      date = ndx.section([0, 0], [ndx.shape[0], 1])
      date.reset_statistics
      x_scale = Sol.scale(:time)
      x_scale.domain([date.min, date.max])

      # minimal chart.  No options are set
      g1 = db2.chart(:line_chart, "Date", "Open", "DateOpen")
        .width(600).height(200)
        .x(x_scale)

      db2.plot
      
    end
    
  end
  
end

