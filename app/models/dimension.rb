class Dimension < ActiveRecord::Base
  belongs_to :message, optional: true

  alias_attribute :to_bow, :ship_dimension_to_bow
  alias_attribute :to_stern, :ship_dimension_to_stern
  alias_attribute :to_port, :ship_dimension_to_port
  alias_attribute :to_starboard, :ship_dimension_to_starboard
end
