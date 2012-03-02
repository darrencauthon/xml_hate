# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "xml_hate/version"

Gem::Specification.new do |s|
  s.name        = "xml_hate"
  s.version     = XmlHate::VERSION
  s.authors     = ["Darren Cauthon"]
  s.email       = ["darren@cauthon.com"]
  s.homepage    = ""
  s.summary     = %q{Handling xml with my own ten-foot poll.}
  s.description = %q{I hate xml.}

  s.rubyforge_project = "xml_hate"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency 'xml-simple'
  s.add_runtime_dependency 'hashie'
end
