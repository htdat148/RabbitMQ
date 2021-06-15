defmodule RabbitMQSendTopic do

  # a list of routing keys and messages
  #[[topic_1|msgs_1], [topic_2|msgs_2]]
  def send(topics_and_msgs) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)

    # declare an exchange that producer connect to
    # type topic
    AMQP.Exchange.declare(channel, "topic_logs", :topic)

    # channel, exchange, routing key, message
    for topic_and_msg <- topics_and_msgs do
      [topic| msgs] = topic_and_msg
      for msg <- msgs do
        AMQP.Basic.publish(channel, "topic_logs", topic, msg)
        IO.puts "[x] Send #{msg} with topic #{topic}"
      end
    end
    AMQP.Connection.close(connection)
  end
end