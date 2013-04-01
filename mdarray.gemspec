require_relative 'version'

Gem::Specification.new do |gem|

  gem.name    = $gem_name
  gem.version = $version
  gem.date    = Date.today.to_s

  gem.summary     = "Multi dimensional array similar to narray and numpy."
  gem.description = "Multi dimensional array similar to narray and numpy."

  gem.authors  = ['Rodrigo Botafogo']
  gem.email    = 'rodrigo.a.botafogo@gmail.com'
  gem.homepage = ''

  gem.add_dependency('rake')
  gem.add_development_dependency('rspec', [">= 2.0.0"])

  # ensure the gem is built out of versioned files
  gem.files = Dir['Rakefile', 'version.rb', '{lib,test}/**/*.rb', '{bin,man,spec,vendor}/**/*', 
                  'README*', 'LICENSE*'] # & `git ls-files -z`.split("\0")


end
