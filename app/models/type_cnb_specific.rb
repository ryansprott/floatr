class TypeCnbSpecific < Specific
  belongs_to :message, optional: true
  include HasNavigationalStatus
end
