require 'java'
require 'forwardable'

java_import org.apache.kafka.clients.producer.KafkaProducer
java_import org.apache.kafka.clients.producer.ProducerConfig
java_import org.apache.kafka.clients.producer.ProducerRecord
java_import org.apache.kafka.common.serialization.StringSerializer
java_import org.apache.kafka.common.serialization.ByteArraySerializer

##
# JRuby Kafka producer.
# https://kafka.apache.org/11/javadoc/org/apache/kafka/clients/producer/package-summary.html
#
# Example usage:
#   require 'kafka-client'
#
#   producer = KafkaClient::Producer.new('localhost:9092', 'test')
#   producer.produce('topic-name', 'key-of-record1', 'value-of-record1')
#   producer.produce('topic-name', 'key-of-record2', 'value-of-record2')
#   producer.close
#
# Please note that producer should be closed when application is finished.
#
module KafkaClient
  class Producer
    extend Forwardable
    def_delegators :@producer, :flush, :close

    def initialize(servers, client_id, options = {})
      @servers = servers
      @options = options
      @client_id = client_id
      @config = Config.new(ProducerConfig)
    end

    ##
    # Asynchronously send a record to a topic.
    #
    # @param topic [String] The topic the record will be appended to
    # @param key [Object] The key that will be included in the record
    # @param value [Object] The record contents (can be serializable object)
    # @return [Future<RecordMetadata>] Future that can be solved to posted record info
    #
    def produce(topic, key, value)
      producer = init_producer
      key = serialize(key, @config.properties['key.serializer'])
      value = serialize(value, @config.properties['value.serializer'])

      producer.send(ProducerRecord.new(topic, key, value))
    end


    private

    def init_producer
      @producer ||= KafkaProducer.new(config)
    end

    def config
      opts = default_options.merge(@options)
      opts.each { |name, value| @config.add(name.to_s, value) }
    end

    def default_options
      {
        'acks' => 'all',
        'client.id' => @client_id,
        'retries' => 5.to_java(:int),
        'bootstrap.servers' => @servers.join(','),
        'max.request.size' => 10485760.to_java(:int),
        'key.serializer' => ByteArraySerializer.java_class,
        'value.serializer' => ByteArraySerializer.java_class
      }
    end

    def serialize(object, serializer)
      result = object.respond_to?(:serialize) ? object.serialize : object.to_s
      result = result.to_java_bytes if ByteArraySerializer.java_class == serializer

      result
    end

  end
end
