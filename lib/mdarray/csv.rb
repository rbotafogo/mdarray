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

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def self.read_numeric(filename, headers = false)

    buffer = Array.new
    lines = 0
    columns = nil

    CSV.foreach(filename,  
                {return_headers: false, 
                  # headers: true,
                  converters: [:numeric, :date]} ) do |row|

      if (headers)
        headers = false
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

    [lines, columns, buffer]

  end

end # Csv
