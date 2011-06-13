# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "smart_mta/version"

Gem::Specification.new do |s|
  s.name        = "smart_mta"
  s.version     = SmartMta::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Duff"]
  s.email       = ["john.duff@shopify.com"]
  s.homepage    = ""
  s.summary     = %q{Integrate with the SmartMta API.}
  s.description = %q{Provides integration with the SmartMTA API.}

  s.rubyforge_project = "smart_mta"

  s.add_runtime_dependency("httparty")
  s.add_development_dependency("fakeweb")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
