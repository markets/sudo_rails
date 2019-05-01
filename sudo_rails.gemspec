require "./lib/sudo_rails/version"

Gem::Specification.new do |spec|
  spec.name        = "sudo_rails"
  spec.version     = SudoRails::VERSION
  spec.authors     = ["markets"]
  spec.email       = ["srmarc.ai@gmail.com"]
  spec.homepage    = "https://github.com/markets/sudo_rails"
  spec.summary     = "Sudo mode for Rails"
  spec.description = "Protect any Rails action with password confirmation."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 4.2"
  spec.add_dependency "sass-rails"

  spec.add_development_dependency "rspec-rails"
end
