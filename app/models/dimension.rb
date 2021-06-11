class Dimension < ActiveRecord::Base
  belongs_to :message, optional: true
  include SerializesAttributes

  def total_area
    return 1 if self.invalid?
    (length_in_meters * width_in_meters).to_i
  end

  private

  def length_in_meters
    ship_dimension_to_bow + ship_dimension_to_stern
  end

  def width_in_meters
    ship_dimension_to_starboard + ship_dimension_to_port
  end

  def invalid?
    [
      ship_dimension_to_bow,
      ship_dimension_to_port,
      ship_dimension_to_starboard,
      ship_dimension_to_stern,
    ].any?(&:zero?)
  end
end
