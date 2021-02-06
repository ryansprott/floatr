class Mystery < ActiveRecord::Base
  belongs_to :message, optional: true
end
