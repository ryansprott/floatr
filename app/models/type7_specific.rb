class Type7Specific < ActiveRecord::Base
  belongs_to :message, optional: true
end
