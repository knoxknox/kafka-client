java_import org.apache.kafka.common.PartitionInfo
java_import org.apache.kafka.clients.consumer.KafkaConsumer
java_import org.apache.kafka.clients.consumer.OffsetAndMetadata

module KafkaClient
  class OffsetReset

    def initialize(properties)
      @properties = properties
    end

    def execute(topic)
      offsets = java.util.HashMap.new
      offset_and_metadata = OffsetAndMetadata.new(0)
      partitions = PartitionList.new(@properties).fetch(topic)
      partitions.each { |x| offsets.put(x, offset_and_metadata) }

      KafkaConsumer.new(@properties).commit_sync(offsets)
    end

  end
end
