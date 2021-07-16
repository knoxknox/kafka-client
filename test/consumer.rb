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

consumer_options = {
  'group.id' => 'ruby_client',
  'auto.offset.reset' => 'earliest',
  'bootstrap.servers' => 'localhost:9092'
}

Consumer.new(consumer_options).consume('test_updates')
