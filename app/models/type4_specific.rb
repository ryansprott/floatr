class Type4Specific < ActiveRecord::Base
  belongs_to :message, optional: true
end
