class Type8Specific < Specific
  belongs_to :message, optional: true

  alias_attribute :beam, :dimension_beam
  alias_attribute :draught, :dimension_draught
  alias_attribute :length, :dimension_length
end
