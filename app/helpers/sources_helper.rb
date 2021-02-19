module SourcesHelper
  def format_mid(mid)
    case mid[0...3]
    when "205"
      return "Belgium"
    when "209", "210", "212"
      return "Cyprus"
    when "219", "220"
      return 'DK'.tr('A-Z', "\u{1F1E6}-\u{1F1FF}")
    when "224"
      return "Spain"
    when "232", "233", "234", "235"
      return "United Kingdom"
    when "215", "229", "248", "249", "256"
      return "Malta"
    when "237", "239", "240", "241"
      return "Greece"
    when "238"
      return "Croatia"
    when "244", "245", "246"
      return "Netherlands"
    when "255"
      return "Madeira"
    when "304", "305"
      return "Antigua and Barbuda"
    when "310"
      return "Bermuda"
    when "308", "309", "311"
      return "Bahamas"
    when "312"
      return "Belize"
    when "314"
      return "Barbados"
    when "316"
      return "Canada"
    when "319"
      return "Cayman Islands"
    when "303", "338", "366", "367", "368", "369"
      return 'US'.tr('A-Z', "\u{1F1E6}-\u{1F1FF}")
    when "339"
      return "Jamaica"
    when "345"
      return "Mexico"
    when "351", "352", "353", "354", "355", "356", "357", "370", "371", "372", "373", "374"
      return "Panama"
    when "375", "376", "377"
      return "Saint Vincent and the Grenadines"
    when "378"
      return "British Virgin Islands"
    when "431", "432"
      return "Japan"
    when "440", "441"
      return "Korea"
    when "477"
      return "Hong Kong"
    when "518"
      return "Cook Islands"
    when "538"
      return "Marshall Islands"
    when "548"
      return "Philippines"
    when "563", "564", "565", "566"
      return "Singapore"
    when "636", "637"
      return "Liberia"
    else
      return ""
    end
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
    # Get latitude and longitude
    lat1, lon1 = geo_a.split(",").map(&:to_f)
    lat2, lon2 = geo_b.split(",").map(&:to_f)

    # Calculate radial arcs for latitude and longitude
    dLat = (lat2 - lat1) * Math::PI / 180
    dLon = (lon2 - lon1) * Math::PI / 180

    a = Math.sin(dLat / 2) *
        Math.sin(dLat / 2) +
        Math.cos(lat1 * Math::PI / 180) *
        Math.cos(lat2 * Math::PI / 180) *
        Math.sin(dLon / 2) * Math.sin(dLon / 2)

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))

    d = 6371 * c * (1 / 1.6)
    d.round(2)
  end
end
