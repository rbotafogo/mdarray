require '../env'
require 'mdarray'

def writer_example
  
  # define the NetCDF-3 file
  NetCDF.define(cygpath("~/tmp"), "testWriter", "netcdf3", self) do

    # add dimensions
    dimension "lat", 64
    dimension "lon", 128
    
    # add variables and attributes
    # add Variable double temperature(lat, lon)
    variable "temperature", "double", [@dim_lat, @dim_lon]
    variable_att @var_temperature, "units", "K"
    variable_att @var_temperature, "scale", [1, 2, 3]

    # add a string-value varaible: char svar(80)
    variable "svar", "string", {:max_strlen => 80}

    # add a 2D string-valued variable: char names(names, 80)
    variable "names", "string", [3], {:max_strlen => 80}

    # add a scalar variable
    variable "scalar", "double"

    # add global attributes
    global_att "yo", "face"
    global_att "versionD", 1.2, "double"
    global_att "versionF", 1.2, "float"
 
  end

end

writer_example

=begin

 public static void main(String[] args) throws IOException {
    String location = "C:/tmp/testWrite.nc";
1)  NetcdfFileWriter writer = NetcdfFileWriter.createNew(NetcdfFileWriter.Version.netcdf3, location, null);

    // add dimensions
2)  Dimension latDim = writer.addDimension(null, "lat", 64);
    Dimension lonDim = writer.addDimension(null, "lon", 128);

    // add Variable double temperature(lat,lon)
    List<Dimension> dims = new ArrayList<Dimension>();
    dims.add(latDim);
    dims.add(lonDim);
3)  Variable t = writer.addVariable(null, "temperature", DataType.DOUBLE, dims);
4)  t.addAttribute(new Attribute("units", "K"));   // add a 1D attribute of length 3
5)  Array data = Array.factory(int.class, new int[]{3}, new int[]{1, 2, 3});
6)  t.addAttribute(new Attribute("scale", data));

    // add a string-valued variable: char svar(80)
    Dimension svar_len = writer.addDimension(null, "svar_len", 80);
7)  writer.addVariable(null, "svar", DataType.CHAR, "svar_len");

    // add a 2D string-valued variable: char names(names, 80)
    Dimension names = writer.addDimension(null, "names", 3);
8)  writer.addVariable(null, "names", DataType.CHAR, "names svar_len");

    // add a scalar variable
9)  writer.addVariable(null, "scalar", DataType.DOUBLE, new ArrayList<Dimension>());

    // add global attributes
10) writer.addGroupAttribute(null, new Attribute("yo", "face"));
    writer.addGroupAttribute(null, new Attribute("versionD", 1.2));
    writer.addGroupAttribute(null, new Attribute("versionF", (float) 1.2));
    writer.addGroupAttribute(null, new Attribute("versionI", 1));
    writer.addGroupAttribute(null, new Attribute("versionS", (short) 2));
    writer.addGroupAttribute(null, new Attribute("versionB", (byte) 3));

    // create the file
    try {
11)    writer.create();
    } catch (IOException e) {
      System.err.printf("ERROR creating file %s%n%s", location, e.getMessage());
    }
12)  writer.close();
  }
=end
