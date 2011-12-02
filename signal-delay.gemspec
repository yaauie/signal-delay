# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "signal-delay"
  s.version     = '0.0.1'
  s.authors     = ["Ryan Biesemeyer"]
  s.email       = ["ryan@yaauie.com"]
  s.homepage    = "https://github.com/simplymeasured/signal-delay"
  s.summary     = %q{Delay signals until after a block is completed.}
  s.description = %q{Queues signals and re-sends them once your block is finished.}

  #s.rubyforge_project = "signal-delay"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'object-channel'
end
