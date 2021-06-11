class Source < ActiveRecord::Base
  require "yaml"

  has_many :messages, foreign_key: :source_mmsi, primary_key: :mmsi
  has_many :courses, through: :messages
  has_many :positions, through: :messages
  has_many :mysteries, through: :messages
  has_many :dimensions, through: :messages

  def self.recently_added
    where("messages_count > 1")
      .order(created_at: :desc)
      .limit(5)
  end

  def self.last_15_minutes
    where(updated_at: 15.minutes.ago..)
      .length
  end

  def self.last_minute
    where(updated_at: 1.minutes.ago..)
      .length
  end

  def display_name
    ship_name || callsign || mmsi.to_s
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
    country_code.tr("A-Z", "\u{1F1E6}-\u{1F1FF}")
  end

  private

  def parse_country_from_mmsi
    mids = YAML.load_file("db/yaml/mids.yml")
    keys = [:code_2, :code_3, :code_misc, :full_name]
    vals = mids[mmsi.to_s[0...3].to_i] || Array.new(4, "")
    [keys, vals].transpose.to_h
  end
end
