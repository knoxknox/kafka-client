# kafka-client

JRuby Kafka client (1.0+)

## Install

Run `gem install kafka-client`.

## Development

1. Clone this repository
2. Install dependencies `make build`
3. Make changes to code base under `lib` folder
4. When you are ready to test gem, run `make install`

## Integration Testing

1. Run `make install` to install gem
2. Open new tab and start consumer `make consumer_test`
3. Open another tab and start producer `make producer_test`

Example output:
```
Producer
INFO - Kafka version : 1.1.1
INFO - Kafka commitId : 98b6346a977495f6
INFO - Cluster ID: w6ANy5ZsScKtBBzjuhVd3g
INFO - [Producer clientId=ruby-kafka] Closing the Kafka producer.

Consumer
INFO - Kafka version : 1.1.1
INFO - Kafka commitId : 98b6346a977495f6
INFO - Cluster ID: w6ANy5ZsScKtBBzjuhVd3g
INFO - [Consumer groupId=ruby-kafka] Joined group with generation 3.
Partition: 4, Value: value with key (Offset=2)
Partition: 8, Value: value without key (Offset=3)
```
