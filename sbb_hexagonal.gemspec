$:.push File.expand_path("../lib", __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sbb_hexagonal/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|

  spec.name          = 'sbb-hexagonal'
  spec.version       = SbbHexagonal::VERSION
  spec.authors       = ['Sean Chatterton']
  spec.email         = ['sean.chatterton@sbbsoftware.com']
  spec.summary       = %q{Tutorial code for Hexagonal Rails Article}
  spec.description       = %q{Tutorial code for Hexagonal Rails Article}
  spec.homepage      = 'http://www.sbbsoftware.com'
  spec.license       = 'MIT'

  # spec.files         = `git ls-files -z`.split("\x0")
  # spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  # spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.metadata['allowed_push_host'] = 'https://notyetready.sbbsoftware.com'


  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  spec.test_files = Dir['test/**/*']
  spec.add_dependency 'rails', '>= 4.2.1'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'pg'
end

