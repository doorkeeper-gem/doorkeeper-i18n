$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "doorkeeper-i18n"
  s.version     = "2.0.0"
  s.authors     = ["Tute Costa"]
  s.email       = %w(tutecosta@gmail.com)
  s.homepage    = "https://github.com/doorkeeper-gem/doorkeeper-i18n"
  s.summary     = "Translations for doorkeeper rubygem."
  s.description = "Translations for doorkeeper rubygem."
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "i18n-spec", "~> 0.6.0"
  s.add_development_dependency "railties", ">= 0"
end
