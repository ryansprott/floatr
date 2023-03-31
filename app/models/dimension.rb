class Dimension < ActiveRecord::Base
  belongs_to :message, optional: true

  attribute :ship_dimension_to_bow, :integer, default: 0
  attribute :ship_dimension_to_port, :integer, default: 0
  attribute :ship_dimension_to_stern, :integer, default: 0
  attribute :ship_dimension_to_starboard, :integer, default: 0

  include SerializesAttributes

  def weird?
    ship_dimension_to_port == 2 &&
      ship_dimension_to_starboard == 0 &&
      ship_dimension_to_bow == 16 &&
      ship_dimension_to_stern == 130
  end

  def totally_invalid?
    width_invalid? && length_invalid?
  end

  def total_area
    return 1 if totally_invalid? || weird?
    return width_in_meters if length_invalid?
    return length_in_meters if width_invalid?

    (length_in_meters * width_in_meters).to_i
  end

  def aspect_ratio
    return 1 if weird?

    length_in_meters.to_f / width_in_meters.to_f
  end

  def length_in_meters
    return 1 if length_invalid?

    ship_dimension_to_bow + ship_dimension_to_stern
  end

  def width_in_meters
    return 1 if width_invalid?

    ship_dimension_to_starboard + ship_dimension_to_port
  end

  private

  def width_invalid?
    [
      ship_dimension_to_port,
      ship_dimension_to_starboard
    ].all?(&:zero?)
  end

  def length_invalid?
    [
      ship_dimension_to_bow,
      ship_dimension_to_stern
    ].all?(&:zero?)
  end
end
