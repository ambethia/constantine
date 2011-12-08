# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "constantine/version"

Gem::Specification.new do |s|
  s.name        = "constantine"
  s.version     = Constantine::VERSION
  s.authors     = ["Jason L Perry"]
  s.email       = ["jasper@ambethia.com"]
  s.homepage    = "http://github.com/ambethia/constantine"
  s.summary     = %q{Experimental constantizing}
  s.description = %q{Looks further than the obvious when trying to create a constant from a string}

  s.rubyforge_project = "constantine"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "activesupport"
  s.add_development_dependency "i18n"
end
