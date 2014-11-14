# -*- coding: utf-8 -*-
require 'rubygems/platform'

require_relative 'version'


Gem::Specification.new do |gem|

  gem.name    = $gem_name
  gem.version = $version
  gem.date    = Date.today.to_s

  gem.summary     = "Multi dimensional array similar to narray and numpy."
  gem.description = <<-EOF 
"MDArray is a multi dimensional array implemented for JRuby inspired by NumPy (www.numpy.org) and 
Masahiro Tanaka´s Narray (narray.rubyforge.org).  MDArray stands on the shoulders of Java-NetCDF 
and Parallel Colt.  At this point MDArray has libraries for linear algebra, mathematical, 
trigonometric and descriptive statistics methods.

NetCDF-Java Library is a Java interface to NetCDF files, as well as to many other types of 
scientific data formats.  It is developed and distributed by Unidata (http://www.unidata.ucar.edu). 

Parallel Colt (http://grepcode.com/snapshot/repo1.maven.org/maven2/net.sourceforge.parallelcolt/
parallelcolt/0.10.0/) is a multithreaded version of Colt (http://acs.lbl.gov/software/colt/).  
Colt provides a set of Open Source Libraries for High Performance Scientific and Technical 
Computing in Java. Scientific and technical computing is characterized by demanding problem 
sizes and a need for high performance at reasonably small memory footprint."

For more information and (some) documentation please go to: https://github.com/rbotafogo/mdarray/wiki
EOF

  gem.authors  = ['Rodrigo Botafogo']
  gem.email    = 'rodrigo.a.botafogo@gmail.com'
  gem.homepage = 'http://github.com/rbotafogo/mdarray/wiki'
  gem.license = 'BSD 2-clause'

  gem.add_dependency('map', [">= 6.3.0"])
  gem.add_dependency('shoulda')
  gem.add_development_dependency('simplecov', [">= 0.7.1"])
  gem.add_development_dependency('yard', [">= 0.8.5.2"])
  gem.add_development_dependency('kramdown', [">= 1.0.1"])

  # ensure the gem is built out of versioned files
  gem.files = Dir['Rakefile', 'version.rb', 'config.rb', '{lib,test}/**/*.rb', 'test/**/*.csv',
                  'test/**/*.xlsx',
                  '{bin,doc,spec,vendor,target}/**/*', 
                  'README*', 'LICENSE*'] # & `git ls-files -z`.split("\0")

  gem.test_files = Dir['test/*.rb']

  gem.platform='java'

end
