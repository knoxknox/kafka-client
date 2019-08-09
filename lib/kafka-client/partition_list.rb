java_import org.apache.kafka.common.PartitionInfo
java_import org.apache.kafka.common.TopicPartition
java_import org.apache.kafka.clients.consumer.KafkaConsumer

module KafkaClient
  class PartitionList

    def initialize(properties)
      @properties = properties
    end

    def fetch(topic)
      consumer = KafkaConsumer.new(@properties)
      partitions = consumer.partitions_for(topic)
      partitions.map { |x| TopicPartition.new(topic, x.partition) }
    end

  end
end
