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

  s.add_dependency 'railties', '~> 5.0', '>= 5.0.7'
  s.add_dependency "activesupport", "~> 5.0", ">= 5.0.7"
  s.add_development_dependency "rails", "~> 5.0", ">= 5.0.7"
  s.add_development_dependency "bundler", "~> 2.1"
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'tapout', '~> 0.4'
  s.add_development_dependency 'rspec-ontap', '~> 0.3'
end
