# Add path to CLASSPATH

def add_path(path)

  $CLASSPATH << `cygpath -p -m #{path}`.tr("\n", "")

end

add_path("../vendor/netcdfAll-4.3.16.jar")
add_path(":../vendor/parallelcolt-0.9.4.jar")
add_path(":../target/mdarray_helper.jar")
