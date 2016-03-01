require File.join(File.dirname(__FILE__), 'lib', 'text_hyphen_rails', 'version')

Gem::Specification.new do |s|
  s.name        = 'text_hyphen_rails'
  s.version     = TextHyphenRails::VERSION
  s.authors     = 'Thelonius Kort'
  s.summary     = 'text-hyphen integration for Rails/ActiveRecord'
  s.license     = 'Any GPL or MIT'
  s.homepage    = 'https://github.com/tnt/text_hyphen_rails'

  s.files       = Dir['{lib,config}/**/*']

  s.add_runtime_dependency 'rails', '>= 3.1'
  s.add_runtime_dependency 'text-hyphen', '~> 1.4'

  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'rspec-rails', '~> 3.4'
  s.add_development_dependency 'database_cleaner', '~> 1.5'
  s.add_development_dependency 'simplecov', '~> 0.11'
  s.add_development_dependency 'factory_girl_rails', '~> 4.5'
  s.add_development_dependency 'faker', '~> 1.6'
end
