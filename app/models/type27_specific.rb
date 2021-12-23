class Type27Specific < Specific
  belongs_to :message, optional: true
  include HasNavigationalStatus
end
