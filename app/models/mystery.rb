class Mystery < ApplicationRecord
  belongs_to :message, optional: true
end
