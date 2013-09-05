require 'rbconfig'

=begin
ENV.each do |val|
  p val
end
=end

# Home directory for MDArray.
if $INSTALL_DIR
  $MDARRAY_HOME_DIR = $INSTALL_DIR
else
  $MDARRAY_HOME_DIR = ".."
end  

# MDArray Test directory
$MDARRAY_TEST_DIR = "./mdarray"

# Colt Test directory
$COLT_TEST_DIR = "./colt"

# Tmp directory
$TMP_TEST_DIR = "./tmp"

# Need to change this variable before publication
$MDARRAY_ENV = 'cygwin'

##########################################################################################
# If we need to test for coverage
##########################################################################################

if $COVERAGE == 'true'

  require 'simplecov'
  
  SimpleCov.start do
    @filters = []
    add_group "MDArray", "lib/mdarray"
    add_group "Colt", "lib/colt"
    add_group "NetCDF", "lib/netcdf"
  end

end

##########################################################################################
# Prepare environment to work inside Cygwin
##########################################################################################

if $MDARRAY_ENV == 'cygwin'

  # RbConfig::CONFIG['host_os'] # returns mswin32 on Windows, for example
  # p Config::CONFIG
  
  #---------------------------------------------------------------------------------------
  # Return the cygpath of a path
  #---------------------------------------------------------------------------------------

  def cygpath(path)
    `cygpath -a -p -m #{path}`.tr("\n", "")
  end

  #---------------------------------------------------------------------------------------
  # Add path to load path
  #---------------------------------------------------------------------------------------

  def mklib(path, home_path = true)
    
    if (home_path)
      lib = path + "/lib"
    else
      lib = path
    end
    
    $LOAD_PATH << `cygpath -p -m #{lib}`.tr("\n", "")
    
  end
      
  mklib($MDARRAY_HOME_DIR)

  $MDARRAY_TEST_DIR = cygpath($MDARRAY_TEST_DIR)
  $COLT_TEST_DIR = cygpath($COLT_TEST_DIR)

else

  def cygpath(path)
    path
  end

end

=begin
# Build Jruby classpath from environment classpath
ENV['WCLASSPATH'].split(';').each do |path|
$CLASSPATH << cygpath(path)
end
=end

