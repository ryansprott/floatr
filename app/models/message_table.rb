class MessageTable
  def initialize(messages)
    @messages = messages
  end

  def specific_headers
    message_specific.titleized_attributes
  end

  def dimension_headers
    message_dimension.titleized_attributes
  end

  def specific_rows
    remove_duplicates(all_specifics)
  end

  def dimension_rows
    remove_duplicates(all_dimensions)
  end

  private

  def message_specific
    @messages.first.specific
  end

  def all_specifics
    @messages.map(&:specific)
  end

  def message_dimension
    @messages.first.dimension
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
