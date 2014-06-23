require 'rbconfig'

# Name of MDArray home dir
$MDARRAY_DIR_NAME = "MDArray"

# set to true if development environment.  Set to false before publishing
$DVLP = true
# set to true if doing coverage analysis
$COVERAGE = false
# Development environment
$DVLP_ENV = 'cygwin'
# Development directory's name
$DVLP_DIR_NAME = "Desenv"

if $DVLP

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
  
  if $DVLP_ENV == 'cygwin'
        
    #---------------------------------------------------------------------------------------
    # Return the cygpath of a path
    #---------------------------------------------------------------------------------------
    
    def set_path(path)
      `cygpath -a -p -m #{path}`.tr("\n", "")
    end
          
  else
    
    #---------------------------------------------------------------------------------------
    # Return  the path
    #---------------------------------------------------------------------------------------
    
    def set_path(path)
      path
    end
    
  end
  
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
  
  $LOAD_PATH << lib
  
end

ENV.each do |val|
  if val[0] == "PWD"
    pwd = set_path(val[1])
    i =  pwd.index($DVLP_DIR_NAME)
    $DVLP_HOME_DIR = pwd.slice(0..(i + $DVLP_DIR_NAME.size - 1))
  end
end


$MDARRAY_HOME_DIR = $DVLP_HOME_DIR + "/" + $MDARRAY_DIR_NAME

# Tmp directory for data storage
$TMP_TEST_DIR = $MDARRAY_HOME_DIR + "/test/tmp"
# MDArray Test directory
$MDARRAY_TEST_DIR = $MDARRAY_HOME_DIR + "/test/mdarray"
# Colt Test directory
$COLT_TEST_DIR = $MDARRAY_HOME_DIR + "/test/colt"
# NetCDF Test directory
$NETCDF_TEST_DIR = $MDARRAY_HOME_DIR + "/test/netcdf"


mklib($MDARRAY_HOME_DIR)

=begin
# RbConfig::CONFIG['host_os'] # returns mswin32 on Windows, for example
# p Config::CONFIG

ENV.each do |val|
  p val
end

=end

=begin
# Build Jruby classpath from environment classpath
ENV['WCLASSPATH'].split(';').each do |path|
$CLASSPATH << cygpath(path)
end
=end

