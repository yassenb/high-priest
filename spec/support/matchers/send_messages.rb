RSpec::Matchers.define :send_messages do |method, messages|
  match do |controller|
    controller.__send__(method)
    @actual = controller.sent_messages.to_set
    @expected = messages.to_set
    @actual.eql? @expected
  end

  failure_message_for_should do
    not_sent = pretty_print_messages(@expected - @actual)
    extra_sent = pretty_print_messages(@actual - @expected)
    (not_sent.empty? ? "" : "expected messages not sent:\n  #{not_sent}") +
      (extra_sent.empty? ? "" : "\nunexpected messages sent:\n  #{extra_sent}")
  end

  diffable

  def pretty_print_messages(messages)
    messages.map { |message| pretty_print_message message }.join("\n  ")
  end

  def pretty_print_message(message)
    sender, message = message
    "#{sender.username}: #{message}"
  end
end
