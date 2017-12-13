
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "statistic_calcs/version"

Gem::Specification.new do |spec|
  spec.name          = "statistic_calcs"
  spec.version       = StatisticCalcs::VERSION
  spec.authors       = ["matt"]
  spec.email         = ["matiasberrueta@gmail.com"]

  spec.summary       = %q{A gem for statistic calculations.}
  spec.description   = %q{This gem aim to calculate descriptive and inferential statistics calc.}
  spec.homepage      = "https://github.com/mberrueta/statistic_calcs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
