require 'java'

java_import java.util.Properties

module KafkaClient
  class Config
    attr_reader :properties

    def initialize(config)
      @config = config
      @properties = Properties.new
    end

    def add(name, value)
      validate_name!(name)
      @properties.put(name, value)
    end


    private

    def names
      @names ||= @config::config_names
    end

    def validate_name!(name)
      raise ArgumentError, "Invalid property: #{name}" if !names.contains?(name)
    end

  end
end
