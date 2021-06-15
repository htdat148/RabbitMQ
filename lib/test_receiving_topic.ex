defmodule RabbitMQReceiveTopic do
  # each queue is bound to a queue
  def receive_messages(topics) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)

    # can be declared or not
    AMQP.Exchange.declare(channel, "topic_logs", :topic)
    {:ok, %{queue: queue_name}} = AMQP.Queue.declare(channel, "", exclusive: true)

    # IO.puts "Queue #{queue_name} was created"
    for topic <- topics do
      AMQP.Queue.bind(channel, queue_name, "topic_logs", routing_key: topic)
      IO.puts " [*] Waiting for messages with topic #{topic}."
    end


    AMQP.Basic.consume(channel, queue_name, nil, no_ack: true)

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