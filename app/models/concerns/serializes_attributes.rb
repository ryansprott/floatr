module SerializesAttributes
  extend ActiveSupport::Concern

  included do
    def serialized_attributes
      attributes.except!("id", "message_id")
    end

    def titleized_attributes
      serialized_attributes
        .keys
        .map(&:titleize)
        .map(&:humanize)
    end
  end
end
