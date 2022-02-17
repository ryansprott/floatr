class LiveMapMessage
  attr_accessor :mmsi, :messages

  def initialize(mmsi, messages)
    @mmsi = mmsi
    @messages = messages
    @source = @messages.first.source
  end

  def live_positions
    @messages.map do |message|
      {
        lat: message.position&.latitude,
        lon: message.position&.longitude,
        speed: message.course&.speed_over_ground,
        course: message.course&.to_s,
        distance: message.position&.miles_away || 0.0,
        created_at: message.created_at,
      }
    end.select do |msg|
      msg[:distance] > 0
    end
  end

  def destination
    @source.last_destination
  end

  def display_name
    @source.display_name
  end

  def country_flag
    @source.country_flag
  end

  def id
    @source.id
  end
end
