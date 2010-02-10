require 'jeweler'
require 'yard'

YARD::Rake::YardocTask.new

Jeweler::Tasks.new do |gem|
  gem.name        = 'ketchup'
  gem.summary     = "A place for all your meeting notes"
  gem.description = 'A Ruby interface to the API for Ketchup'
  gem.email       = 'paul@rushedsunlight.com'
  gem.homepage    = 'http://github.com/hypertiny/ketchup'
  gem.authors     = ['Pat Allan', 'Paul Campbell']
  
  gem.add_dependency 'httparty', '0.5.2'
  
  gem.add_development_dependency "rspec", ">= 1.2.9"
  gem.add_development_dependency "yard",  ">= 0.5.3"
  
  gem.files = FileList[
    'lib/**/*.rb',
    'LICENCE',
    'README.textile'
  ]
  # gem is a Gem::Specification...
  # See http://www.rubygems.org/read/chapter/20 for additional settings
end

Jeweler::GemcutterTasks.new
