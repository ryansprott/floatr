class MessageTable
  def initialize(messages)
    @messages = messages
  end

  def has_dimensions?
    header_object("dimension").present?
  end

  def header(type)
    header_object(type).formatted_attributes
  end

  def rows(type)
    remove_duplicates(all_objects(type))
  end

  private

  def header_object(type)
    @messages.first.send(type)
  end

  def all_objects(type)
    @messages.map(&type.to_sym)
  end

  def remove_duplicates(messages)
    messages.map(&:serialized_attributes)
      .map(&:values)
      .uniq
  end
end
