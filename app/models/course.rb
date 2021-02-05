class Course < ApplicationRecord
  belongs_to :message, optional: true
end
