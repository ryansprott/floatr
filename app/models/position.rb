class Position < ActiveRecord::Base
  belongs_to :message, optional: true

  def to_s
    "#{latitude}, #{longitude}"
  end

  def miles_away
    home = Rails.application.credentials.ground_station_lat_lon
    lat1, lon1 = home.split(",").map(&:to_f)
    dLat = (latitude.to_f - lat1) * Math::PI / 180
    dLon = (longitude.to_f - lon1) * Math::PI / 180
    a = Math.sin(dLat / 2) *
        Math.sin(dLat / 2) +
        Math.cos(lat1 * Math::PI / 180) *
        Math.cos(latitude.to_f * Math::PI / 180) *
        Math.sin(dLon / 2) * Math.sin(dLon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    d = 6371 * c * (1 / 1.6)
    d.round(2)
  end
end
