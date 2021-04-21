module SourcesHelper
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

  def parse_course(position)
    course_over_ground = position.course.course_over_ground
    output = course_over_ground.to_s

    case course_over_ground.to_i
    when 360
    when 0..45
      "heading N (#{output})"
    when 45..89
      "heading NE (#{output})"
    when 90..134
      "heading E (#{output})"
    when 135..179
      "heading SE (#{output})"
    when 180..224
      "heading S (#{output})"
    when 225..269
      "heading SW (#{output})"
    when 270..314
      "heading W (#{output})"
    when 315..359
      "heading NW (#{output})"
    end
  end

  def parse_speed(position)
    "speed #{position.course.speed_over_ground} knots"
  end

  def parse_seen(position)
    time_ago_in_words(position.updated_at) + " ago"
  end

  def parse_distance(position)
    "from #{position.miles_away} miles away"
  end
end
