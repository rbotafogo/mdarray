require 'rubygems/platform'

require_relative 'version'


Gem::Specification.new do |gem|

  gem.name    = $gem_name
  gem.version = $version
  gem.date    = Date.today.to_s

  gem.summary     = "Multi dimensional array similar to narray and numpy."
  gem.description = <<-EOF 
"Multi dimensional array similar to Masahiro Tanaka's Narray and NumPy.  
It is specifically targeted to JRuby as it uses Java-NetCDF library as base Array."
EOF

  gem.authors  = ['Rodrigo Botafogo']
  gem.email    = 'rodrigo.a.botafogo@gmail.com'
  gem.homepage = 'http://github.com/rbotafogo/mdarray/wiki'

  gem.add_dependency('map', [">= 6.3.0"])
  gem.add_development_dependency('simplecov', [">= 0.7.1"])
  gem.add_development_dependency('yard', [">= 0.8.5.2"])
  gem.add_development_dependency('kramdown', [">= 1.0.1"])

  # ensure the gem is built out of versioned files
  gem.files = Dir['Rakefile', 'version.rb', '{lib,test}/**/*.rb', 'test/**/*.csv',
                  'test/**/*.xlsx',
                  '{bin,doc,spec,vendor,target}/**/*', 
                  'README*', 'LICENSE*'] # & `git ls-files -z`.split("\0")

  gem.test_files = Dir['test/*.rb']

  gem.platform='java'

end
