class Type9Specific < ActiveRecord::Base
  belongs_to :message, optional: true
end
