class Message < ActiveRecord::Base
  belongs_to :source, foreign_key: :source_mmsi, primary_key: :mmsi

  has_one :course, dependent: :destroy
  has_one :dimension, dependent: :destroy
  has_one :mystery, dependent: :destroy
  has_one :position, dependent: :destroy

  has_one :type_cnb_specific, dependent: :destroy
  has_one :type_4_specific, dependent: :destroy
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

  alias_attribute :type, :message_type
  alias_attribute :mmsi, :source_mmsi

  delegate_missing_to :specific

  validates_uniqueness_of :source_mmsi, if: -> do
    [4, 21].include? message_type
  end

  def self.recent
    where(created_at: 5.minutes.ago..)
    .includes(:source, :position, :course)
    .order(:updated_at)
    .group_by(&:mmsi)
  end

  def self.weighted_by_position
    includes(:position)
    .select(&:position)
    .group_by(&:lat_lon)
    .map { |mmsi, positions|
      [mmsi, positions.length]
    }
  end

  def self.with_courses
    includes(:position, :course)
    .order(:created_at)
    .pluck(
      :latitude,
      :longitude,
      :course_over_ground,
      :speed_over_ground,
    )
  end

  scope :details_by_type, -> (type) {
    where(type: type.to_i)
    .includes(
      "type_#{type}_specific".to_sym,
      :course,
      :dimension,
    )
  }

  def lat_lon
    position&.to_s || ""
  end

  def specific
    send mystery.present? ? "mystery" : specific_type
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

  def specific_attributes
    specific.attributes.except!("id", "message_id")
  end

  def dimension_attributes
    dimension.attributes.except!("id", "message_id")
  end
end
