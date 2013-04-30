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

  def self.read_double(filename, headers = false)

  end

  def self.read(filename)

    buffer = Array.new
    lines = 0
    columns = nil

    CSV.foreach(filename,  
                {return_headers: false, 
                  # headers: true,
                  converters: [:numeric, :date]} ) do |row|

      columns ||= row.size
      lines += 1

      row.each do |data|
        if (data.is_a? Date)
          buffer << data.to_time.to_i
        end

        if (data.is_a? Numeric)
          buffer << data
        end
      end

    end

    MDArray.double([lines - 1, columns], buffer)

  end

end # Csv
