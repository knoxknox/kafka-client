require 'java'

java_import java.util.Arrays
java_import org.slf4j.LoggerFactory
java_import org.apache.kafka.clients.consumer.KafkaConsumer
java_import org.apache.kafka.clients.consumer.ConsumerConfig
java_import org.apache.kafka.clients.consumer.ConsumerRecord
java_import org.apache.kafka.clients.consumer.ConsumerRecords

##
# JRuby Kafka consumer.
# Can work as: 'at-most-once' / 'at-least-once'.
# See: https://kafka.apache.org/documentation/#semantics
# https://kafka.apache.org/11/javadoc/org/apache/kafka/clients/consumer/package-summary.html
#
# Semantics: at-most-once
# To get to this behavior set:
# `enable.auto.commit` => true
# `auto.commit.interval.ms` => lower time-frame (ex: 1000)
# Implement method `after_process_hook` as noop (should do nothing).
#
# Semantics: at-least-once
# To get to this behavior set:
# `enable.auto.commit` => true
# `auto.commit.interval.ms` => higher time-frame (ex: 9999999999)
# Implement method `after_process_hook` with `consumer.commit_sync`.
#
# Description of each semantics:
#
# at-most-once - The commit interval passes and Kafka commits the offset,
# but client did not complete the processing of the message and client crashes.
# Now when client restarts it looses the committed message.
#
# at-least-once - Client processed a message and committed to its persistent store.
# But the Kafka commit interval is NOT passed and Kafka could not commit the offset.
# At this point clients dies, now when client restarts it re-process the same message again.
#
module KafkaClient
  class Consumer

    def initialize(opts = {})
      @opts = opts
      @consumer = nil
      @config = Config.new(ConsumerConfig)
    end

    def consume(topic)
      props = init_properties
      @consumer = KafkaConsumer.new(props)
      @consumer.subscribe(Arrays.as_list(topic))

      consume_records
    rescue => ex
      handle_exception(ex)
    ensure
      @consumer && @consumer.close
    end

    def process(record)
    end

    def after_process(consumer)
    end

    def handle_exception(exception)
      @logger ||= LoggerFactory.get_logger(self.class.name)
      @logger.error("Exception occurred in consume: #{exception}")
    end


    private

    def consume_records
      while true
        records = @consumer.poll(1000)
        records.each { |record| process(record) }

        after_process(@consumer) if !records.empty?
      end
    end

    def init_properties
      default_properties!
      @opts.each do |name, value|
        @config.add(name.to_s, value)
      end

      @config.properties
    end

    def default_properties!
      @config.add('enable.auto.commit', 'true')
      @config.add('auto.commit.interval.ms', '1000')
      @config.add('key.deserializer', default_deserializer)
      @config.add('value.deserializer', default_deserializer)
    end

    def default_deserializer
      Java::JavaClass.for_name('org.apache.kafka.common.serialization.StringDeserializer')
    end

  end
end
