$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "biran/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "biran"
  s.version     = Biran::VERSION
  s.authors     = ["javierg", "brlanier", "seancookr"]
  s.email       = ["amcoit@amcoonline.net"]
  s.homepage    = "https://github.com/amco/biran"
  s.summary     = "Helper for generating config generate tasks."
  s.description = "Biran is the guy that will help you generate config files for your rail app."
  s.license     = "MIT"

  s.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "railties"
  s.add_dependency "activesupport"
  s.add_development_dependency "rails"
  s.add_development_dependency "bundler"
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'tapout'
  s.add_development_dependency 'rspec-ontap'
end
