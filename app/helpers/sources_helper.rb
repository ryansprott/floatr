class String
  def to_flag
    self.tr("A-Z", "\u{1F1E6}-\u{1F1FF}")
  end
end

module SourcesHelper
  require "yaml"

  def country_name(mmsi)
    country = parse_country_from_mmsi(mmsi)
    country[:full_name]
  end

  def country_code(mmsi)
    country = parse_country_from_mmsi(mmsi)
    country[:code_2]
  end

  def country_flag(mmsi)
    country_code(mmsi).to_flag
  end

  def parse_message_type(message_type, total_messages)
    case message_type
    when 1
      render "shared/message_button", {
        message_description: "Class A position report type 1",
        total_messages: total_messages,
      }
    when 2
      render "shared/message_button", {
        message_description: "Class A position report type 2",
        total_messages: total_messages,
      }
    when 3
      render "shared/message_button", {
        message_description: "Class A position report type 3",
        total_messages: total_messages,
      }
    when 4
      render "shared/message_button", {
        message_description: "Base station report",
        total_messages: total_messages,
      }
    when 5
      render "shared/message_link", {
        message_description: "Class A static data report",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 6
      render "shared/message_button", {
        message_description: "Binary addressed message",
        total_messages: total_messages,
      }
    when 7
      render "shared/message_link", {
        message_description: "Binary acknowledgement",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 8
      render "shared/message_link", {
        message_description: "Binary broadcast message",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 9
      render "shared/message_link", {
        message_description: "SAR aircraft position report",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 10
      render "shared/message_link", {
        message_description: "UTC/date inquiry",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 15
      render "shared/message_link", {
        message_description: "Interrogation",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 18
      render "shared/message_button", {
        message_description: "Class B position report",
        total_messages: total_messages,
      }
    when 21
      render "shared/message_link", {
        message_description: "Aid-to-navigation report",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 24
      render "shared/message_link", {
        message_description: "Static data report",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 27
      render "shared/message_link", {
        message_description: "Long range AIS broadcast message",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    else
      message_type
    end
  end

  def miles_away_in_words(geo_a, geo_b)
    lat1, lon1 = geo_a.split(",").map(&:to_f)
    lat2, lon2 = geo_b.split(",").map(&:to_f)
    dLat = (lat2 - lat1) * Math::PI / 180
    dLon = (lon2 - lon1) * Math::PI / 180
    a = Math.sin(dLat / 2) *
        Math.sin(dLat / 2) +
        Math.cos(lat1 * Math::PI / 180) *
        Math.cos(lat2 * Math::PI / 180) *
        Math.sin(dLon / 2) * Math.sin(dLon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    d = 6371 * c * (1 / 1.6)

    "from #{d.round(2)} miles away"
  end

  private

  def parse_country_from_mmsi(mmsi)
    mids = YAML.load_file("db/yaml/mids.yml")
    keys = [:code_2, :code_3, :code_misc, :full_name]
    vals = mids[mmsi[0...3].to_i] || Array.new(4, "")
    [keys, vals].transpose.to_h
  end
end
