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

#==========================================================================================
#
#==========================================================================================

class Sol

  class LineChart < Sol::Chart
    include CoordinateChart
    include Margins

    #------------------------------------------------------------------------------------
    # Get or set render area flag. If the flag is set to true then the chart will render 
    # the area beneath each line and the line chart effectively becomes an area chart.
    #------------------------------------------------------------------------------------

    def render_area(bool = nil)
      return @properties["renderArea"] if bool == nil
      @properties["renderArea"] = bool
      return self
    end

    #------------------------------------------------------------------------------------
    # Get or set render area flag. If the flag is set to true then the chart will render 
    # the area beneath each line and the line chart effectively becomes an area chart.
    #------------------------------------------------------------------------------------

    def render_data_points(bool = nil)
      return @properties["renderDataPoints"] if bool == nil
      @properties["renderDataPoints"] = bool
      return self
    end

  end

  class BarChart < Sol::Chart
    include CoordinateChart
    include Margins
  end

end
