require 'mdarray'

class NetCDF

  attr_reader :dir, :filename, :max_strlen

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def initialize
    @dir = "~/tmp"
    @filename1 = "testWriter"
    @filename2 = "testWriteRecord2"
    @max_strlen = 80
  end
    
  #---------------------------------------------------------------------------------------
  # Define the NetCDF-3 file
  #---------------------------------------------------------------------------------------

  def define_file
      
    # We pass the directory, filename, filetype and optionaly the outside_scope.  
    #
    # I'm implementing in cygwin, so the need for method cygpath that converts the 
    # directory name to a Windows name.  In another environment, just pass the directory
    # name.
    # 
    # Inside a block we have another scope, so the block cannot access any variables, etc. 
    # from the ouside scope. If we pass the outside scope, in this case we are passing self,
    # we can access variables in the outside scope by using @outside_scope.<variable>.
    NetCDF.define(cygpath(@dir), @filename1, "netcdf3", self) do
      
      # add dimensions
      dimension "lat", 64
      dimension "lon", 128
      
      # add variables and attributes
      # add Variable double temperature(lat, lon)
      variable "temperature", "double", [@dim_lat, @dim_lon]
      variable_att @var_temperature, "units", "K"
      variable_att @var_temperature, "scale", [1, 2, 3]
      
      # add a string-value variable: char svar(80)
      # note that this is created as a scalar variable although in NetCDF-3 there is no
      # string type and the string has to be represented as a char type.
      variable "svar", "string", [], {:max_strlen => @outside_scope.max_strlen}
      
      # add a 2D string-valued variable: char names(names, 80)
      dimension "names", 3
      variable "names", "string", [@dim_names], {:max_strlen => @outside_scope.max_strlen}
      
      # add a scalar variable
      variable "scalar", "double", []
      
      # add global attributes
      global_att "yo", "face"
      global_att "versionD", 1.2, "double"
      global_att "versionF", 1.2, "float"
      global_att "versionI", 1, "int"
      global_att "versionS", 2, "short"
      global_att "versionB", 3, "byte"
      
    end

  end

  #---------------------------------------------------------------------------------------
  # write data on the above define file
  #---------------------------------------------------------------------------------------

  def write_file

    NetCDF.write(cygpath(@dir), @filename1, self) do

      temperature = find_variable("temperature")
      shape = temperature.shape
      data = MDArray.fromfunction("double", shape) do |i, j|
        i * 1_000_000 + j * 1_000
      end
      write(temperature, data)

      svar = find_variable("svar")
      write_string(svar, "Two pairs of ladies stockings!")

      names = find_variable("names")
      # careful here with the shape of a string variable.  A string variable has one
      # more dimension than it should as there is no string type in NetCDF-3.  As such,
      # if we look as names' shape it has 2 dimensions, be we need to create a one
      # dimension string array.
      data = MDArray.string([3], ["No pairs of ladies stockings!",
                                  "One pair of ladies stockings!",
                                  "Two pairs of ladies stockings!"])
      write_string(names, data)

      # write scalar data
      scalar = find_variable("scalar")
      write(scalar, 222.333 )

    end

  end

  #---------------------------------------------------------------------------------------
  # Define a file for writing one record at a time
  #---------------------------------------------------------------------------------------

  def define_one_at_time

    NetCDF.define(cygpath(@dir), @filename2, "netcdf3", self) do
      
      dimension "lat", 3
      dimension "lon", 4
      # zero sized dimension is an unlimited dimension
      dimension "time", 0
      
      variable "lat", "float", [@dim_lat]
      variable_att @var_lat, "units", "degree_north"

      variable "lon", "float", [@dim_lon]
      variable_att @var_lon, "units", "degree_east"

      variable "rh", "int", [@dim_time, @dim_lat, @dim_lon]
      variable_att @var_rh, "long_name", "relative humidity"
      variable_att @var_rh, "units", "percent"
      
      variable "T", "double", [@dim_time, @dim_lat, @dim_lon]
      variable_att @var_t, "long_name", "surface temperature"
      variable_att @var_t, "units", "degC"

      variable "time", "int", [@dim_time]
      variable_att @var_time, "units", "hours since 1990-01-01"

    end

  end

  #---------------------------------------------------------------------------------------
  # Define a file for writing one record at a time
  #---------------------------------------------------------------------------------------

  def write_one_at_time

    NetCDF.write(cygpath(@dir), @filename2, self) do

      lat = find_variable("lat")
      lon = find_variable("lon")
      write(lat, MDArray.float([3], [41, 40, 39]))
      write(lon, MDArray.float([4], [-109, -107, -105, -103]))
  
      # define array for rh data
      rh = find_variable("rh")
      rh_shape = rh.shape
      # there is no method find_dimension for NetCDFFileWriter, so we need to get the
      # dimension from a variable
      dim_lat = rh_shape[1]
      dim_lon = rh_shape[2]
      rh_data = MDArray.int([1, dim_lat, dim_lon])

      # define array for T data
      temp = find_variable("T")
      temp_data = MDArray.double([1, dim_lat, dim_lon])
      
      # define array for time data
      time_data = MDArray.int([10])

      (0...10).each do |time_idx|
        time_data[time_idx] = time_idx * 12
        (0...dim_lat).each do |lat_idx|
          (0...dim_lon).each do |lon_idx|
            rh_data[0, lat_idx, lon_idx] = time_idx * lat_idx * lon_idx
            temp_data[0, lat_idx, lon_idx] = time_idx * lat_idx * lon_idx / 3.14159
          end # lon_idx
        end # lat_idx
      end # time_idx

      time_data.print
      rh_data.print
      temp_data.print

    end

  end

end

netcdf = NetCDF.new
# netcdf.define_file
# netcdf.write_file
# netcdf.define_one_at_time
netcdf.write_one_at_time

=begin
 public void testWriteRecordOneAtaTime() throws IOException, InvalidRangeException {
    String filename = TestLocal.temporaryDataDir + "testWriteRecord2.nc";
    NetcdfFileWriter writer = NetcdfFileWriter.createNew(NetcdfFileWriter.Version.netcdf3, filename);

    // define dimensions, including unlimited
    Dimension latDim = writer.addDimension(null, "lat", 3);
    Dimension lonDim = writer.addDimension(null, "lon", 4);
    Dimension timeDim = writer.addUnlimitedDimension("time");

    // define Variables
    Variable lat = writer.addVariable(null, "lat", DataType.FLOAT, "lat");
    lat.addAttribute( new Attribute("units", "degrees_north"));

    Variable lon = writer.addVariable(null, "lon", DataType.FLOAT, "lon");
    lon.addAttribute( new Attribute("units", "degrees_east"));

    Variable rh = writer.addVariable(null, "rh", DataType.INT, "time lat lon");
    rh.addAttribute( new Attribute("long_name", "relative humidity"));
    rh.addAttribute( new Attribute("units", "percent"));

    Variable t = writer.addVariable(null, "T", DataType.DOUBLE, "time lat lon");
    t.addAttribute( new Attribute("long_name", "surface temperature"));
    t.addAttribute( new Attribute("units", "degC"));

    Variable time = writer.addVariable(null, "time", DataType.INT, "time");
    time.addAttribute( new Attribute("units", "hours since 1990-01-01"));


    // write out the non-record variables
2)  writer.write(lat, Array.factory(new float[]{41, 40, 39}));
    writer.write(lon, Array.factory(new float[]{-109, -107, -105, -103}));

    //// heres where we write the record variables
    // different ways to create the data arrays.
    // Note the outer dimension has shape 1, since we will write one record at a time
3)  ArrayInt rhData = new ArrayInt.D3(1, latDim.getLength(), lonDim.getLength());
    ArrayDouble.D3 tempData = new ArrayDouble.D3(1, latDim.getLength(), lonDim.getLength());
    Array timeData = Array.factory(DataType.INT, new int[]{1});
    Index ima = rhData.getIndex();

    int[] origin = new int[]{0, 0, 0};
    int[] time_origin = new int[]{0};

    // loop over each record
4)  for (int timeIdx = 0; timeIdx < 10; timeIdx++) {
      // make up some data for this record, using different ways to fill the data arrays.
5.1)  timeData.setInt(timeData.getIndex(), timeIdx * 12);

      for (int latIdx = 0; latIdx < latDim.getLength(); latIdx++) {
        for (int lonIdx = 0; lonIdx < lonDim.getLength(); lonIdx++) {
5.2)      rhData.setInt(ima.set(0, latIdx, lonIdx), timeIdx * latIdx * lonIdx);
5.3)      tempData.set(0, latIdx, lonIdx, timeIdx * latIdx * lonIdx / 3.14159);
        }
      }
      // write the data out for one record
      // set the origin here
6)    time_origin[0] = timeIdx;
      origin[0] = timeIdx;
7)    writer.write(rh, origin, rhData);
      writer.write(t, origin, tempData);
      writer.write(time, time_origin, timeData);
    } // loop over record

    // all done
    writer.close();
  }
=end
