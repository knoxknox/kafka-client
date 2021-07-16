require File.expand_path('../lib/kafka-client/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name = 'kafka-client'
  s.license = 'MIT'
  s.version = KafkaClient::VERSION
  s.authors = ['Alex Y.']
  s.email = 'alexandr_y@mail.ru'
  s.summary = 'JRuby Kafka Wrapper'
  s.homepage = 'https://github.com/knoxknox/kafka-client'
  s.description = 'Kafka adapter for JRuby based projects'

  s.platform = 'java'
  s.require_paths = ['lib']
  s.files = Dir['lib/**/*.rb', 'lib/**/*.jar']

  s.add_development_dependency 'rake', '~> 13.0', '>= 13.0.6'
  s.add_development_dependency 'jar-dependencies', '~> 0.4.1'

  s.requirements << 'jar org.slf4j:slf4j-simple, ~> 1.7.25'
  s.requirements << 'jar org.apache.kafka:kafka_2.12, ~> 1.1.1'
  s.requirements << 'jar org.apache.kafka:kafka-clients, ~> 1.1.1'
end
