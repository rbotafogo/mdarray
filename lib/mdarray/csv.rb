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

require 'csv'
require 'date'

class Csv

  attr_reader :col_sep
  attr_reader :row_sep
  attr_reader :quote_char

  @epoch = Date.new(1970, 1, 1)

  class << self
    attr_reader :epoch
  end

  class Dimension

    attr_reader :frozen
    attr_reader :next_value
    attr_reader :labels
    
    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

    def initialize
      @frozen = false
      @next_value = 0
      @max_value = 0
      @labels = Hash.new
    end

    #------------------------------------------------------------------------------------
    # Adds a new label to this dimension and keeps track of its index.  Labels are
    # indexed starting at 0 and always incrementing.  All labels in the dimension are
    # distinct. If trying to add a label that already exists, will:
    # * add it if it is a new label and return its index;
    # * return the index of an already existing label if the index is non-decreasing and
    #   monotonically increasing or if it is back to 0.  That is, if the last returned
    #   index is 5, then the next index is either 5 or 6 (new label), or 0.
    # * If the last returned index is 0, then the dimension becomes frozen and no more
    #   labels can be added to it.  After this point, add_label has to be called always
    #   in the same order that it was called previously.
    #------------------------------------------------------------------------------------

    def add_label(label)

      if (@labels.has_key?(label))
        if (@labels[label] == @current_value)

        elsif (@labels[label] == @next_value)
          @current_value = @next_value
          if (@next_value < @max_value)
            @next_value = @next_value + 1
          else
            @next_value = 0
          end
        elsif (@labels[label] < @current_value && @labels[label] == 0)
          @frozen = true
          @max_value = @current_value
          @current_value = 0
          @next_value = 1
        else
          raise "Invalid label #{label}"
        end
      else
        raise "Dimension is frozen.  Check order of input data" if frozen
        @current_value = @labels[label] = @next_value
        @next_value = @next_value + 1
      end

      @current_value
      
    end

    #------------------------------------------------------------------------------------
    #
    #------------------------------------------------------------------------------------

  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.read_file(filename, options = {})

    buffer = Array.new
    heading = Array.new
    lines = 0
    columns = nil

    # user has to set the headers to true if the file has headers, however, we will force
    # it to false for reading in order to get an array for each line.
    hds = options[:headers]
    # Get the dimensions on the file
    dimensions = options.delete(:dimensions)
    opts = {converters: :all, return_headers: true} #, headers: false}
    opts = options.merge(opts)
    
    # open the file for reading
    CSV.open(filename, opts) do |csv|

      # if file has headers then read the first line
      header = csv.shift.to_hash.values if hds
      raise "Dimension(s) #{dimensions} are not all in the header #{header}" if !(dimensions - header.to_a).empty?

      csv.each do |row|
        
        # columns is initialized with the first row.size
        columns ||= row.size
        lines += 1
        
        if (row.size != columns)
          raise "Data does not have the same number of columns for all lines"
        end

        # Put each dimension on a Map (hash that preserves the order).  Dimensions cannot
        # have duplicate values.
        # date << row.delete("Date")
        
        row.each do |data|

          # if it is a Date, then convert it to seconds since epoch
          if (data[1].is_a? Date)
            buffer << data[1].to_time.to_i
          end
          
          if (data[1].is_a? Numeric)
            buffer << data[1]
          end
        end
        
      end

      [lines, columns, buffer, header]
      
    end
    
  end

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.read_numeric(filename, headers = false)

    buffer = Array.new
    heading = Array.new
    lines = 0
    columns = nil

    CSV.foreach(filename,  
                {return_headers: false, 
                  # headers: true,
                  converters: [:numeric, :date]} ) do |row|

      if (headers)
        headers = false
        heading << row
        next
      end

      columns ||= row.size
      lines += 1

      row.each do |data|

        if (row.size != columns)
          raise "Data does not have the same number of columns for all lines"
        end

        # if it is a Date, then convert it to seconds since epoch
        if (data.is_a? Date)
          buffer << data.to_time.to_i
        end

        if (data.is_a? Numeric)
          buffer << data
        end
      end

    end

    [lines, columns, buffer, heading]

  end

end # Csv
