#======================================================================================
#
#======================================================================================

class NetCDF

  #------------------------------------------------------------------------------------
  # A Variable is a logical container for data. It has a dataType, a set of Dimensions 
  # that define its array shape, and optionally a set of Attributes. The data is a 
  # multidimensional array of primitive types, Strings, or Structures. Data access is 
  # done through the read() methods, which return a memory resident Array.
  # Immutable if setImmutable() was called.
  #------------------------------------------------------------------------------------

  class Variable

    attr_reader :netcdf_variable
    attr_reader :data
    attr_reader :attributes
    attr_reader :dimensions
    attr_reader :index_iterator

    #------------------------------------------------------------------------------------
    # Initializes the Variable by giving a java netcdf_variable
    #------------------------------------------------------------------------------------

    def initialize(netcdf_variable)
      @netcdf_variable = netcdf_variable
    end

    #------------------------------------------------------------------------------------
    # Gets the variable data_type
    #------------------------------------------------------------------------------------

    def get_data_type
      @netcdf_variable.getDataType().toString().to_sym
    end

    #------------------------------------------------------------------------------------
    # Finds an attribute by name
    #------------------------------------------------------------------------------------

    def find_att(att_name, ignore_case = false)

      if (ignore_case)
        @netcdf_variable.findAttributeIgnoreCase(att_name)
      else
        @netcdf_variable.findAttribute(att_name)
      end

    end

    #------------------------------------------------------------------------------------
    # Reads data for this Variable and sets the variable @data to the memory resident 
    # array.
    # <tt>:origin</tt> int array with the origin of data to be read
    # <tt>:shape</tt> int array with the shape of the data to be read.  If origin or 
    # shape is given then the other member of the pair must also be given, otherwise
    # raise an exception
    # <tt>:spec</tt> string specification for the section to be read
    #------------------------------------------------------------------------------------

    def read(*args)

      opts = Map.options(args)
      origin = opts.getopt(:origin)
      shape = opts.getopt(:shape)
      spec = opts.getopt(:spec)

      if (origin || shape)
        if (origin && shape)
          @data = MDArray.new(@netcdf_variable.read(origin.to_java(:int), shape.to_java(:int)))
          return
        else
          raise "Need to provide origin and shape to retrieve data"
        end
      elsif (spec)
        # @data = MDArray.new(@netcdf_variable.read(Java::UcarMa2.Section.new(spec)))
        @data = MDArray.new(@netcdf_variable.read(spec))
        return
      else
        @data = MDArray.new(@netcdf_variable.read())
      end

    end

    #------------------------------------------------------------------------------------
    # Prepares to return all elements in the array in cannonical order.
    #------------------------------------------------------------------------------------

    def prepare_traversal
      @index_iterator = @data.get_index_iterator
    end
    
    #------------------------------------------------------------------------------------
    # Returns the next element of the array.  If there are no more elements on the array
    # return nil
    #------------------------------------------------------------------------------------

    def next
      
      if (@index_iterator.has_next?)
        return @index_iterator.next
      end
      return nil

    end

    #------------------------------------------------------------------------------------
    # Prints the content of the current data slice
    #------------------------------------------------------------------------------------
    
    def to_string
      @data.to_string
    end

    #------------------------------------------------------------------------------------
    # Prints the content of the current data slice
    #------------------------------------------------------------------------------------

    def print_data
      p @data.to_string
    end

  end # Variable

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  class StringVariable < Variable

    
  end # StringVariable

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  class TimeVariable < Variable
    include_package "ucar.nc2.time"

    attr_reader :calendar
    attr_reader :units
    attr_reader :base_date

    #------------------------------------------------------------------------------------
    # Initializes the Variable by giving a java netcdf_variable
    #------------------------------------------------------------------------------------

    def initialize(netcdf_variable)

      super(netcdf_variable)
      @calendar = @netcdf_variable.findAttribute("calendar").getStringValue()
      @units = @netcdf_variable.findAttribute("units").getStringValue()
      date_unit = CalendarDateUnit.of(@calendar, @units)
      @base_date = date_unit.getBaseCalendarDate()

    end
    
    #------------------------------------------------------------------------------------
    # Returns the number of milliseconds elapsed from the base_date to the given date.
    # The given date should be in iso_format.
    #------------------------------------------------------------------------------------

    def to_msec(iso_date)

      date = CalendarDate.parseISOformat(@calendar, iso_date)
      date.getDifferenceInMsecs(@base_date)

    end

    #------------------------------------------------------------------------------------
    # 
    #------------------------------------------------------------------------------------

    def next

      millisec_date = super
      @base_date.add(millisec_date, CalendarPeriod.fromUnitString("Millisec")).toString()

    end

  end # TimeVariable


end # NetCDFInterface
