class Message < ApplicationRecord
  has_one :course, dependent: :destroy
  has_one :dimension, dependent: :destroy
  has_one :mystery, dependent: :destroy
  has_one :position, dependent: :destroy
  has_one :type_cnb_specific, dependent: :destroy
  has_one :type_5_specific, dependent: :destroy
  has_one :type_7_specific, dependent: :destroy
  has_one :type_8_specific, dependent: :destroy
  has_one :type_9_specific, dependent: :destroy
  has_one :type_10_specific, dependent: :destroy
  has_one :type_15_specific, dependent: :destroy
  has_one :type_18_specific, dependent: :destroy
  has_one :type_21_specific, dependent: :destroy
  has_one :type_24_specific, dependent: :destroy
  has_one :type_27_specific, dependent: :destroy

  validates_uniqueness_of :source_mmsi, if: -> do
    [4, 21].include? message_type
  end

  def lat_lon
    position&.to_s || "Not provided"
  end

  def specific
    send specific_type
  end

  def build_specific(payload)
    send "build_#{specific_type}", payload
  end

  def specific_type
    case message_type
    when 1..3
      "type_cnb_specific"
    else
      "type_#{message_type.to_s}_specific"
    end
  end
end
