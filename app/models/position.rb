class Position < ActiveRecord::Base
  belongs_to :message, optional: true

  def to_s
    "#{latitude}, #{longitude}"
  end

  def distance_in_words
    "from #{miles_away} miles away"
  end

  def miles_away
    home = Rails.application.credentials.ground_station_lat_lon
    lat1, lon1 = home.split(',').map(&:to_f)
    d_lat = (latitude.to_f - lat1) * Math::PI / 180
    d_lon = (longitude.to_f - lon1) * Math::PI / 180
    a = Math.sin(d_lat / 2) *
        Math.sin(d_lat / 2) +
        Math.cos(lat1 * Math::PI / 180) *
        Math.cos(latitude.to_f * Math::PI / 180) *
        Math.sin(d_lon / 2) * Math.sin(d_lon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    d = 6371 * c * (1 / 1.6)
    latitude.to_f < 90.0 && longitude.to_f < 180.0 ? d.round(2) : 0.0
  end
end
