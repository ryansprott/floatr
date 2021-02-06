class Type10Specific < ActiveRecord::Base
  belongs_to :message, optional: true
end
