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

# Home directory for MultiCell
$MC_HOME_DIR = "/home/zxb3/Desenv/MultiCell"
mklib($MC_HOME_DIR)

# Home directory for NcInterface
$NCI_HOME_DIR = "/home/zxb3/Desenv/NcInterface"
mklib($NCI_HOME_DIR)

# Home directory for BM&F Bovespa files
$BMF_BOVESPA_DIR = "/home/zxb3/Investimentos/SeriesHistoricas/BMF_BOVESPA/"

# Home directory for results
$RESULT_HOME_DIR = $MC_HOME_DIR + "/results/"

=begin
# Build Jruby classpath from environment classpath
ENV['WCLASSPATH'].split(';').each do |path|
  $CLASSPATH << cygpath(path)
end
=end
