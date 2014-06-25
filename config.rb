require 'rbconfig'

$DVLP = true

# Development environment.  Set to 'cygwin' when in cygwin
$ENV = 'cygwin'

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

##########################################################################################
# Prepare environment to work inside Cygwin
##########################################################################################

if $ENV == 'cygwin'
  
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

  
##########################################################################################
# Prepare dependencies
##########################################################################################

#---------------------------------------------------------------------------------------
# Set the project directory
#---------------------------------------------------------------------------------------

def project_dir(name)
  ENV.each do |val|
    if val[0] == "PWD"
      pwd = set_path(val[1])
      i =  pwd.index(name)
      $PROJECT_DIR = pwd.slice(0..(i + name.size - 1))
    end
  end
end

#---------------------------------------------------------------------------------------
# Set the project directories
#---------------------------------------------------------------------------------------

def home_dirs(name)
  
  $HOME_DIR = $PROJECT_DIR + "/" + name
  
  $DOC_DIR = $HOME_DIR + "/doc"
  $LIB_DIR = $HOME_DIR + "/lib"
  $SRC_DIR = $HOME_DIR + "/src"
  $TARGET_DIR = $HOME_DIR + "/target"
  $TEST_DIR = $HOME_DIR + "/test"
  $VENDOR_DIR = $HOME_DIR + "/vendor"
  
  $BUILD_DIR = $SRC_DIR + "/build"
  $CLASSES_DIR = $BUILD_DIR + "/classes"
  
  mklib($PROJECT_DIR + "/" + name)
  
end

#---------------------------------------------------------------------------------------
# Set dependencies
#---------------------------------------------------------------------------------------

def depend(name)
  
  $VENDOR_DIR = $VENDOR_DIR + ";" + $PROJECT_DIR + "/" + name + "/vendor"
  mklib($PROJECT_DIR + "/" + name)
  
end

##########################################################################################
# If we need to test for coverage
##########################################################################################

if $COVERAGE == 'true'
  
  require 'simplecov'
  
  SimpleCov.start do
    @filters = []
    add_group "SciCom", "lib/scicom"
  end
  
end

##########################################################################################
# Config gem
##########################################################################################

# first thing to do: define project directory: $PROJECT_DIR by calling project_dir
project_dir("Desenv")
# set directories for the project
home_dirs("MDArray")


if ($DVLP == true)
  # Add dependencies here
  # depend("MDArray")
end

