class Course < ActiveRecord::Base
  belongs_to :message, optional: true

  def speed_in_words
    "#{speed_over_ground} knots"
  end

  def to_s
    case course_over_ground&.to_i
    when 360
      "N"
    when 0..22
      "N"
    when 23..44
      "NNE"
    when 45..67
      "NE"
    when 68..90
      "ENE"
    when 91..112
      "E"
    when 113..135
      "ESE"
    when 136..157
      "SE"
    when 158..179
      "SSE"
    when 180..202
      "S"
    when 203..225
      "SSW"
    when 226..247
      "SW"
    when 248..269
      "WSW"
    when 270..292
      "W"
    when 293..315
      "WNW"
    when 316..337
      "NW"
    when 338..359
      "NNW"
    when nil
      "NONE"
    end
  end
end
