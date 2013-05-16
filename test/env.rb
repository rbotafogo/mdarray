require 'rbconfig'

# Home directory for MDArray
$MDARRAY_HOME_DIR = ".."

# MDArray Test directory
$MDARRAY_TEST_DIR = "./mdarray"

# Colt Test directory
$COLT_TEST_DIR = "./colt"

##########################################################################################
# If we need to test for coverage
##########################################################################################

if ENV['COVERAGE'] == 'true'

  require 'simplecov'
  
  SimpleCov.start do
    @filters = []
    add_group "MDArray", "lib/mdarray"
    add_group "Colt", "lib/colt"
  end

end

##########################################################################################
# Prepare environment to work inside Cygwin
##########################################################################################

if ENV['MDARRAY_ENV'] == 'cygwin'

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
  
end

=begin
# Build Jruby classpath from environment classpath
ENV['WCLASSPATH'].split(';').each do |path|
$CLASSPATH << cygpath(path)
end
=end

