java_import org.apache.kafka.common.PartitionInfo
java_import org.apache.kafka.clients.consumer.KafkaConsumer

module KafkaClient
  class TopicInspector

    def initialize(properties)
      @properties = properties
    end

    def execute(topic)
      result = {}
      consumer = KafkaConsumer.new(@properties)
      partition_list = PartitionList.new(@properties)

      partition_list.fetch(topic).each do |partition|
        result[partition.to_s] = { partition: partition }
      end
      partitions = result.values.map { |x| x[:partition] }

      consumer.assign(partitions)
      end_offsets = consumer.end_offsets(partitions)
      begin_offsets = consumer.beginning_offsets(partitions)

      # Fills partition offsets, and current consumer's offset
      end_offsets.each { |p, offset| result[p.to_s][:end] = offset }
      begin_offsets.each { |p, offset| result[p.to_s][:begin] = offset }
      partitions.each { |p| result[p.to_s][:offset] = consumer.position(p) }

      result.each do |name, meta|
        puts "#{name} => #{meta[:offset]}, [#{meta[:begin]} - #{meta[:end]}]"
      end
    end

  end
end
