class Type5Specific < ActiveRecord::Base
  belongs_to :message, optional: true
end
