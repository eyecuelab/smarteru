$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'smarteru/version'

Gem::Specification.new do |s|
  s.authors     = [ 'Sasha Shamne', 'EyecueLab' ]
  s.name        = 'smarteru'
  s.version     = Smarteru::VERSION
  s.email       = [ 'alexander.shamne@gmail.com' ]
  s.description = 'Ruby wrapper for Smarteru API'
  s.summary     = 'Allows access to a Smarteru API operations http://help.smarteru.com/'
  s.homepage    = 'http://github.com/eyecuelab/smarteru'
  s.license     = 'MIT'

  s.files = Dir['{lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']
  s.require_paths = [ 'lib' ]

  s.add_dependency('rest-client')
  s.add_dependency('nokogiri')
  s.add_dependency('nori')

  s.add_development_dependency('rdoc')
  s.add_development_dependency('rake')
  s.add_development_dependency('test-unit')
  s.add_development_dependency('multi_json')
  s.add_development_dependency('vcr')
  s.add_development_dependency('webmock')
  s.add_development_dependency('pry')
end
