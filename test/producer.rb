require 'kafka-client'

cid = 'ruby-kafka'
topic = 'ruby-kafka-test-topic'
brokers = [
  'docker-kafka-0.local.dev:6667',
  'docker-kafka-1.local.dev:6667',
  'docker-kafka-2.local.dev:6667',
  'docker-kafka-3.local.dev:6667',
  'docker-kafka-4.local.dev:6667'
]

producer = KafkaClient::Producer.new(brokers, cid)

producer.produce(topic, nil, 'value without key').get
producer.produce(topic, Time.now.utc.to_s, 'value with key').get

producer.close
