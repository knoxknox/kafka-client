build:
	bundle install
	bundle exec rake install_jars

install:
	rm -f kafka-client-*-java.gem
	gem uninstall --all kafka-client

	gem build kafka-client.gemspec
	gem install $$(find . -name kafka-client-*.gem) --no-document

consumer_test:
	jruby -J-Dorg.slf4j.simpleLogger.defaultLogLevel=INFO test/consumer.rb

producer_test:
	jruby -J-Dorg.slf4j.simpleLogger.defaultLogLevel=INFO test/producer.rb
