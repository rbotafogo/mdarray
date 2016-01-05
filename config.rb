require 'rbconfig'
require 'java'

#
# In principle should not be in this file.  The right way of doing this is by executing
# bundler exec, but I don't know how to do this from inside emacs.  So, should comment
# the next line before publishing the GEM.  If not commented, this should be harmless
# anyway.
#

begin
  require 'bundler/setup'
rescue LoadError
end

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

##########################################################################################
# Load necessary jar files
##########################################################################################

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
