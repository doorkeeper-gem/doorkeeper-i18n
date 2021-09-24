require "bundler"
require "rake"
require "rspec/core"
require "rspec/core/rake_task"
require "yaml"

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList["spec/**/*_spec.rb"]
end

def en_locale
  @en_locale ||= YAML.load_file(File.join("rails", "locales", "en.yml"))
end

def merge_locales(source, target)
  source.inject({}) do |locale, (key, value)|
    if value.is_a?(Hash)
      locale[key] = merge_locales(value, target[key] || {})
    else
      locale[key] = target[key].nil? ? source[key] : target[key]
    end

    locale
  end
end

task default: :spec

task :fill do
  Dir.glob(File.join("rails", "locales", "*.yml")).each do |file|
    next if File.basename(file) == "en.yml"

    puts "Processing #{File.basename(file)}"

    locale = YAML.load_file(file)
    lang = locale.keys.first.dup

    merged_locale = merge_locales(en_locale.fetch("en"), locale.fetch(lang))

    File.open(file, "w") do |f|
      f.write(YAML.dump({ lang => merged_locale }, line_width: -1).gsub("---\n", ''))
    end
  end
end