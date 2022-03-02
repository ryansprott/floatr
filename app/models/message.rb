class Message < ActiveRecord::Base
  belongs_to :source,
    foreign_key: :source_mmsi,
    primary_key: :mmsi,
    counter_cache: true

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
    with_positions
      .includes(:source, :position, :course)
      .order(:updated_at)
      .group_by(&:mmsi)
      .map do |key, value|
      LiveMapMessage.new(key, value)
    end
  end

  def self.with_positions
    where(
      message_type: [1, 2, 3, 9, 18, 21, 27],
      created_at: 15.minutes.ago..
    )
  end

  def self.grouped_by_type
    order(:type).group(:type).count
  end

  def self.with_courses
    includes(:position, :course)
      .order(:created_at)
  end

  def self.details_by_type(type)
    where(type: type.to_i)
      .includes(
        "type_#{type}_specific".to_sym,
        :course,
        :dimension,
      )
  end

  def timestamp_in_words
    updated_at.localtime.to_formatted_s(:short)
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
