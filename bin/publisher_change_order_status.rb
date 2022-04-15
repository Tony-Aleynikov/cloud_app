require 'bunny'
require 'json'

connection = Bunny.new('amqp://guest:guest@rabbitmq')
connection.start

channel  = connection.create_channel
exchange = channel.default_exchange

queue_name = 'change_status_order'
#ARGV [<order_id>, <status>]
exchange.publish({ order_id: ARGV[0], status: ARGV[1] }.to_json, routing_key: queue_name)
