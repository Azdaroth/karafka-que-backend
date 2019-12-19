lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "karafka/que/backend"

Gem::Specification.new do |spec|
  spec.name          = "karafka-que-backend"
  spec.version       = Karafka::Que::Backend::VERSION
  spec.authors       = ["Karol Galanciak"]
  spec.email         = ["karol.galanciak@gmail.com"]

  spec.summary       = %q{Karafka Que Backend}
  spec.description   = %q{Karafka Que Backend, mostly for loadbalancing and parallelization when you don't care about ordering of the messages}
  spec.homepage      = "https://github.com/Azdaroth/karafka-que-backend"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 11.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "karafka", "~> 1.3.0"
  spec.add_dependency "que", "~> 1.0.0.beta"
  spec.required_ruby_version = ">= 2.6.0"
end
