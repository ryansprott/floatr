module SerializesAttributes
  extend ActiveSupport::Concern

  included do
    def serialized_attributes
      attributes.except!("id", "message_id")
    end

    def formatted_attributes
      serialized_attributes
        .keys
        .map(&:titleize)
        .map(&:humanize)
        .map { |str| selectively_capitalize(str) }
    end

    private

    def selectively_capitalize(str)
      abbreviations = ["mmsi", "ais", "eta", "imo", "epfd", "gnss"]

      str.split(" ").map { |word|
        abbreviations.include?(word.downcase) ? word.upcase : word
      }.join(" ")
    end
  end
end
