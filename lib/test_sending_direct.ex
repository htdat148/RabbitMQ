defmodule RabbitMQSendDirect do

  # a list of routing keys and messages
  #[[routing_1|msgs_1], [routing_2|msgs_2]]
  def send(routes_and_msgs) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)

    # declare an exchange that producer connect to
    # type direct
    AMQP.Exchange.declare(channel, "direct_logs", :direct)

    # channel, exchange, routing key, message
    for route_and_msg <- routes_and_msgs do
      [routing| msgs] = route_and_msg
      for msg <- msgs do
        AMQP.Basic.publish(channel, "direct_logs", routing, msg)
        IO.puts "[x] Send #{msg} with routing key #{routing}"
      end
    end
    AMQP.Connection.close(connection)
  end
end