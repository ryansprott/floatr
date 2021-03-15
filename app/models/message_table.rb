class MessageTable
  def initialize(messages)
    @messages = messages
  end

  def has_dimensions?
    header_object("dimension").present?
  end

  def headers(type)
    header_object(type).titleized_attributes
  end

  def specific_rows
    remove_duplicates(all_specifics)
  end

  def dimension_rows
    remove_duplicates(all_dimensions)
  end

  private

  def header_object(type)
    @messages.first.send(type)
  end

  def all_specifics
    @messages.map(&:specific)
  end

  def all_dimensions
    @messages.map(&:dimension)
  end

  def remove_duplicates(messages)
    messages.map(&:serialized_attributes)
      .map(&:values)
      .uniq
  end
end
