Gem::Specification.new do |s|
  s.name        = "app_report"
  s.version     = "0.0.3"
  s.description = "Ruby client to AppReport API!"
  s.summary     = "App Report!"
  s.author      = "Lucas D'Avila"
  s.email       = 'lucas@lucasdavi.la'
  s.homepage    = 'https://github.com/simple_services/app_report-ruby'
  s.files       = Dir["{lib/**/*.rb,README.rdoc,test/**/*.rb,Rakefile,*.gemspec,COPYING}"]

  s.add_development_dependency 'minitest', '~> 4.6.1'
  s.add_development_dependency 'minitest-colorize', '~> 0.0.5'
  s.add_development_dependency 'webmock', '~> 1.10.0'

  s.add_dependency 'activesupport'
  s.add_dependency 'simple_signer', '~> 0.0.1'
  s.add_dependency 'faraday', '~> 0.8.6'
  s.add_dependency 'multi_json', '~> 1.0'
end
