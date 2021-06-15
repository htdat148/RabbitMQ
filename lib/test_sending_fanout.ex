defmodule RabbitMQSend do
  def send(messages) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)

    # declare an exchange that producer connect to
    AMQP.Exchange.declare(channel, "logs", :fanout)

    # channel, exchange, routing key, message
    for message <- messages do
      AMQP.Basic.publish(channel, "logs", "", message)
      IO.puts "[x] Send #{message}"

    end
    AMQP.Connection.close(connection)
  end
end