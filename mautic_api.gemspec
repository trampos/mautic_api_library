$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mautic_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mautic_api"
  s.version     = MauticApiLibrary::VERSION
  s.authors     = ["Marcel"]
  s.email       = ["marcel@trampos.co"]
  s.homepage    = "http://trampos.co"
  s.summary     = "Ported from PHP (https://github.com/mautic/api-library). "
  s.description = "This gem allows simple integration with Mautic Api."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

end
