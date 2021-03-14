class MessageTable
  def initialize(messages)
    @messages = messages
  end

  def header_rows
    @messages
    .first
    .specific_attributes
    .keys
    .map(&:titleize)
    .map(&:humanize)
  end

  def message_rows
    @messages.map(&:specific_attributes)
    .map(&:values)
    .uniq
  end
end
