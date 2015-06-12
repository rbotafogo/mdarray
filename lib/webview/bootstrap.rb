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

class MDArray

  #==========================================================================================
  #
  #==========================================================================================
  
  class Bootstrap

    attr_reader :max_width
    attr_reader :root_grid
    attr_reader :specified

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def initialize(max_width)
      @max_width = max_width
      @specified = false  # scene has not yet been defined
      @root_grid = MDArray.string([1])  # base grid with one row
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def specified?
      return @specified
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def []=(val)
      # when a grid is assigned to the root_grid, then the scene has been specified
      @specified = true
      @root_grid[0] = val
    end

    #------------------------------------------------------------------------------------
    # String MDArray is actually an Object MDArray, so, any object can be added to it
    #------------------------------------------------------------------------------------

    def new_grid(size)
      MDArray.string(size)
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def add_grid(grid)
      @root_grid[0] = grid
    end

    #------------------------------------------------------------------------------------
    # Creates a grid of the appropriate size for storing the specified number of charts
    # and name them.  The grid will have cols columns and as many rows as necessary to 
    # store all charts. The columns width will be as large as possible.
    #------------------------------------------------------------------------------------

    def create_grid(charts_num, names, cols = 2)

      raise "Then number of columns has to be an integer and not #{cols}" if 
        !cols.is_a? Integer

      columns_width = (@max_width / cols).floor
      rows = (charts_num.to_f / cols).ceil
      grid = new_grid([rows, cols])
      grid.each_with_counter do |cel, count|
        i = rows * count[0] + count[1]
        grid[*count] = (i < names.size)? names[i] : "__bootstrap_empty__"
      end
      add_grid(grid)

    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def title=(title)
      @title = "title.append(\"h4\").text(\"#{title}\");"
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def bootstrap
      
      container = "container = d3.select(\"body\").append(\"div\")"
      container << ".attr(\"class\", \"container\")"
      container << ".attr(\"style\", \"font: 12px sans-serif;\");"

      # Add a title row
      container << "var title = container.append(\"div\").attr(\"class\", \"row\");"
      container << "title.attr(\"class\", \"col-sm-12\")"
      container << ".attr(\"id\", \"title\");"
      container << "title.attr(\"align\", \"center\");\n"
      container << @title if @title

      val = @root_grid[0]
      if (val.is_a? String) 
        raise "ooops... should not be here"
      elsif (val.is_a? StringMDArray)
        raise "Grid should have rank of at most 2" if val.get_rank > 2
        container << "\n " << traverse(val, 12)
      end

      container

    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def traverse(grid, size)

      rank = grid.get_rank
      shape = grid.get_shape

      span = size/shape[0]
      if (span < 1)
        raise "Grid specification invalid"
      end
      
      row = 0
      container = "row#{row} = container.append(\"div\").attr(\"class\", \"row\");\n "
      grid.each_with_counter do |val, counter|
        if (rank == 2 && counter[0] > row)
          row = counter[0]
          container << "row#{row} = container.append(\"div\").attr(\"class\", \"row\");\n "
        end
        if (val.is_a? String)
          container << "row#{row}.append(\"div\").attr(\"class\", \"col-sm-#{span}\")"
          container << ".attr(\"id\", \"#{val}Chart\");\n "
        elsif (val.is_a? StringMDArray)
          container = traverse(val, span)
        end
      end

      container

    end

  end

end
