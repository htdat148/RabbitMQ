defmodule RabbitMQReceive do
  def receive_messages do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)

#    AMQP.Exchange.declare(channel, "logs", :fanout)
    {:ok, %{queue: queue_name}} = AMQP.Queue.declare(channel, "", exclusive: true)
    IO.puts "Queue #{queue_name} was created"
    AMQP.Queue.bind(channel, queue_name, "logs")

    AMQP.Basic.consume(channel, queue_name, nil, no_ack: true)
    IO.puts " [*] Waiting for messages. To exit press CTRL+C, CTRL+C"

    wait_for_messages(channel)

  end

  def wait_for_messages(channel) do
    receive do
      {:basic_deliver, payload, _meta } ->
        IO.puts "[x] Received #{payload}"
        wait_for_messages(channel)
    end
  end
end