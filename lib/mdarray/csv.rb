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
# require 'smarter_csv'
require 'date'

class Csv

  @epoch = Date.new(1970, 1, 1)

  class << self
    attr_reader :epoch
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
