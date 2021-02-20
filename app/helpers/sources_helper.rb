module SourcesHelper
  require "yaml"

  def format_mid(mid)
    mids = YAML.load_file("db/yaml/mids.yml")
    arr = mids[mid[0...3].to_i]
    return arr ? arr[0].tr("A-Z", "\u{1F1E6}-\u{1F1FF}") + " " + arr[3] : ""
  end

  def format_message_type(message_type)
    case message_type
    when 1
      "Class A position report (type 1)"
    when 2
      "Class A position report (type 2)"
    when 3
      "Class A position report (type 3)"
    when 4
      "Base station report"
    when 5
      link_to "Class A static data report", source_static_path(@source, message_type)
    when 8
      link_to "Binary broadcast message", source_message_path(@source, message_type)
    when 9
      link_to "SAR aircraft position report", source_message_path(@source, message_type)
    when 10
      link_to "UTC/date inquiry", source_message_path(@source, message_type)
    when 15
      link_to "Interrogation", source_message_path(@source, message_type)
    when 18
      "Class B position report"
    when 21
      link_to "Aid-to-navigation report", source_static_path(@source, message_type)
    when 24
      link_to "Static data report", source_static_path(@source, message_type)
    when 27
      link_to "Long range AIS broadcast message", source_message_path(@source, message_type)
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
end
