class Dimension < ActiveRecord::Base
  belongs_to :message, optional: true

  attribute :ship_dimension_to_bow, :integer, default: 0
  attribute :ship_dimension_to_port, :integer, default: 0
  attribute :ship_dimension_to_stern, :integer, default: 0
  attribute :ship_dimension_to_starboard, :integer, default: 0

  include SerializesAttributes

  def invalid?
    [
      ship_dimension_to_bow,
      ship_dimension_to_port,
      ship_dimension_to_starboard,
      ship_dimension_to_stern,
    ].any?(&:zero?)
  end

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
end
