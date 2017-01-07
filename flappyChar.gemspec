Gem::Specification.new { |s|
  s.name = "flappyChar"
  s.version = "1.0.0"
  s.author = ["Thomas Ruehrig"]
  s.homepage = "https://github.com/TheRealVira/FlappyChar"
  s.platform = Gem::Platform::RUBY
  s.summary = "A \"Flappy Bird\" clone; reprogrammed with Ruby (runs on the terminal)."
  s.files = Dir.glob('{game}/**/*') + ['README.md', 'LICENSE']
  s.required_ruby_version = Gem::Requirement.new('>= 2.1.0')
  s.licenses = ['Ruby', 'MIT']
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake-compiler'
}