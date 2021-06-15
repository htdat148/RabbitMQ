defmodule RabbitMQReceiveDirect do
  # each queue is bound to a queue
  def receive_messages(binding_key) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)

    # can be declared or not
    AMQP.Exchange.declare(channel, "direct_logs", :direct)
    {:ok, %{queue: queue_name}} = AMQP.Queue.declare(channel, "", exclusive: true)

    # IO.puts "Queue #{queue_name} was created"
    AMQP.Queue.bind(channel, queue_name, "direct_logs", routing_key: binding_key)

    AMQP.Basic.consume(channel, queue_name, nil, no_ack: true)
    IO.puts " [*] Waiting for messages with routing key #{binding_key}."
    IO.puts " To exit press CTRL+C, CTRL+C"

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