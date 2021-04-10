class LiveMapMessage
  attr_accessor :mmsi, :messages

  def initialize(mmsi, messages)
    @mmsi = mmsi
    @messages = messages
  end

  def live_positions
    @messages.map do |message|
      {
        lat: message.position&.latitude,
        lon: message.position&.longitude,
        speed: message.course&.speed_over_ground,
        course: message.course&.course_over_ground,
        distance: message.position&.miles_away || 0.0,
        created_at: message.created_at,
      }
    end
  end

  def static_data
    @messages.map(&:source).uniq.first
  end
end
