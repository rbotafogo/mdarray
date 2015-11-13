require 'rbconfig'
require 'java'

##########################################################################################
# Configuration. Remove setting before publishing Gem.
##########################################################################################

# set to true if development environment
$DVLP = true

# Set development dependency: those are gems that are also in development and thus not
# installed in the gem directory.  Need a way of accessing them
$DVLP_DEPEND=["mdarray"]

# Set dependencies from other local gems provided in the vendor directory. 
$VENDOR_DEPEND=[]

##########################################################################################

# the platform
@platform = 
  case RUBY_PLATFORM
  when /mswin/ then 'windows'
  when /mingw/ then 'windows'
  when /bccwin/ then 'windows'
  when /cygwin/ then 'windows-cygwin'
  when /java/
    require 'java' #:nodoc:
    if java.lang.System.getProperty("os.name") =~ /[Ww]indows/
      'windows-java'
    else
      'default-java'
    end
  else 'default'
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
  
  $LOAD_PATH.insert(0, lib)

end

##########################################################################################
# Prepare environment to work inside Cygwin
##########################################################################################

if @platform == 'windows-cygwin'
  
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

#---------------------------------------------------------------------------------------
# Set the project directories
#---------------------------------------------------------------------------------------

class MDArray

  @home_dir = File.expand_path File.dirname(__FILE__)

  class << self
    attr_reader :home_dir
  end

  @project_dir = MDArray.home_dir + "/.."
  @doc_dir = MDArray.home_dir + "/doc"
  @lib_dir = MDArray.home_dir + "/lib"
  @src_dir = MDArray.home_dir + "/src"
  @target_dir = MDArray.home_dir + "/target"
  @test_dir = MDArray.home_dir + "/test"
  @vendor_dir = MDArray.home_dir + "/vendor"
  
  class << self
    attr_reader :project_dir
    attr_reader :doc_dir
    attr_reader :lib_dir
    attr_reader :src_dir
    attr_reader :target_dir
    attr_reader :test_dir
    attr_reader :vendor_dir
  end

  @build_dir = MDArray.src_dir + "/build"

  class << self
    attr_reader :build_dir
  end

  @classes_dir = MDArray.build_dir + "/classes"

  class << self
    attr_reader :classes_dir
  end

end

#---------------------------------------------------------------------------------------
# Set dependencies
#---------------------------------------------------------------------------------------

def depend(name)
  
  dependency_dir = MDArray.project_dir + "/" + name
  mklib(dependency_dir)
  
end

$VENDOR_DEPEND.each do |dep|
  vendor_depend(dep)
end if $VENDOR_DEPEND

##########################################################################################
# Config gem
##########################################################################################

if ($DVLP == true)

  #---------------------------------------------------------------------------------------
  # Set development dependencies
  #---------------------------------------------------------------------------------------
  
  def depend(name)
    dependency_dir = MDArray.project_dir + "/" + name
    mklib(dependency_dir)
  end

  # Add dependencies here
  # depend(<other_gems>)
  $DVLP_DEPEND.each do |dep|
    depend(dep)
  end if $DVLP_DEPEND

  #----------------------------------------------------------------------------------------
  # If we need to test for coverage
  #----------------------------------------------------------------------------------------
  
  if $COVERAGE == 'true'
  
    require 'simplecov'
    
    SimpleCov.start do
      @filters = []
      add_group "MDArray", "lib/mdarray"
      add_group "Colt", "lib/colt"
      add_group "NetCDF", "lib/netcdf"
    end
    
  end

end

##########################################################################################
# Load necessary jar files
##########################################################################################

#Dir["#{File.dirname(__FILE__)}/vendor/*.jar"].each do |jar|
Dir["#{MDArray.vendor_dir}/*.jar"].each do |jar|
  require jar
end

Dir["#{MDArray.target_dir}/*.jar"].each do |jar|
  require jar
end

##########################################################################################
# Tmp directory for data storage
##########################################################################################

$TMP_TEST_DIR = MDArray.home_dir + "/test/tmp"
#Colt test directory
$COLT_TEST_DIR = MDArray.home_dir + "/test/colt"
# NetCDF test directory
$NETCDF_TEST_DIR = MDArray.home_dir + "/test/netcdf"
