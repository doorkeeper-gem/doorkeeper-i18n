$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |gem|
  gem.name = "doorkeeper-i18n"
  gem.version = "5.2.2"
  gem.authors = ["Tute Costa", "Nikita Bulai"]
  gem.email = %w[bulaj.nikita@gmail.com]
  gem.homepage = "https://github.com/doorkeeper-gem/doorkeeper-i18n"
  gem.summary = "Translations for doorkeeper rubygem."
  gem.description = "Translations for doorkeeper rubygem."
  gem.license = "MIT"

  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- test/*`.split("\n")
  gem.require_paths = ["lib"]

  gem.metadata = {
    "homepage_uri" => "https://github.com/doorkeeper-gem/doorkeeper-i18n",
    "source_code_uri" => "https://github.com/doorkeeper-gem/doorkeeper-i18n",
    "bug_tracker_uri" => "https://github.com/doorkeeper-gem/doorkeeper-i18n/issues",
  }

  gem.add_runtime_dependency "doorkeeper", ">= 5.2"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "i18n-spec", "~> 0.6.0"
  gem.add_development_dependency "railties", ">= 0"
end
