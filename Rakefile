require "bundler"
Bundler.setup

gemspec = eval(File.read("rack-newsstand.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["rack-newsstand.gemspec"] do
  system "gem build rack-newsstand.gemspec"
end
