module PositionsHelper
  def parse_course(position)
    course_over_ground = position.course.course_over_ground
    course = course_over_ground.to_s

    case course_over_ground&.to_i
    when 360
    when 0..22
      "course #{course} (N)"
    when 23..44
      "course #{course} (NNE)"
    when 45..67
      "course #{course} (NE)"
    when 68..90
      "course #{course} (ENE)"
    when 91..112
      "course #{course} (E)"
    when 113..135
      "course #{course} (ESE)"
    when 136..157
      "course #{course} (SE)"
    when 158..179
      "course #{course} (SSE)"
    when 180..202
      "course #{course} (S)"
    when 203..225
      "course #{course} (SSW)"
    when 226..247
      "course #{course} (SW)"
    when 248..269
      "course #{course} (WSW)"
    when 270..292
      "course #{course} (W)"
    when 293..315
      "course #{course} (WNW)"
    when 316..337
      "course #{course} (NW)"
    when 338..359
      "course #{course} (NNW)"
    when nil
      "course unknown"
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
