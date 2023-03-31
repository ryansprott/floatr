class Source < ActiveRecord::Base
  require 'yaml'

  has_many :messages,
           foreign_key: :source_mmsi,
           primary_key: :mmsi
  has_many :courses, through: :messages
  has_many :positions, through: :messages
  has_many :mysteries, through: :messages
  has_many :dimensions, through: :messages

  def self.with_messages
    where('messages_count > 1').
      order(created_at: :desc)
  end

  def self.recently_added
    with_messages.limit(15)
  end

  def self.with_destinations
    with_messages.where.not(last_destination: nil)
  end

  def self.seen_within_last_15_minutes
    with_messages.
      where(updated_at: 15.minutes.ago..).
      length
  end

  def self.seen_within_last_minute
    with_messages.
      where(updated_at: 1.minute.ago..).
      length
  end

  def display_name
    ship_name || callsign || mmsi.to_s || 'Unknown'
  end

  def country_name
    country = parse_country_from_mmsi
    country[:full_name]
  end

  def country_code
    country = parse_country_from_mmsi
    country[:code_2]
  end

  def country_flag
    country_code.tr('A-Z', "\u{1F1E6}-\u{1F1FF}")
  end

  def all_destinations
    messages.
      where(type: 5).
      includes(:type_5_specific).
      references(:type_5_specific).
      map(&:specific).
      pluck(:destination).
      uniq.
      reject(&:blank?).
      sort
  end

  def last_valid_dimension
    dimensions.
      reject(&:totally_invalid?).
      last
  end

  def last_seen
    updated_at.localtime.to_formatted_s(:short)
  end

  def first_seen
    created_at.localtime.to_formatted_s(:short)
  end

  private

  def parse_country_from_mmsi
    mids = YAML.load_file('db/yaml/mids.yml')
    keys = %i(code_2 code_3 code_misc full_name)
    vals = mids[mmsi.to_s[0...3].to_i] || Array.new(4, '')
    [keys, vals].transpose.to_h
  end
end
