require 'kafka-client'

cid = 'ruby_client'
topic = 'test_updates'
brokers = ['localhost:9092']

producer = KafkaClient::Producer.new(brokers, cid)

producer.produce(topic, nil, 'value without key').get
producer.produce(topic, Time.now.utc.to_s, 'value with key').get

producer.close
