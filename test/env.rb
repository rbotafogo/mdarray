require 'rbconfig'

# Config::CONFIG['host_os'] # returns mswin32 on Windows, for example
# p Config::CONFIG

# Fix environment variable for MultiCell
# Prepare environment to work inside Cygwin

# Return the cygpath of a path
def cygpath(path)
  `cygpath -p -m #{path}`.tr("\n", "")
end

# Add path to load path
def mklib(path, home_path = true)

  if (home_path)
    lib = path + "/lib"
  else
    lib = path
  end

  $LOAD_PATH << `cygpath -p -m #{lib}`.tr("\n", "")

end

# Home directory for MDArray
$MDARRAY_HOME_DIR = "/home/zxb3/Desenv/MDArray"
mklib($MDARRAY_HOME_DIR)

# MDArray Test directory
$MDARRAY_TEST_DIR = "/home/zxb3/Desenv/MDarray/test/mdarray"

# Colt Test directory
$COLT_TEST_DIR = cygpath("/home/zxb3/Desenv/MDarray/test/colt")

=begin
# Build Jruby classpath from environment classpath
ENV['WCLASSPATH'].split(';').each do |path|
  $CLASSPATH << cygpath(path)
end
=end
