Gem::Specification.new do |s|
  s.name        = 'boathook'
  s.version     = '1.0.0-dev'
  s.summary     = "Docker Rake Tasks"
  s.description = "Rake tasks for building and pushing Docker images."
  s.authors     = ['University of Maryland Libraries']
  s.email       = 'lib-ssdr@umd.edu',
  s.files       = ["lib/boathook.rb"]
  s.homepage    = 'https://github.com/umd-lib'
  s.license     = 'Apache-2.0'
  s.require_paths = ["lib"]
  s.add_dependency 'mattock', '~> 0.5.2'
end
