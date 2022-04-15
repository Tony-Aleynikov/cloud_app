require 'bunny'
require 'json'
require '../app/services/change_order_status.rb'

connection = Bunny.new('amqp://guest:guest@rabbitmq')
connection.start

channel = connection.create_channel
queue = channel.queue('change_status_order', auto_delete: true)

queue.subscribe do |_delivery_info, _metadata, payload|
  data = JSON.parse(payload) #=> { order_id: <id>, status: <status> }
  puts "success1 #{data}"
  ChangeOrderStatus.call(data)
  puts "success2"
end

Signal.trap('INT') do
  puts 'exiting INT'
  connection.close
end

Signal.trap('TERM') do
  puts 'killing TERM'
  connection.close
end

loop do
  sleep
end
