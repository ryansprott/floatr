class Type21Specific < ActiveRecord::Base
  belongs_to :message, optional: true
end
