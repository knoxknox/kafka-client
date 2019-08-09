require 'kafka-client'

class Consumer < KafkaClient::Consumer

  ##
  # This is the main function to process message.
  #
  def process(record)
    puts "Partition: #{record.partition}"
    puts "Value: #{record.value} (Offset=#{record.offset})"
  rescue StandardError => ex
    puts "Error occurred while processing current record: #{ex}"
  end

  ##
  # You can use this hook to define logic after processing.
  #
  def after_process(consumer)
  end

  ##
  # @private
  # Test only
  # Resets offsets to 0 for all partitions in the topic.
  # This can be used for tests to read messages from the beginning.
  #
  def reset(topic)
    properties = init_properties
    KafkaClient::OffsetReset.new(properties).execute(topic)
    KafkaClient::TopicInspector.new(properties).execute(topic)
  end

  ##
  # @private
  # Test only
  # Shows positions of offsets for consumer in each partition for given topic.
  #
  def describe(topic)
    properties = init_properties
    KafkaClient::TopicInspector.new(properties).execute(topic)
  end

end

group = 'ruby-kafka'
topic = 'ruby-kafka-test-topic'
brokers = [
  'docker-kafka-0.local.dev:6667',
  'docker-kafka-1.local.dev:6667',
  'docker-kafka-2.local.dev:6667',
  'docker-kafka-3.local.dev:6667',
  'docker-kafka-4.local.dev:6667'
]

Consumer.new('group.id' => group,
  'bootstrap.servers' => brokers.join(','),
  'auto.offset.reset' => 'earliest').consume(topic)
