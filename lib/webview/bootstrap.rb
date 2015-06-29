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

  #==========================================================================================
  #
  #==========================================================================================
  
  class Bootstrap

    attr_reader :root_grid
    attr_reader :specified

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def initialize
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

    def new_grid(shape)

      if (shape.size != 2)
        raise "Grid specification invalid - rank must be 2 and not: #{shape.size}"
      end

      MDArray.string(shape)

    end

    #------------------------------------------------------------------------------------
    # Creates a grid of the appropriate size for storing the specified number of charts
    # and name them.  The grid will have cols columns and as many rows as necessary to 
    # store all charts. The columns width will be as large as possible.
    #------------------------------------------------------------------------------------

    def create_grid(charts_num, names, cols = 2)

      raise "Then number of columns has to be an integer and not #{cols}" if 
        !cols.is_a? Integer

      # Not used yet... 
      # columns_width = (@max_width / cols).floor
      rows = 0

      if (charts_num <= cols)
        rows = 1
        grid = new_grid([charts_num, rows])
      else
        rows = (charts_num.to_f / cols).ceil
        grid = new_grid([rows, cols])
      end
      
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
      
      container = "// Add new Bootstrap Container"
      # container = "container = d3.select(\"body\").append(\"div\")"
      container = "container = d3.select(\"last\").insert(\"div\")"
      container << ".attr(\"class\", \"container\")"
      container << ".attr(\"style\", \"font: 12px sans-serif;\");\n\n"

      # Add a title row
      container << "// Add a row for the dashboard title\n"
      container << "var title = container.append(\"div\").attr(\"class\", \"row\");\n"
      container << "title.attr(\"class\", \"col-sm-12\")"
      container << ".attr(\"id\", \"title\")"
      container << ".attr(\"align\", \"center\");\n"
      container << @title if @title

      container << "var main = container.append(\"div\").attr(\"class\", \"row\");\n"
      container << "main.attr(\"class\", \"col-sm-12\")"

      grid = @root_grid[0]
      if (grid.is_a? StringMDArray)
        raise "Grid should have rank of at most 2" if grid.get_rank > 2
        container << "\n " << traverse(grid, 12, "main")
      elsif
        p grid
        raise "Something wrong happened! Sorry."
      end

      container

    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def traverse(grid, size, parent = "container", g = 1)

      rank = grid.get_rank
      shape = grid.get_shape
      span = size/shape[1]

      if (span < 1 || rank != 2)
        raise "Grid specification invalid with rank: #{rank} and span #{span}"
      end
      
      row = -1
      col = -1
      # cel = "g#{g}_#{row}"
      # container = "var #{cel} = #{parent}.append(\"div\").attr(\"class\", \"row\");\n"
      # parent = cel
      container = String.new
      push = String.new
      row_spec = String.new
      cel = String.new

      grid.each_with_counter do |val, counter|
        # new row
        if (counter[0] > row)
          col = -1    # reset the column counter
          row = counter[0]
          row_spec = "g#{g}_#{row}"
          container << "var #{row_spec} = #{parent}.append(\"div\").attr(\"class\", \"row\");\n"
          # cel = row_spec
          # parent = cel
        end
        # new column?
        # if (shape[1] > 1 && counter[1] > col)
        if (counter[1] > col)
          col = counter[1]
          cel = "#{row_spec}_#{col}"
          container << "var #{cel} = #{row_spec}.append(\"div\").attr(\"class\", \"col-sm-#{span}\");\n"
        end

        if (val.is_a? String)
          # leaf cel
          container << "#{cel}.attr(\"id\", \"#{val}Chart\");\n "
        elsif (val.is_a? StringMDArray)
          # new grid
          # p "calling traverse with #{g + 1}"
          push << traverse(val, span, cel, g + 1)
        end
      end

      container + push

    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    # private

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def add_grid(grid)
      @specified = true
      @root_grid[0] = grid
    end

  end

end
